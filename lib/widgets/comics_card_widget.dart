import 'package:flutter/material.dart';

class ComicsCardWidget extends StatelessWidget {
  const ComicsCardWidget({super.key, required this.image, required this.title});

  final Widget image;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        image,
        Container(
          padding: const EdgeInsets.all(5.0),
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Colors.black.withAlpha(0),
                Colors.black12,
                Colors.black45
              ],
            ),
          ),
          child: title,
        ),
      ],
    );
  }
}
