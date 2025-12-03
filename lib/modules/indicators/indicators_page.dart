import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/price_line_chart.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/price_filter_bar.dart';

// Widgets existentes
import 'widgets/search_bar.dart';
import 'widgets/categories_placeholder.dart';

// Controller
import 'indicators_controller.dart';

class IndicatorsPage extends StatelessWidget {
  const IndicatorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OpenFinanceData'), elevation: 0),
      body: ListView(
        children: [
          const SearchBarWidget(),

          Consumer<IndicatorsController>(
            builder: (context, controller, _) {
              if (controller.isLoading) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.close.isEmpty) {
                return Container(
                  height: 200,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      "Busque um ativo para visualizar o gráfico",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  // 🔹 FILTROS
                  const PriceFilterBar(),

                  // 🔹 GRÁFICO
                  PriceLineChart(
                    open: controller.open,
                    high: controller.high,
                    low: controller.low,
                    close: controller.close,
                    timestamp: controller.timestamp,

                    showOpen: controller.showOpen,
                    showHigh: controller.showHigh,
                    showLow: controller.showLow,
                    showClose: controller.showClose,
                  ),
                ],
              );
            },
          ),

          const CategoriesPlaceholder(),
        ],
      ),
    );
  }
}
