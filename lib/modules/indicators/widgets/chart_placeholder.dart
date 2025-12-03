import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/themes/extensions/app_card_theme.dart';

class ChartPlaceholder extends StatelessWidget {
  const ChartPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final cardTheme = Theme.of(context).extension<AppCardTheme>()!;
    final textColor = Theme.of(context).textTheme.bodyMedium!.color;

    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      padding: AppLayout.paddingMd,
      decoration: BoxDecoration(
        color: cardTheme.background,
        borderRadius: AppLayout.radiusMd,
      ),
      child: Center(
        child: Text(
          'Gráfico (em breve)',
          style: AppTextStyles.subtitle.copyWith(color: textColor),
        ),
      ),
    );
  }
}
