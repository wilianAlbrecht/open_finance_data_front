import 'package:flutter/material.dart';

class PageLoadingBar extends StatelessWidget {
  final Color color;

  const PageLoadingBar({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2,
      child: LinearProgressIndicator(
        color: color,
      ),
    );
  }
}
