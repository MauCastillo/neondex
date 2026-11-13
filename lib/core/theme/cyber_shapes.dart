import 'package:material_ui/material_ui.dart';

class CyberShapes {
  const CyberShapes._();

  static BeveledRectangleBorder chamfered({
    double cut = 12,
    Color borderColor = const Color(0xFF00F0FF),
    double borderWidth = 1.2,
  }) {
    return BeveledRectangleBorder(
      borderRadius: BorderRadius.circular(cut),
      side: BorderSide(color: borderColor, width: borderWidth),
    );
  }

  static ShapeDecoration chamferedDecoration({
    required Color backgroundColor,
    required Color borderColor,
    double cut = 12,
    double borderWidth = 1.2,
    List<BoxShadow>? shadows,
    Gradient? gradient,
  }) {
    return ShapeDecoration(
      color: gradient == null ? backgroundColor : null,
      gradient: gradient,
      shadows: shadows,
      shape: chamfered(
        cut: cut,
        borderColor: borderColor,
        borderWidth: borderWidth,
      ),
    );
  }
}
