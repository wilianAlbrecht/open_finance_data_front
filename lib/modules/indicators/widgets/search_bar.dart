import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/themes/extensions/app_card_theme.dart';

import '../indicators_controller.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController controller = TextEditingController();

  void onSearch() {
    final value = controller.text.trim();
    if (value.isEmpty) return;
    context.read<IndicatorsController>().search(context, value);
  }

  @override
  Widget build(BuildContext context) {
    final cardTheme = Theme.of(context).extension<AppCardTheme>()!;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // ================= TEXT FIELD =================
          Expanded(
            child: TextField(
              controller: controller,
              style: AppTextStyles.body.copyWith(color: textColor),
              decoration: InputDecoration(
                hintText: 'Buscar ativo (ex: PETR4, AAPL, TSLA)',
                hintStyle: AppTextStyles.body.copyWith(
                  color: textColor.withOpacity(0.6),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: textColor.withOpacity(0.7),
                ),

                filled: true,
                fillColor: cardTheme.background,

                contentPadding: AppLayout.paddingSm,

                border: OutlineInputBorder(
                  borderRadius: AppLayout.radiusSm,
                  borderSide: BorderSide(color: cardTheme.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppLayout.radiusSm,
                  borderSide: BorderSide(color: cardTheme.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppLayout.radiusSm,
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
              onSubmitted: (_) => onSearch(),
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          // ================= BUTTON =================
          ElevatedButton(
            onPressed: onSearch,
            child: Text(
              "Buscar",
              style: AppTextStyles.body.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
