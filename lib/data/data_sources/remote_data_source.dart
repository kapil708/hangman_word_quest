import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/const/category_list.dart';
import '../../core/const/word_list.dart';
import '../../core/error/exceptions.dart';
import '../models/category/category_model.dart';
import '../models/login/login_model.dart';
import '../models/word/word_model.dart';
import 'api_methods.dart';

Map<String, String>? get _headers => {'Accept': 'application/json', 'Content-Type': 'application/json'};

abstract class RemoteDataSource {
  Future<LoginModel> login(Map<String, dynamic> body);
  Future<List<CategoryModel>> getCategoryList();
  Future<WordModel> getWordByType(String categoryId);
  Future<List<WordModel>> getWordListByType(String categoryId);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl({required this.client});

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
  Future<List<CategoryModel>> getCategoryList() async {
    return categoryList.map((category) => CategoryModel.fromJson(category)).toList();
  }

  @override
  Future<WordModel> getWordByType(String categoryId) async {
    List selectedWordList = wordList.where((word) => word['category_id'] == categoryId).toList();
    return selectedWordList.map((category) => WordModel.fromJson(category)).first;
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

  if (response.statusCode == 422) {
    return ValidationException(
      errors: data['errors'],
      message: data['message'] ?? 'Validation failed',
    );
  } else {
    return ServerException(
      statusCode: response.statusCode,
      message: data['message'] ?? 'Server exception',
    );
  }
}
