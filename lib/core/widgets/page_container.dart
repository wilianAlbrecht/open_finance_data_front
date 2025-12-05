import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_page_layout_theme.dart';

class PageContainer extends StatelessWidget {
  final Widget child;

  const PageContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final layout = Theme.of(context).extension<AppPageLayoutTheme>()!;

    Widget content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: layout.maxContentWidth),
      child: Padding(
        padding: layout.pagePadding,
        child: child,
      ),
    );

    return layout.centerContent ? Center(child: content) : content;
  }
}
