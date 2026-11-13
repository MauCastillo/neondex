import 'package:material_ui/material_ui.dart';

class CyberColors {
  const CyberColors._();

  static const Color voidBlack = Color(0xFF06070D);
  static const Color deepSpace = Color(0xFF0B0E1B);
  static const Color panelDark = Color(0xFF10152B);
  static const Color panelElevated = Color(0xFF171E3B);
  static const Color gridLine = Color(0xFF1F2B4D);

  static const Color neonCyan = Color(0xFF00F0FF);
  static const Color neonMagenta = Color(0xFFFF007F);
  static const Color cyberYellow = Color(0xFFFCE300);
  static const Color acidGreen = Color(0xFF39FF14);
  static const Color synthPurple = Color(0xFFB026FF);
  static const Color alertRed = Color(0xFFFF3355);
  static const Color warningAmber = Color(0xFFFF9F1C);

  static const Color textPrimary = Color(0xFFF0F6FF);
  static const Color textSecondary = Color(0xFF9EB1D4);
  static const Color textMuted = Color(0xFF5D6E94);

  static List<BoxShadow> neonGlow(
    Color color, {
    double intensity = 0.35,
    double blur = 14,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: intensity),
        blurRadius: blur,
        spreadRadius: 0.5,
      ),
    ];
  }
}
