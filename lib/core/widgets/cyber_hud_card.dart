import 'package:material_ui/material_ui.dart';

import '../theme/cyber_colors.dart';
import '../theme/cyber_shapes.dart';

class CyberHudCard extends StatelessWidget {
  const CyberHudCard({
    super.key,
    required this.child,
    this.accentColor = CyberColors.neonCyan,
    this.backgroundColor = CyberColors.panelDark,
    this.padding = const EdgeInsets.all(14),
    this.cut = 12,
    this.glowIntensity = 0.16,
    this.onTap,
    this.showCornerBrackets = true,
  });

  final Widget child;
  final Color accentColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final double cut;
  final double glowIntensity;
  final VoidCallback? onTap;
  final bool showCornerBrackets;

  @override
  Widget build(BuildContext context) {
    final content = Stack(
      children: [
        Padding(padding: padding, child: child),
        if (showCornerBrackets)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _HudCornerBracketPainter(
                  color: accentColor.withValues(alpha: 0.75),
                ),
              ),
            ),
          ),
      ],
    );

    return Container(
      decoration: CyberShapes.chamferedDecoration(
        backgroundColor: backgroundColor,
        borderColor: accentColor.withValues(alpha: 0.55),
        cut: cut,
        borderWidth: 1.1,
        shadows: glowIntensity > 0
            ? CyberColors.neonGlow(accentColor, intensity: glowIntensity, blur: 12)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        shape: CyberShapes.chamfered(
          cut: cut,
          borderColor: Colors.transparent,
          borderWidth: 0,
        ),
        clipBehavior: Clip.antiAlias,
        child: onTap != null
            ? InkWell(
                onTap: onTap,
                splashColor: accentColor.withValues(alpha: 0.16),
                highlightColor: accentColor.withValues(alpha: 0.08),
                child: content,
              )
            : content,
      ),
    );
  }
}

class _HudCornerBracketPainter extends CustomPainter {
  const _HudCornerBracketPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    const len = 10.0;
    // Top-right horizontal accent tick
    canvas.drawLine(
      Offset(size.width - 22, 3),
      Offset(size.width - 10, 3),
      paint,
    );
    // Bottom-left corner L-tick
    canvas.drawLine(
      Offset(3, size.height - len - 4),
      Offset(3, size.height - 4),
      paint,
    );
    canvas.drawLine(
      Offset(3, size.height - 4),
      Offset(len + 3, size.height - 4),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _HudCornerBracketPainter oldDelegate) =>
      oldDelegate.color != color;
}
