import 'package:flutter/material.dart';

/// Tokens de layout fixos da identidade visual.
/// Diferente de temas, esses valores NÃO mudam no dark/light.
/// São usados para deixar o layout consistente e modular.
class AppLayout {
  // ======== RADIUS ========

  /// Raio padrão para todos os cards, containers, chips, botões etc.
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(16));

  /// Raio pequeno (inputs, elementos compactos)
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(8));

  /// Raio grande (cards destacados, modais)
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(24));

  // ======== PADDINGS ========

  /// Padding padrão interno de containers/cards
  static const EdgeInsets paddingMd = EdgeInsets.all(16);

  /// Padding pequeno (chips, tags, botões compactos)
  static const EdgeInsets paddingSm = EdgeInsets.all(8);

  /// Padding grande (seções)
  static const EdgeInsets paddingLg = EdgeInsets.all(24);

  // ======== MARGINS ========

  static const EdgeInsets marginSm = EdgeInsets.all(8);
  static const EdgeInsets marginMd = EdgeInsets.all(16);
  static const EdgeInsets marginLg = EdgeInsets.all(24);

  // ======== SHAPES UTILITÁRIAS ========

  /// Borda padrão leve
  static BorderSide get defaultBorder => BorderSide(
        color: Colors.black12,
        width: 1,
      );

  /// Sombra leve universal (independente do tema)
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x22000000),
      blurRadius: 6,
      offset: Offset(0, 3),
    ),
  ];

  /// Sombra média
  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];
}
