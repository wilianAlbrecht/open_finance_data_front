import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_theme_package.dart';
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
import '../../../core/widgets/theme_toggle_button.dart';
import 'controllers/price_chart_controller.dart';
import 'widgets/search_bar.dart';

class IndicatorsPage extends StatefulWidget {
  const IndicatorsPage({super.key});

  @override
  State<IndicatorsPage> createState() => _IndicatorsPageState();
}

class _IndicatorsPageState extends State<IndicatorsPage> {
  /// 🔒 Controla se o scroll da página está travado
  bool _lockScroll = false;

  @override
  Widget build(BuildContext context) {
    final pkg = Theme.of(context).extension<AppThemePackage>()!;
    final text = pkg.text;
    final card = pkg.card;
    final header = pkg.header;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: header.background,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 180,
        title: Center(
          child: Image.asset(
            'assets/images/logo_open_finance_data.png',
            height: 150,
          ),
        ),
        actions: const [ThemeToggleButton()],
      ),
      body: PageContainer(
        fullWidth: true,
        child: Consumer2<IndicatorsController, FinancialIndicatorsController>(
          builder: (context, chartController, indicatorsController, _) {
            final bool isWide =
                MediaQuery.of(context).size.width > 1100;

            return ListView(
              padding: EdgeInsets.zero,
              physics: _lockScroll
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              children: [
                const SearchBarWidget(),

                // LOADING
                if (chartController.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Center(child: CircularProgressIndicator()),
                  ),

                // NENHUM RESULTADO
                if (!chartController.isLoading &&
                    chartController.close.isEmpty)
                  Container(
                    height: 200,
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    padding: AppLayout.paddingMd,
                    decoration: BoxDecoration(
                      color: card.background,
                      borderRadius:
                          BorderRadius.circular(card.radius),
                      border:
                          Border.all(color: card.borderColor),
                    ),
                    child: Center(
                      child: Text(
                        "Busque um ativo para visualizar o gráfico",
                        style: text.body.copyWith(
                          fontSize: 16,
                          color: text.body.color!
                              .withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                // LAYOUT PRINCIPAL
                if (chartController.close.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                    child: isWide
                        ? _buildWideLayout(
                            context,
                            chartController,
                            indicatorsController,
                          )
                        : _buildNarrowLayout(
                            context,
                            chartController,
                            indicatorsController,
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
  // DESKTOP / TELAS LARGAS
  // =============================================================
  Widget _buildWideLayout(
    BuildContext context,
    IndicatorsController chart,
    FinancialIndicatorsController indicators,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double panelWidth = 380;
        const double minChartWidth = 800;

        final double totalWidth = constraints.maxWidth;
        double chartWidth = totalWidth - panelWidth - 24;
        if (chartWidth < minChartWidth) {
          chartWidth = minChartWidth;
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================
            // GRÁFICO
            // ============================
            SizedBox(
              width: chartWidth,
              child: Column(
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.90,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: OhlcFilterBar(),
                          ),
                          Expanded(
                            child: Center(
                              child: ChartModeSelector(
                                selected: chart.chartMode,
                                onChanged:
                                    chart.setChartMode,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment:
                                  Alignment.centerRight,
                              child: RangeFilterBar(
                                selected:
                                    chart.currentRange,
                                onSelected: (range) =>
                                    chart.setRange(
                                        context, range),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                    onHoverScrollLock: (locked) {
                      setState(() {
                        _lockScroll = locked;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppSpacing.lg),

            // ============================
            // INDICADORES
            // ============================
            SizedBox(
              width: panelWidth,
              child:
                  _buildIndicatorsPanel(context, indicators),
            ),
          ],
        );
      },
    );
  }

  // =============================================================
  // MOBILE / TELAS ESTREITAS
  // =============================================================
  Widget _buildNarrowLayout(
    BuildContext context,
    IndicatorsController chart,
    FinancialIndicatorsController indicators,
  ) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: OhlcFilterBar()),
            Expanded(
              child: Center(
                child: ChartModeSelector(
                  selected: chart.chartMode,
                  onChanged: chart.setChartMode,
                ),
              ),
            ),
            Expanded(
              child: RangeFilterBar(
                selected: chart.currentRange,
                onSelected: (range) =>
                    chart.setRange(context, range),
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
          onHoverScrollLock: (locked) {
            setState(() {
              _lockScroll = locked;
            });
          },
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
    final pkg = Theme.of(context).extension<AppThemePackage>()!;
    final text = pkg.text;

    if (indicators.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: CircularProgressIndicator(),
      );
    }

    if (indicators.errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Text(
          indicators.errorMessage!,
          style: text.body.copyWith(color: Colors.red),
        ),
      );
    }

    if (indicators.data == null) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 4, right: 4, top: 12),
        child: IndicatorCards(
          data: indicators.data!,
        ),
      ),
    );
  }
}
