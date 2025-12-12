import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/app_layout.dart';

class PageContainer extends StatelessWidget {
  final Widget child;
  final bool fullWidth; // 🔥 Define se a página deve ocupar toda largura

  const PageContainer({
    super.key,
    required this.child,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    if (fullWidth) {
      return Padding(
        padding: AppLayout.paddingMd,
        child: child,
      );
    }

    // Layout tradicional centralizado
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppLayout.maxContentWidth,
        ),
        child: Padding(
          padding: AppLayout.paddingMd,
          child: child,
        ),
      ),
    );
  }
}
