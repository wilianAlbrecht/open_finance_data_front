import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class CategoriesPlaceholder extends StatelessWidget {
  const CategoriesPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium!.color;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Text(
        'Categorias de Indicadores (em breve)',
        style: AppTextStyles.subtitle.copyWith(color: textColor),
      ),
    );
  }
}
