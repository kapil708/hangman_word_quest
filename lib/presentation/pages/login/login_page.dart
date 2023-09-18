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
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is STLoginSuccess) {
            context.goNamed(RouteName.home);
          } else if (state is STLoginFailed) {
            print(state.message);
          }
        },
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Image.asset(
                  ImageAssets.hangmanLogin,
                  height: 200,
                  width: 200,
                ),
                const VSpace(16),
                Text(
                  "Hello!",
                  style: Theme.of(context).textTheme.displaySmall?.bold,
                  textAlign: TextAlign.center,
                ),
                const VSpace(8),
                Text(
                  "Welcome to Hangman Word Quest \nEmbark on a Word Quest and Defeat the Gallows!",
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
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
          ),
        ),
      ),
    );
  }
}
