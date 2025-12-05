import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),

      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.06)
            : Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.10)
              : Colors.black.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.25)
                : Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,   // 🔥 AGORA CENTRALIZA
        children: [

          // ====== TÍTULO ======
          Row(
            mainAxisSize: MainAxisSize.min,              // 🔥 evita expandir full width
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: 16,
                  color: theme.colorScheme.primary.withOpacity(.85),
                ),
              if (icon != null) const SizedBox(width: 6),

              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withOpacity(.68),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ====== VALOR ======
          Text.rich(
            TextSpan(
              text: value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              children: [
                if (unit != null)
                  TextSpan(
                    text: " $unit",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.onSurface.withOpacity(.60),
                    ),
                  ),
              ],
            ),
            textAlign: TextAlign.center,             
          ),
        ],
      ),
    );
  }
}
