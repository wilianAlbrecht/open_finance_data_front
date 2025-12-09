import 'package:flutter/material.dart';

class IndicatorGrid extends StatelessWidget {
  final List<Widget> children;

  const IndicatorGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= 1300 ? 3 : 2;

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: children.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3.6, // compacto e proporcional
      ),
      itemBuilder: (_, i) => children[i],
    );
  }
}
