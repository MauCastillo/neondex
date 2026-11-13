import 'package:material_ui/material_ui.dart';

import '../../../../core/constants/pokemon_type_constants.dart';
import '../../../../core/theme/cyber_colors.dart';
import '../../../../core/theme/cyber_shapes.dart';
import '../../../../core/theme/cyber_text_styles.dart';

class TypeBadgeChip extends StatelessWidget {
  const TypeBadgeChip({
    super.key,
    required this.typeName,
    this.multiplierLabel,
    this.onTap,
    this.compact = false,
  });

  final String typeName;
  final String? multiplierLabel;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final meta = PokemonTypeConstants.of(typeName);
    final borderColor = meta.color.withValues(alpha: 0.85);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: CyberShapes.chamfered(
          cut: compact ? 6 : 8,
          borderColor: borderColor,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 9 : 12,
            vertical: compact ? 5 : 7,
          ),
          decoration: CyberShapes.chamferedDecoration(
            backgroundColor: meta.color.withValues(alpha: 0.14),
            borderColor: borderColor,
            cut: compact ? 6 : 8,
            borderWidth: 1.1,
            shadows: CyberColors.neonGlow(meta.color, intensity: 0.22, blur: 8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(meta.icon, size: compact ? 13 : 15, color: meta.color),
              const SizedBox(width: 6),
              Text(
                meta.name.toUpperCase(),
                style: CyberTextStyles.hudLabel.copyWith(
                  fontSize: compact ? 10 : 11,
                  color: CyberColors.textPrimary,
                  letterSpacing: 1.0,
                ),
              ),
              if (multiplierLabel != null) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: meta.color.withValues(alpha: 0.28),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    multiplierLabel!,
                    style: CyberTextStyles.monoTag.copyWith(
                      fontSize: 10,
                      color: CyberColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
