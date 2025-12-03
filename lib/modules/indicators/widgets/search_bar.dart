import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../indicators_controller.dart'; // ajuste o path se necessário


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

    // Aqui você vai depois chamar:
    // context.read(IndicatorsController).search(value);
    // ou Navigator.pushNamed com o ativo
    context.read<IndicatorsController>().search(context, value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Campo de texto expandido
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Buscar ativo (ex: PETR4, AAPL, TSLA)',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Botão de buscar
          ElevatedButton(
            onPressed: onSearch,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Buscar"),
          ),
        ],
      ),
    );
  }
}
