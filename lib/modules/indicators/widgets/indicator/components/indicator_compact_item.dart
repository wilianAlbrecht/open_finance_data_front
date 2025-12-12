import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_theme_package.dart';

class IndicatorCompactItem extends StatelessWidget {
  final String label;
  final String value;

  const IndicatorCompactItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final pkg = Theme.of(context).extension<AppThemePackage>()!;
    final card = pkg.indicatorCard;
    final text = pkg.text;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 120,
        maxWidth: 160, // cabe duas colunas no painel
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: card.background,
          borderRadius: BorderRadius.circular(card.radius),
          border: Border.all(color: card.borderColor, width: 1),
        ),
        child: Row(
          children: [
            // ================= LABEL =================
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: text.bodySmall.copyWith(
                  fontSize: 11,   // redução mantendo padrão
                  color: text.bodySmall.color,
                ),
              ),
            ),

            const SizedBox(width: 4),

            // ================= VALUE =================
            Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: text.number.copyWith(
                fontSize: 12,   // redução mantendo padrão numérico
              ),
            ),
          ],
        ),
      ),
    );
  }
}
