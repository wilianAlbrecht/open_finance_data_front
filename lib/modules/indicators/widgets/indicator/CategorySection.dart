import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/app_layout.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_theme_package.dart';

class CategorySection extends StatefulWidget {
  final String title;
  final List<Widget> primaryCards;
  final List<Widget> secondaryCards;

  const CategorySection({
    super.key,
    required this.title,
    required this.primaryCards,
    required this.secondaryCards,
  });

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final pkg = Theme.of(context).extension<AppThemePackage>()!;
    final text = pkg.text;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: AppLayout.maxContentWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            // ============================
            //   TÍTULO DA CATEGORIA
            // ============================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(
                widget.title,
                style: text.sectionTitle, // ✔ feito pelo tema
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 12),

            // ============================
            //   CARDS PRINCIPAIS
            // ============================
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: widget.primaryCards,
            ),

            // ============================
            //   CARDS SECUNDÁRIOS
            // ============================
            if (expanded) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: widget.secondaryCards,
              ),
            ],

            const SizedBox(height: 10),

            // ============================
            //   BOTÃO EXPANDIR
            // ============================
            TextButton(
              onPressed: () => setState(() => expanded = !expanded),
              child: Text(
                expanded ? "Mostrar menos ▲" : "Mostrar mais ▼",
                style: text.button.copyWith(
                  color: pkg.header.background, 
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
