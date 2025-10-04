import 'package:flutter/material.dart';

class ExtraColors extends ThemeExtension<ExtraColors> {
  // static const Color primary = contentColorCyan;
  // static const Color menuBackground = Color(0xFF090912);
  // static const Color itemsBackground = Color(0xFF1B2339);
  // static const Color pageBackground = Color(0xFF282E45);
  // static const Color mainTextColor1 = Colors.white;
  // static const Color mainTextColor2 = Colors.white70;
  // static const Color mainTextColor3 = Colors.white38;
  // static const Color mainGridLineColor = Colors.white10;
  // static const Color borderColor = Colors.white54;
  // static const Color gridLinesColor = Color(0x11FFFFFF);

  // static const Color contentColorBlack = Colors.black;
  // static const Color contentColorWhite = Colors.white;
  // static const Color contentColorBlue = Color(0xFF2196F3);
  // static const Color contentColorYellow = Color(0xFFFFC300);
  // static const Color contentColorOrange = Color(0xFFFF683B);
  // static const Color contentColorGreen = Color(0xFF3BFF49);
  // static const Color contentColorPurple = Color(0xFF6E1BFF);
  // static const Color contentColorPink = Color(0xFFFF3AF2);
  // static const Color contentColorRed = Color.fromARGB(255, 232, 0, 0);
  // static const Color contentColorCyan = Color(0xFF50E4FF);

  Color bgGradientStart;
  Color bgGradientEnd;
  Color buttonGradientGreenStart;
  Color buttonGradientGreenEnd;
  Color buttonGradientPurpleStart;
  Color buttonGradientPurpleEnd;
  //--------------
  Color mainGridLineColor;
  Color gridLinesColor;
  Color contentColorGreen;
  Color contentColorRed;
  Color gradientGainColor;
  Color gradientLossColor;

  ExtraColors({
    required this.bgGradientStart,
    required this.bgGradientEnd,
    required this.buttonGradientGreenStart,
    required this.buttonGradientGreenEnd,
    required this.buttonGradientPurpleStart,
    required this.buttonGradientPurpleEnd,
    //--------------
    required this.mainGridLineColor,
    required this.gridLinesColor,
    required this.contentColorGreen,
    required this.contentColorRed,
    required this.gradientGainColor,
    required this.gradientLossColor,
  });

  @override
  ExtraColors copyWith({
    Color? bgGradientStart,
    Color? bgGradientEnd,
    Color? buttonGradientGreenStart,
    Color? buttonGradientGreenEnd,
    Color? buttonGradientPurpleStart,
    Color? buttonGradientPurpleEnd,
    //--------------
    Color? mainGridLineColor,
    Color? gridLinesColor,
    Color? contentColorGreen,
    Color? contentColorRed,
    Color? gradientGainColor,
    Color? gradientLossColor,
  }) {
    return ExtraColors(
      bgGradientStart: bgGradientStart ?? this.bgGradientStart,
      bgGradientEnd: bgGradientEnd ?? this.bgGradientEnd,
      buttonGradientGreenStart: buttonGradientGreenStart ?? this.buttonGradientGreenStart,
      buttonGradientGreenEnd: buttonGradientGreenEnd ?? this.buttonGradientGreenEnd,
      buttonGradientPurpleStart: buttonGradientPurpleStart ?? this.buttonGradientPurpleStart,
      buttonGradientPurpleEnd: buttonGradientPurpleEnd ?? this.buttonGradientPurpleEnd,
      //--------------
      mainGridLineColor: mainGridLineColor ?? this.mainGridLineColor,
      gridLinesColor: gridLinesColor ?? this.gridLinesColor,
      contentColorGreen: contentColorGreen ?? this.contentColorGreen,
      contentColorRed: contentColorRed ?? this.contentColorRed,
      gradientGainColor: gradientGainColor ?? this.gradientGainColor,
      gradientLossColor: gradientLossColor ?? this.gradientLossColor,
    );
  }

  @override
  ExtraColors lerp(ThemeExtension<ExtraColors>? other, double t) {
    if (other is! ExtraColors) return this;
    return ExtraColors(
      bgGradientStart: Color.lerp(bgGradientStart, other.bgGradientStart, t)!,
      bgGradientEnd: Color.lerp(bgGradientEnd, other.bgGradientEnd, t)!,
      buttonGradientGreenStart:
          Color.lerp(buttonGradientGreenStart, other.buttonGradientGreenStart, t)!,
      buttonGradientGreenEnd: Color.lerp(buttonGradientGreenEnd, other.buttonGradientGreenEnd, t)!,
      buttonGradientPurpleStart:
          Color.lerp(buttonGradientPurpleStart, other.buttonGradientPurpleStart, t)!,
      buttonGradientPurpleEnd:
          Color.lerp(buttonGradientPurpleEnd, other.buttonGradientPurpleEnd, t)!,
      //--------------
      mainGridLineColor: Color.lerp(mainGridLineColor, other.mainGridLineColor, t)!,
      gridLinesColor: Color.lerp(gridLinesColor, other.gridLinesColor, t)!,
      contentColorGreen: Color.lerp(contentColorGreen, other.contentColorGreen, t)!,
      contentColorRed: Color.lerp(contentColorRed, other.contentColorRed, t)!,
      gradientGainColor: Color.lerp(gradientGainColor, other.gradientGainColor, t)!,
      gradientLossColor: Color.lerp(gradientLossColor, other.gradientLossColor, t)!,
    );
  }
}

final kDarkExtraColors = ExtraColors(
  bgGradientStart: const Color(0xFF1C0F2B),
  bgGradientEnd: const Color(0xFF0F1724),
  buttonGradientGreenStart: const Color(0xFF9B7BEA),
  buttonGradientGreenEnd: const Color(0xFF6EE7B7),
  buttonGradientPurpleStart: Colors.deepPurple,
  buttonGradientPurpleEnd: const Color(0xFF9B7BEA),
  //--------------
  mainGridLineColor: const Color(0x1AFFFFFF),
  gridLinesColor: const Color(0x11FFFFFF),
  contentColorGreen: const Color.fromARGB(255, 47, 194, 162),
  contentColorRed: const Color.fromARGB(255, 226, 54, 91),
  gradientGainColor: const Color.fromARGB(255, 114, 235, 101),
  gradientLossColor: const Color.fromARGB(255, 255, 70, 70),
);

final kLightExtraColors = kDarkExtraColors;
