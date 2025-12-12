import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_theme_package.dart';
import 'package:open_finance_data_front/modules/indicators/controllers/financial_indicators_controller.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_spacing.dart';
import '../controllers/price_chart_controller.dart';

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
    context.read<FinancialIndicatorsController>().search(value);
  }

  @override
  Widget build(BuildContext context) {
    final pkg = Theme.of(context).extension<AppThemePackage>()!;
    final search = pkg.searchBar;
    final text = pkg.text;

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
              style: text.body,

              decoration: InputDecoration(
                filled: true,
                fillColor: search.background,
                hintText: 'Buscar ativo (ex: PETR4.SA, AAPL, TSLA)',
                hintStyle: text.bodySmall,

                prefixIcon: Icon(
                  Icons.search,
                  color: search.iconColor,
                ),

                contentPadding: search.padding,

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(search.radius),
                  borderSide: BorderSide(color: search.borderColor),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(search.radius),
                  borderSide: BorderSide(color: search.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(search.radius),
                  borderSide: BorderSide(
                    color: search.focusColor,
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
            style: ElevatedButton.styleFrom(
              backgroundColor: search.focusColor,
            ),
            onPressed: onSearch,
            child: Text(
              "Buscar",
              style: text.button.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
