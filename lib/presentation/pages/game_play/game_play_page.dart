import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../core/assets/image_assets.dart';
import '../../../core/const/constants.dart';
import '../../../core/extensions/spacing.dart';
import '../../../injection_container.dart';
import '../../bloc/game_play/game_play_bloc.dart';

class GamePlayPage extends StatelessWidget {
  const GamePlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator.get<GamePlayBloc>()..add(OnGamePlayInit()),
      child: const GamePlayView(),
    );
  }
}

class GamePlayView extends StatefulWidget {
  const GamePlayView({super.key});

  @override
  State<GamePlayView> createState() => _GamePlayViewState();
}

class _GamePlayViewState extends State<GamePlayView> {
  static const String word = "Earth";
  List<String> wrongAlphabets = [];
  List<String> correctAlphabets = [];
  int attempt = 0;

  characterClick(String character) {
    if (word.toLowerCase().contains(character)) {
      correctAlphabets.add(character);
    } else {
      wrongAlphabets.add(character);
      attempt++;
    }
    setState(() {});

    if (attempt == 6) {
      showFailedDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    double boxSize = (MediaQuery.sizeOf(context).width - 32) / 7;
    double wordSize = (MediaQuery.sizeOf(context).width - 32) / 10;

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: BlocConsumer<GamePlayBloc, GamePlayState>(
        listener: (context, state) {
          if (state is WordFailed) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.home_outlined,
                        size: 40,
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        "Level 1",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                // Figure
                Stack(
                  children: [
                    figureImage(state.attempt >= 0, ImageAssets.hmHang),
                    figureImage(state.attempt >= 1, ImageAssets.hmHead),
                    figureImage(state.attempt >= 2, ImageAssets.hmBody),
                    figureImage(state.attempt >= 3, ImageAssets.hmRightArm),
                    figureImage(state.attempt >= 4, ImageAssets.hmLeftArm),
                    figureImage(state.attempt >= 5, ImageAssets.hmRightLag),
                    figureImage(state.attempt >= 6, ImageAssets.hmLeftLag),
                  ],
                ),
                const Spacer(),

                // Word
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...state.word.name.characters.map((e) {
                      return Container(
                        decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
                        margin: const EdgeInsets.only(right: 10),
                        width: wordSize,
                        alignment: Alignment.center,
                        child: Text(
                          state.correctAlphabets.contains(e.toLowerCase()) ? e.toUpperCase() : '',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      );
                    }),
                  ],
                ),
                const VSpace(32),

                // Alphabets
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    ...alphabets.map((e) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              if (!state.correctAlphabets.contains(e) && !state.wrongAlphabets.contains(e)) {
                                characterClick(e.toLowerCase());
                              }
                            },
                            child: Container(
                              // decoration: BoxDecoration(border: Border.all()),
                              width: boxSize,
                              height: boxSize,
                              alignment: Alignment.center,
                              child: Text(
                                e,
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                          ),
                          if (state.correctAlphabets.contains(e.toLowerCase()))
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: Icon(
                                Icons.check,
                                color: Colors.green,
                                size: boxSize - 10,
                              ),
                            ),
                          if (state.wrongAlphabets.contains(e.toLowerCase()))
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: Icon(
                                Icons.highlight_remove,
                                color: Colors.red,
                                size: boxSize - 10,
                              ),
                            ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
                const VSpace(32),
              ],
            ),
          );
        },
      ),
    );
  }

  void showFailedDialog() {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(LottieAssets.sad, height: 200),
                  Text(
                    "OOPS... You Failed!",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const VSpace(16),
                  FilledButton(
                    onPressed: () {
                      wrongAlphabets = [];
                      correctAlphabets = [];
                      attempt = 0;

                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: const Text("Retry"),
                  ),
                  const VSpace(16),
                ],
              ),
            ),
          );
        });
  }

  Widget figureImage(bool visible, String path) {
    return Visibility(
        visible: visible,
        child: SizedBox(
          width: 200,
          height: 200,
          child: Image.asset(path, color: Colors.black),
        ));
  }
}
