import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/assets/image_assets.dart';
import '../../../core/extensions/spacing.dart';
import '../../../core/extensions/text_style_extensions.dart';
import '../../../core/route/route_names.dart';
import '../../../injection_container.dart';
import '../../bloc/login/login_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator.get<LoginCubit>(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is STLoginSuccess) {
            context.goNamed(RouteName.home);
          } else if (state is STLoginFailed) {
            showErrorAlertDialog(context, state.message);
          }
        },
        builder: (context, state) {
          return SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Image.asset(
                        ImageAssets.hangmanLogin,
                        width: MediaQuery.sizeOf(context).width * 0.8,
                      ),
                      /*const VSpace(64),
                      Text(
                        "Hello!",
                        style: Theme.of(context).textTheme.headlineLarge?.bold,
                        textAlign: TextAlign.center,
                      ),
                      const VSpace(8),
                      Text(
                        "Welcome to Hangman Word Quest",
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),*/
                      const Spacer(),
                      InkWell(
                        onTap: () => context.read<LoginCubit>().googleSignIn(),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
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
                      const VSpace(16),
                      InkWell(
                        onTap: () => context.read<LoginCubit>().anonymousLogin(),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                ImageAssets.spy,
                                height: 24,
                                width: 24,
                              ),
                              const HSpace(8),
                              Text(
                                "Join as Guest",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const VSpace(32),
                    ],
                  ),
                  // Loading
                  if (state is STLoading)
                    const Center(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void showErrorAlertDialog(BuildContext context, String message) {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext _) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog.adaptive(
              title: const Text("Login failed"),
              content: Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              actions: [
                TextButton(
                  child: const Text('Retry'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        });
  }
}
