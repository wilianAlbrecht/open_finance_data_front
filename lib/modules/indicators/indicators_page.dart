import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_page_layout_theme.dart';
import 'package:open_finance_data_front/core/widgets/page_container.dart';
import 'package:open_finance_data_front/modules/indicators/controllers/financial_indicators_controller.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/canvas_chart_widget.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/chart_mode_selector.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/filters/ohlc_filter_bar.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/filters/range_filter_bar.dart';
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

      // IMPORTANTÍSSIMO →
      // Agora o Theme interno foi removido completamente.
      // PageContainer usa o tema global (fullWidth = true).
      body: PageContainer(
        child: Consumer2<IndicatorsController, FinancialIndicatorsController>(
          builder: (context, chartController, indicatorsController, _) {
            final isWide = MediaQuery.of(context).size.width > 1100;

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                const SearchBarWidget(),

                // LOADING
                if (chartController.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Center(child: CircularProgressIndicator()),
                  ),

                // NENHUM RESULTADO
                if (!chartController.isLoading && chartController.close.isEmpty)
                  Container(
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
                  ),

                // LAYOUT PRINCIPAL
                if (chartController.close.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: isWide
                        ? _buildWideLayout(
                            context,
                            chartController,
                            indicatorsController,
                            cardTheme,
                          )
                        : _buildNarrowLayout(
                            context,
                            chartController,
                            indicatorsController,
                            cardTheme,
                          ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // =============================================================
  // DESKTOP / TELA LARGA (wide layout)
  // =============================================================
  Widget _buildWideLayout(
    BuildContext context,
    IndicatorsController chart,
    FinancialIndicatorsController indicators,
    AppCardTheme cardTheme,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalWidth = constraints.maxWidth;

        const double panelWidth = 380;
        const double minChartWidth = 800;

        double chartWidth = totalWidth - panelWidth - 24;

        if (chartWidth < minChartWidth) {
          chartWidth = minChartWidth;
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================
            // GRÁFICO (ESQUERDA)
            // ============================
            SizedBox(
              width: chartWidth,
              child: Column(
                children: [
                  // FILTROS
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: const OhlcFilterBar(),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: ChartModeSelector(
                              selected: chart.chartMode,
                              onChanged: (mode) => chart.setChartMode(mode),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: RangeFilterBar(
                              selected: chart.currentRange,
                              onSelected: (range) =>
                                  chart.setRange(context, range),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // GRÁFICO
                  CanvasChartWidget(
                    chartMode: chart.chartMode,
                    open: chart.open,
                    high: chart.high,
                    low: chart.low,
                    close: chart.close,
                    volume: chart.volume,
                    timestamp: chart.timestamp,
                    showOpen: chart.showOpen,
                    showHigh: chart.showHigh,
                    showLow: chart.showLow,
                    showClose: chart.showClose,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 24),

            // ============================
            // INDICADORES (DIREITA)
            // ============================
            SizedBox(
              width: panelWidth,
              child: _buildIndicatorsPanel(context, indicators),
            ),
          ],
        );
      },
    );
  }

  // =============================================================
  // MOBILE / TELA ESTREITA
  // =============================================================
  Widget _buildNarrowLayout(
    BuildContext context,
    IndicatorsController chart,
    FinancialIndicatorsController indicators,
    AppCardTheme cardTheme,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: const OhlcFilterBar()),
            Expanded(
              child: Center(
                child: ChartModeSelector(
                  selected: chart.chartMode,
                  onChanged: (mode) => chart.setChartMode(mode),
                ),
              ),
            ),
            Expanded(
              child: RangeFilterBar(
                selected: chart.currentRange,
                onSelected: (range) => chart.setRange(context, range),
              ),
            ),
          ],
        ),

        CanvasChartWidget(
          chartMode: chart.chartMode,
          open: chart.open,
          high: chart.high,
          low: chart.low,
          close: chart.close,
          volume: chart.volume,
          timestamp: chart.timestamp,
          showOpen: chart.showOpen,
          showHigh: chart.showHigh,
          showLow: chart.showLow,
          showClose: chart.showClose,
        ),

        const SizedBox(height: 30),

        _buildIndicatorsPanel(context, indicators),
      ],
    );
  }

  // =============================================================
  // PAINEL DE INDICADORES
  // =============================================================
  Widget _buildIndicatorsPanel(
    BuildContext context,
    FinancialIndicatorsController indicators,
  ) {
    if (indicators.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      );
    }

    if (indicators.errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          indicators.errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (indicators.data == null) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 4, top: 12),
        child: IndicatorCards(data: indicators.data!),
      ),
    );
  }
}
