import 'package:flutter/material.dart';

class CategoriesPlaceholder extends StatelessWidget {
  const CategoriesPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Categorias de Indicadores (em breve)',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
