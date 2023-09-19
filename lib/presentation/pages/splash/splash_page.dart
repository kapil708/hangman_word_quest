import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hangman_word_quest/core/assets/image_assets.dart';

import '../../../core/route/route_names.dart';
import '../../../injection_container.dart';
import '../../bloc/splash/splash_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator.get<SplashBloc>()..add(Init()),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is STHome) {
          context.goNamed(RouteName.home);
        } else {
          context.goNamed(RouteName.login);
        }
      },
      child: Scaffold(
        body: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImageAssets.hangmanLogin,
                width: MediaQuery.sizeOf(context).width * 0.9,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
