import 'package:flutter/material.dart';

/// Tokens fixos de layout.
/// Não mudam com tema claro/escuro.
/// Mantêm consistência visual em todo o app.
class AppLayout {
  // ================
  //   CONTENT WIDTH
  // ================

  /// Largura máxima do conteúdo centralizado (páginas, seções, cards etc).
  /// Usado em dashboards e layouts responsivos.
  static const double maxContentWidth = 1400;

  // ================
  //     RADIUS
  // ================
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(24));

  // ================
  //     PADDINGS
  // ================
  static const EdgeInsets paddingMd = EdgeInsets.all(16);
  static const EdgeInsets paddingSm = EdgeInsets.all(8);
  static const EdgeInsets paddingLg = EdgeInsets.all(24);

  // Espaço reservado para os eixos do gráfico
  static const double axisLeftReserved = 58;
  static const double axisRightReserved = 25;

  // ================
  //     MARGINS
  // ================
  static const EdgeInsets marginSm = EdgeInsets.all(8);
  static const EdgeInsets marginMd = EdgeInsets.all(16);
  static const EdgeInsets marginLg = EdgeInsets.all(24);

  // ================
  //     SHADOWS
  // ================
  static const List<BoxShadow> shadowSm = [
    BoxShadow(color: Color(0x22000000), blurRadius: 6, offset: Offset(0, 3)),
  ];

  static const List<BoxShadow> shadowMd = [
    BoxShadow(color: Color(0x33000000), blurRadius: 10, offset: Offset(0, 4)),
  ];

  // GRID TOKENS
  static const double indicatorGridSpacing = 12;
  static const double indicatorAspectRatio = 3.6;

  // BREAKPOINTS
  static const double desktopBreakpoint = 1300;
  static const double tabletBreakpoint = 900;

  // Borda padrão leve
  static BorderSide get defaultBorder =>
      BorderSide(color: Colors.black12, width: 1);
}
