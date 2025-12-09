import 'package:flutter/material.dart';
import 'indicator_grid.dart';

class IndicatorCategorySection extends StatefulWidget {
  final String title;
  final List<Widget> mainItems;
  final List<Widget> advancedItems;

  const IndicatorCategorySection({
    super.key,
    required this.title,
    required this.mainItems,
    required this.advancedItems,
  });

  @override
  State<IndicatorCategorySection> createState() =>
      _IndicatorCategorySectionState();
}

class _IndicatorCategorySectionState extends State<IndicatorCategorySection> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // título
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 20),
          child: Text(widget.title,
              style: Theme.of(context).textTheme.titleMedium),
        ),

        // indicadores principais
        IndicatorGrid(children: widget.mainItems),

        // avançados
        if (expanded && widget.advancedItems.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: IndicatorGrid(children: widget.advancedItems),
          ),

        // botão
        if (widget.advancedItems.isNotEmpty)
          TextButton(
            onPressed: () => setState(() => expanded = !expanded),
            child: Text(expanded ? "Ver menos" : "Ver mais"),
          ),
      ],
    );
  }
}
