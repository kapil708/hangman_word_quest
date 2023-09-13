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
  @override
  Widget build(BuildContext context) {
    double boxSize = (MediaQuery.sizeOf(context).width - 32) / 7;
    double wordSize = (MediaQuery.sizeOf(context).width - 32) / 10;

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: BlocConsumer<GamePlayBloc, GamePlayState>(
        listener: (context, state) {
          if (state is STWordFailed) {
            Navigator.pop(context);
          } else if (state is STAttemptOver) {
            showFailedDialog(context);
          } else if (state is STWinner) {
            showWinnerDialog(context);
          }
        },
        builder: (context, state) {
          GamePlayBloc gBloc = context.read<GamePlayBloc>();

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
                    figureImage(gBloc.attempt >= 0, ImageAssets.hmHang),
                    figureImage(gBloc.attempt >= 1, ImageAssets.hmHead),
                    figureImage(gBloc.attempt >= 2, ImageAssets.hmBody),
                    figureImage(gBloc.attempt >= 3, ImageAssets.hmRightArm),
                    figureImage(gBloc.attempt >= 4, ImageAssets.hmLeftArm),
                    figureImage(gBloc.attempt >= 5, ImageAssets.hmRightLag),
                    figureImage(gBloc.attempt >= 6, ImageAssets.hmLeftLag),
                  ],
                ),
                const Spacer(),

                // Word
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...gBloc.word.name.characters.map((e) {
                      return Container(
                        decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
                        margin: const EdgeInsets.only(right: 10),
                        width: wordSize,
                        alignment: Alignment.center,
                        child: Text(
                          gBloc.correctAlphabets.contains(e.toLowerCase()) ? e.toUpperCase() : '',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      );
                    }),
                  ],
                ),
                const VSpace(32),

                // Hint
                RichText(
                  //textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Animal: ",
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: gBloc.word.hint,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                const VSpace(8),

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
                              if (!gBloc.correctAlphabets.contains(e) && !gBloc.wrongAlphabets.contains(e)) {
                                //characterClick(e.toLowerCase());
                                context.read<GamePlayBloc>().add(CharacterClick(e.toLowerCase()));
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
                          if (gBloc.correctAlphabets.contains(e.toLowerCase()))
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: Icon(
                                Icons.check,
                                color: Colors.green,
                                size: boxSize - 10,
                              ),
                            ),
                          if (gBloc.wrongAlphabets.contains(e.toLowerCase()))
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

  void showFailedDialog(BuildContext context) {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext _) {
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
                      context.read<GamePlayBloc>().add(Retry());
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

  void showWinnerDialog(BuildContext context) {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext _) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(LottieAssets.win, height: 300),
                  Text(
                    "You Win",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const VSpace(16),
                  FilledButton(
                    onPressed: () {
                      context.read<GamePlayBloc>().add(Retry());
                      Navigator.pop(context);
                    },
                    child: const Text("Next"),
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
