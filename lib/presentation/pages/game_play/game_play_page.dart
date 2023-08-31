import 'package:flutter/material.dart';
import 'package:hangman_word_quest/core/assets/image_assets.dart';
import 'package:hangman_word_quest/core/extensions/spacing.dart';
import 'package:lottie/lottie.dart';

import '../../../core/const/constants.dart';

class GamePlayPage extends StatelessWidget {
  const GamePlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GamePlayView();
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
  }

  @override
  Widget build(BuildContext context) {
    double boxSize = (MediaQuery.sizeOf(context).width - 32) / 7;
    double wordSize = (MediaQuery.sizeOf(context).width - 32) / 10;

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Padding(
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
                  onTap: () {
                    showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Dialog(
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
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Retry"),
                                ),
                                const VSpace(16),
                              ],
                            ),
                          );
                        });
                  },
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
                figureImage(attempt >= 0, ImageAssets.hmHang),
                figureImage(attempt >= 1, ImageAssets.hmHead),
                figureImage(attempt >= 2, ImageAssets.hmBody),
                figureImage(attempt >= 3, ImageAssets.hmRightArm),
                figureImage(attempt >= 4, ImageAssets.hmLeftArm),
                figureImage(attempt >= 5, ImageAssets.hmRightLag),
                figureImage(attempt >= 6, ImageAssets.hmLeftLag),
              ],
            ),
            const Spacer(),

            // Word
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...word.characters.map((e) {
                  return Container(
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
                    margin: const EdgeInsets.only(right: 10),
                    width: wordSize,
                    alignment: Alignment.center,
                    child: Text(
                      correctAlphabets.contains(e.toLowerCase()) ? e.toUpperCase() : '',
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
                          if (!correctAlphabets.contains(e) && !wrongAlphabets.contains(e)) {
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
                      if (correctAlphabets.contains(e.toLowerCase()))
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: Icon(
                            Icons.check,
                            color: Colors.green,
                            size: boxSize - 10,
                          ),
                        ),
                      if (wrongAlphabets.contains(e.toLowerCase()))
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
      ),
    );
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
