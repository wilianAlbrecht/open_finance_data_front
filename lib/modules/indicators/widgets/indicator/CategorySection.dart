import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_page_layout_theme.dart';

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
    final layout = Theme.of(context).extension<AppPageLayoutTheme>()!;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: layout.maxContentWidth),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,  // ⭐ CENTRALIZA TUDO

          children: [
            // ====== TÍTULO ======
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ====== CARDS PRINCIPAIS ======
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,            // ⭐ ALINHA OS CARDS
              crossAxisAlignment: WrapCrossAlignment.center,
              children: widget.primaryCards,
            ),

            // ====== CARDS SECUNDÁRIOS ======
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

            // ====== BOTÃO EXPANDIR ======
            TextButton(
              onPressed: () => setState(() => expanded = !expanded),
              child: Text(
                expanded ? "Mostrar menos ▲" : "Mostrar mais ▼",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14,
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
