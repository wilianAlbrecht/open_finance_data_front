import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_theme_package.dart';
import 'indicator_grid.dart';

class IndicatorCategorySection extends StatefulWidget {
  final String title;
  final List<Widget> mainItems;
  final List<Widget> advancedItems;
  final int columns;

  const IndicatorCategorySection({
    super.key,
    required this.title,
    required this.mainItems,
    required this.advancedItems,
    required this.columns,
  });

  @override
  State<IndicatorCategorySection> createState() =>
      _IndicatorCategorySectionState();
}

class _IndicatorCategorySectionState extends State<IndicatorCategorySection> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final pkg = Theme.of(context).extension<AppThemePackage>()!;
    final text = pkg.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =======================
        // TÍTULO DA CATEGORIA
        // =======================
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 20),
          child: Text(
            widget.title,
            style: text.sectionTitle,
          ),
        ),

        // =======================
        // INDICADORES PRINCIPAIS
        // =======================
        IndicatorGrid(columns: widget.columns, children: widget.mainItems),

        // =======================
        // INDICADORES AVANÇADOS
        // =======================
        if (expanded && widget.advancedItems.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: IndicatorGrid(columns: widget.columns, children: widget.advancedItems),
          ),

        // =======================
        // BOTÃO EXPANDIR
        // =======================
        if (widget.advancedItems.isNotEmpty)
          TextButton(
            onPressed: () => setState(() => expanded = !expanded),
            child: Text(
              expanded ? "Ver menos" : "Ver mais",
              style: text.button,
            ),
          ),
      ],
    );
  }
}
