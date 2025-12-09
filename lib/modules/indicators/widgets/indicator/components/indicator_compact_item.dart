import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/app_text_styles.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_card_theme.dart';

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
    final cardTheme = Theme.of(context).extension<AppCardTheme>()!;
    final textStyle = AppTextStyles.bodySm(context);
    final valueStyle = AppTextStyles.bodySmBold(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 120,
        maxWidth: 160, // <-- agora cabem duas colunas no painel
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: cardTheme.background,
          borderRadius: BorderRadius.circular(cardTheme.radius),
          border: Border.all(color: cardTheme.borderColor, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: textStyle.copyWith(fontSize: 11), // reduzido
                softWrap: false,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: valueStyle.copyWith(fontSize: 12), // reduzido
              textAlign: TextAlign.right,
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
          ],
        ),
      ),
    );
  }
}
