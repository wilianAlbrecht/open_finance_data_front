import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_theme_package.dart';

class IndicatorCardBase extends StatelessWidget {
  final String title;
  final String value;
  final String? unit;
  final IconData? icon;

  const IndicatorCardBase({
    super.key,
    required this.title,
    required this.value,
    this.unit,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final pkg = Theme.of(context).extension<AppThemePackage>()!;
    final card = pkg.indicatorCard;
    final text = pkg.text;

    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),

      decoration: BoxDecoration(
        color: card.background,
        borderRadius: BorderRadius.circular(card.radius),
        border: Border.all(color: card.borderColor),
        boxShadow: [
          // BoxShadow(
          //   blurRadius: 8,
          //   offset: const Offset(0, 3),
          //   color: card.shadowColor,
          // ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // =======================
          //       TÍTULO
          // =======================
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                // Icon(
                //   icon,
                //   size: 16,
                //   color: card.iconColor,
                // ),
              if (icon != null) const SizedBox(width: 6),

              Text(
                title,
                style: text.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),

          const SizedBox(height: 10),

          // =======================
          //       VALOR
          // =======================
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: value,
              style: text.number,
              children: [
                if (unit != null)
                  TextSpan(
                    text: " $unit",
                    style: text.caption.copyWith(
                      fontSize: text.caption.fontSize,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
