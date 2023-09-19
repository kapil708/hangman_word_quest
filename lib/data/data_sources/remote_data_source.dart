import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hangman_word_quest/core/const/avatar_list.dart';
import 'package:http/http.dart' as http;

import '../../core/const/word_list.dart';
import '../../core/error/exceptions.dart';
import '../../core/services/helper.dart';
import '../../injection_container.dart';
import '../models/category/category_model.dart';
import '../models/login/login_model.dart';
import '../models/user/user_model.dart';
import '../models/word/word_model.dart';
import 'api_methods.dart';
import 'local_data_source.dart';

Map<String, String>? get _headers => {'Accept': 'application/json', 'Content-Type': 'application/json'};

abstract class RemoteDataSource {
  Future<LoginModel> login(Map<String, dynamic> body);
  Future<UserModel> googleAnonymousLogin();
  Future<UserModel> linkGoogleAccount();
  Future<UserModel> googleLogin();
  Future<List<CategoryModel>> getCategoryList();
  Future<WordModel> getWordByType({required String categoryId});
  Future<Map<String, dynamic>> updatePlayedWord({required String wordId, required int score});
  Future<List<WordModel>> getWordListByType(String categoryId);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl({required this.client});

  final _db = FirebaseFirestore.instance;

  @override
  Future<LoginModel> login(Map<String, dynamic> body) async {
    final http.Response response = await client.post(
      Uri.parse(ApiMethods.login),
      body: jsonEncode(body),
      headers: _headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      return LoginModel.fromJson(data['data']);
    } else {
      return Future.error(handleErrorResponse(response));
    }
  }

  @override
  Future<UserModel> googleAnonymousLogin() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();

      String name = getRandomString(10);
      String image = getRandomElement(avatarList);

      UserModel userModel = UserModel(
        id: userCredential.user?.uid ?? '1',
        isAnonymous: true,
        name: name,
        image: image,
        level: 0,
        score: 0,
      );

      await _db.collection('user').doc(userModel.id).set(userModel.toJson());

      return userModel;
    } on FirebaseAuthException catch (e) {
      return Future.error(RemoteException(statusCode: 422, message: e.message ?? e.code));
    }
  }

  @override
  Future<UserModel> linkGoogleAccount() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Link user
      final userCredential = await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);

      // get user data
      var userData = locator.get<LocalDataSource>().getUser();

      UserModel userModel = UserModel(
        id: userCredential?.user?.uid ?? '1',
        isAnonymous: userCredential?.user?.isAnonymous ?? true,
        name: userCredential?.user?.displayName ?? userCredential?.user?.providerData.first.displayName,
        image: userCredential?.user?.photoURL ?? userCredential?.user?.providerData.first.photoURL,
        level: userData['level'],
        score: userData['score'],
      );

      // Update user data
      await _db.collection('user').doc(userModel.id).update(userModel.toJson());

      return userModel;
    } on FirebaseAuthException catch (e) {
      return Future.error(RemoteException(statusCode: 422, message: e.message ?? e.code));
    }
  }

  @override
  Future<UserModel> googleLogin() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

        // Once signed in, return the UserCredential
        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        UserModel userModel = UserModel(
          id: userCredential.user?.uid ?? '1',
          isAnonymous: false,
          name: userCredential.user?.displayName ?? userCredential.user?.providerData.first.displayName,
          image: userCredential.user?.photoURL ?? userCredential.user?.providerData.first.photoURL,
          level: 0,
          score: 0,
        );

        // Update user data
        await _db.collection('user').doc(userModel.id).set(userModel.toJson());

        return userModel;
      } else {
        return Future.error(RemoteException(statusCode: 422, message: 'User return from google without login.'));
      }
    } on FirebaseAuthException catch (e) {
      return Future.error(RemoteException(statusCode: 422, message: e.message ?? e.code));
    }
  }

  @override
  Future<List<CategoryModel>> getCategoryList() async {
    final snapshot = await _db.collection('category').get();
    final userData = snapshot.docs.map((e) {
      var data = e.data();
      data['id'] = e.id;
      return CategoryModel.fromJson(data);
    }).toList();
    return userData;
  }

  @override
  Future<WordModel> getWordByType({required String categoryId}) async {
    // get user data
    var userData = locator.get<LocalDataSource>().getUser();

    // get played words base on user id
    final wordPlayedSnapshot = await _db.collection('word_played').where('user_id', isEqualTo: userData['id']).get();

    // get words id from array
    final playedWords = wordPlayedSnapshot.docs.map((e) => e['word_id']).toList();

    // get word from db which is pending to play
    final QuerySnapshot<Map<String, dynamic>> word;

    if (playedWords.isNotEmpty) {
      word = await _db.collection('word').where('category_id', isEqualTo: categoryId).where('id', whereNotIn: playedWords).limit(1).get();
    } else {
      word = await _db.collection('word').where('category_id', isEqualTo: categoryId).limit(1).get();
    }

    if (word.docs.isNotEmpty) {
      return word.docs.map((e) {
        var data = e.data();
        data['id'] = e.id;
        return WordModel.fromJson(data);
      }).first;
    } else {
      return Future.error(RemoteException(statusCode: 12133, message: 'You have played all the words in this category'));
    }

    // List selectedWordList = wordList.where((word) => word['category_id'] == categoryId).toList();
    // return selectedWordList.map((category) => WordModel.fromJson(category)).first;
  }

  @override
  Future<Map<String, dynamic>> updatePlayedWord({required String wordId, required int score}) async {
    // get user data
    var userData = locator.get<LocalDataSource>().getUser();

    var data = {'user_id': userData['id'], 'word_id': wordId};
    await _db.collection('word_played').add(data);

    // Update user data
    int userLevel = int.parse((userData['level'] ?? '0').toString());
    int userScore = int.parse((userData['score'] ?? '0').toString());

    var newLevel = ++userLevel;
    var newScore = userScore + score;

    await _db.collection('user').doc(userData['id']).update({
      'level': newLevel,
      'score': newScore,
    });

    // Update local data
    userData['level'] = newLevel;
    userData['score'] = newScore;
    locator.get<LocalDataSource>().cacheUser(userData);

    return {'score': newScore, 'level': newLevel};
  }

  @override
  Future<List<WordModel>> getWordListByType(String categoryId) async {
    List selectedWordList = wordList.where((word) => word['category_id'] == categoryId).toList();
    return selectedWordList.map((category) => WordModel.fromJson(category)).toList();
  }
}

Uri getUrlWithParams(String url, Map<String, dynamic> queryParameters) {
  String urlParams = queryParameters.entries.map((e) => '${e.key}=${e.value}').join('&');

  if (urlParams.isNotEmpty) {
    url += '?$urlParams';
  }

  return Uri.parse(url);
}

Exception handleErrorResponse(http.Response response) {
  var data = jsonDecode(response.body);

  return RemoteException(
    statusCode: response.statusCode,
    message: data['message'] ?? response.statusCode == 422 ? 'Validation failed' : 'Server exception',
  );
}
