import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hangman_word_quest/core/assets/image_assets.dart';
import 'package:hangman_word_quest/core/extensions/spacing.dart';
import 'package:hangman_word_quest/core/extensions/textstyle_extensions.dart';

import '../../../core/enums/app_theme_mode.dart';
import '../../../core/enums/language.dart';
import '../../bloc/app/app_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsView();
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  void signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    print(credential.toString());

    // Once signed in, return the UserCredential
    //return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.language, style: Theme.of(context).textTheme.titleMedium),
              //const SizedBox(height: 8),
              BlocBuilder<AppBloc, AppState>(
                builder: (context, state) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    trailing: Image.asset(state.selectedLanguage.image, height: 32, width: 32),
                    title: Text(state.selectedLanguage.text),
                    onTap: () => showLanguageBottomSheet(context),
                  );
                },
              ),
              const VSpace(24),
              Text(l10n.theme, style: Theme.of(context).textTheme.titleMedium),
              const VSpace(16),
              BlocBuilder<AppBloc, AppState>(
                builder: (context, state) {
                  return SegmentedButton<AppThemeMode>(
                    segments: <ButtonSegment<AppThemeMode>>[
                      ...AppThemeMode.values.map((themeMode) {
                        return ButtonSegment(
                          value: themeMode,
                          icon: Icon(themeMode.iconData),
                          label: Text(themeMode.text),
                        );
                      }),
                    ],
                    multiSelectionEnabled: false,
                    showSelectedIcon: false,
                    selected: <AppThemeMode>{state.selectedThemeMode},
                    onSelectionChanged: (Set<AppThemeMode> selectedMode) {
                      context.read<AppBloc>().add(ChangeThemeMode(selectedThemeMode: selectedMode.first));
                    },
                  );
                },
              ),
              const VSpace(64),
              Text(
                "Join HangMan with your favorite social media account",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const VSpace(16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  //color: const Color(0xFF3D58AD).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImageAssets.facebook,
                      height: 24,
                      width: 24,
                    ),
                    const HSpace(4),
                    Text(
                      "Join with Facebook",
                      style: Theme.of(context).textTheme.titleMedium?.textColor(const Color(0xFF3D58AD)),
                    ),
                  ],
                ),
              ),
              const VSpace(16),
              InkWell(
                onTap: () => signInWithGoogle(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    // color: const Color(0xFFDE5241).withOpacity(0.2),
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        ImageAssets.google,
                        height: 24,
                        width: 24,
                      ),
                      const HSpace(8),
                      Text(
                        "Join with Google",
                        style: Theme.of(context).textTheme.titleMedium?.textColor(const Color(0xFFDE5241)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.chooseLanguage,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16.0),
              BlocBuilder<AppBloc, AppState>(
                builder: (context, state) {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: Language.values.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          context.read<AppBloc>().add(ChangeLanguage(selectedLanguage: Language.values[index]));
                          Future.delayed(const Duration(milliseconds: 300)).then((value) => Navigator.of(context).pop());
                        },
                        leading: ClipOval(
                          child: Image.asset(
                            Language.values[index].image,
                            height: 32.0,
                            width: 32.0,
                          ),
                        ),
                        title: Text(Language.values[index].text),
                        trailing: Language.values[index] == state.selectedLanguage
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: Language.values[index] == state.selectedLanguage ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5) : BorderSide(color: Colors.grey[300]!),
                        ),
                        tileColor: Language.values[index] == state.selectedLanguage ? Theme.of(context).colorScheme.primary.withOpacity(0.05) : null,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 16.0);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
