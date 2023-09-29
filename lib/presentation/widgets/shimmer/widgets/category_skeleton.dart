import 'package:flutter/material.dart';

import 'box_decoration.dart';

class CategorySkeleton extends StatelessWidget {
  final Animation<double> animation;
  const CategorySkeleton({Key? key, required this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: Theme.of(context).colorScheme.background,
      width: width,
      margin: const EdgeInsets.only(bottom: 10),
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: [
          ...[1, 2, 3, 4].map(
            (e) => Container(
              height: width * 0.44,
              width: width * 0.44,
              decoration: ShimmerBoxDecoration(animation),
            ),
          ),
        ],
      ),
    );
  }
}
