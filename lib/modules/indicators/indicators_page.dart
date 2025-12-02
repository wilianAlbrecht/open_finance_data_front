import 'package:flutter/material.dart';

class IndicatorsPage extends StatelessWidget {
  const IndicatorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Indicadores - OpenFinanceData'),
      ),
      body: const Center(
        child: Text(
          'Aqui ficará a página de Indicadores\n(busca + gráfico + indicadores)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
