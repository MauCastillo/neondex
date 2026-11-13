import 'package:material_ui/material_ui.dart';

import 'cyber_colors.dart';

class CyberTextStyles {
  const CyberTextStyles._();

  static const String displayFont = 'Orbitron';
  static const String bodyFont = 'Rajdhani';
  static const String monoFont = 'ShareTechMono';

  static const TextStyle hudTitle = TextStyle(
    fontFamily: displayFont,
    fontSize: 20,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.6,
    color: CyberColors.textPrimary,
  );

  static const TextStyle hudHeadline = TextStyle(
    fontFamily: displayFont,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: CyberColors.textPrimary,
  );

  static const TextStyle hudLabel = TextStyle(
    fontFamily: displayFont,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.4,
    color: CyberColors.neonCyan,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: CyberColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.35,
    color: CyberColors.textSecondary,
  );

  static const TextStyle monoTag = TextStyle(
    fontFamily: monoFont,
    fontSize: 12,
    letterSpacing: 0.9,
    color: CyberColors.neonCyan,
  );

  static const TextStyle monoValue = TextStyle(
    fontFamily: monoFont,
    fontSize: 14,
    letterSpacing: 0.6,
    color: CyberColors.textPrimary,
  );
}
