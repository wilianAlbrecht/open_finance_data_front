import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/widgets/page_container.dart';
import 'package:open_finance_data_front/modules/indicators/controllers/financial_indicators_controller.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/chart_mode_selector.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/filters/ohlc_filter_bar.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/filters/range_filter_bar.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/price/price_chart_layout.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/volume/volume_chart_layout.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/indicator/indicator_cards.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/themes/extensions/app_card_theme.dart';
import '../../../core/widgets/theme_toggle_button.dart';
import 'controllers/price_chart_controller.dart';
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

      body: PageContainer(
        child: ListView(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          // OHLC Filters (esquerda)
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: const OhlcFilterBar(),
                            ),
                          ),

                          // Chart Mode Selector (CENTRO)
                          Expanded(
                            child: Center(
                              child: ChartModeSelector(
                                selected: controller.chartMode,
                                onChanged: (mode) =>
                                    controller.setChartMode(mode),
                              ),
                            ),
                          ),

                          // Range Filters (direita)
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: RangeFilterBar(
                                selected: controller.currentRange,
                                onSelected: (range) =>
                                    controller.setRange(context, range),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 🔹 GRÁFICO
                    IndexedStack(
                      index: controller.chartMode == ChartMode.price ? 0 : 1,
                      children: [
                        // GRAFICO DE PREÇO
                        PriceChartLayout(
                          chart: controller.chartResult!.chart,
                          series: controller.chartResult!.series,
                          timestamp: controller.timestamp,
                        ),

                        // GRAFICO DE VOLUME
                        VolumeChartLayout(
                          volume: controller.volume,
                          timestamp: controller.timestamp,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            //indicadores financeiros
            Consumer<FinancialIndicatorsController>(
              builder: (context, indicators, _) {
                if (indicators.isLoading) {
                  return const Padding(padding: EdgeInsets.all(16));
                }

                if (indicators.errorMessage != null) {
                  return Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      indicators.errorMessage!,
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  );
                }

                if (indicators.data == null) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: IndicatorCards(data: indicators.data!),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
