import 'package:flutter/material.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/price_chart_container.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/themes/extensions/app_card_theme.dart';
import '../../../core/widgets/theme_toggle_button.dart';
import 'indicators_controller.dart';
import 'widgets/categories_placeholder.dart';
import 'widgets/chart/price_filter_bar.dart';
import 'widgets/search_bar.dart';

class IndicatorsPage extends StatelessWidget {
  const IndicatorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cardTheme = Theme.of(context).extension<AppCardTheme>()!;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OpenFinanceData',
          style: AppTextStyles.title.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        elevation: 0,
        actions: const [ThemeToggleButton()],
      ),

      body: ListView(
        padding: EdgeInsets.zero, // remove padding padrão
        children: [
          // ========= SEARCH BAR =========
          const SearchBarWidget(),

          // ========= CONSUMER PRINCIPAL =========
          Consumer<IndicatorsController>(
            builder: (context, controller, _) {
              // ===== LOADING =====
              if (controller.isLoading) {
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              // ===== NENHUM ATIVO CARREGADO =====
              if (controller.close.isEmpty) {
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
                      "Busque um ativo para visualizar o gráfico",
                      style: AppTextStyles.body.copyWith(
                        fontSize: 16,
                        color: textColor.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              // ===== RESULTADO CARREGADO =====
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 FILTROS DO GRÁFICO
                  const PriceFilterBar(),

                  // 🔹 GRÁFICO
                  PriceChartContainer(
                    chart: controller.cachedChart!,
                    series: controller.buildSeries(context),
                  ),
                ],
              );
            },
          ),

          // ========= PLACEHOLDER DAS CATEGORIAS =========
          const CategoriesPlaceholder(),
        ],
      ),
    );
  }
}
