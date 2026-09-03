import 'package:flutter/material.dart';

class AppTokens {
  // Spacing Scale
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 12.0;
  static const double spaceLG = 16.0;
  static const double spaceXL = 24.0;
  static const double space2XL = 32.0;

  // Border Radiuses
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusPill = 30.0;

  // Elevation & Shadows
  static List<BoxShadow> cardShadow(BuildContext context) {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.03),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ];
  }

  static List<BoxShadow> heroShadow(Color accentColor) {
    return [
      BoxShadow(
        color: accentColor.withOpacity(0.25),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ];
  }

  // Animation Durations
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 250);
  static const Duration animSlow = Duration(milliseconds: 350);

  // Curves
  static const Curve curveFast = Curves.easeOut;
  static const Curve curveNormal = Curves.easeInOutCubic;
}
