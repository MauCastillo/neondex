import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/cyber_colors.dart';
import '../../../../core/theme/cyber_text_styles.dart';
import '../../../../core/utils/pokemon_formatters.dart';
import '../../../../core/widgets/cyber_hud_card.dart';
import '../../domain/entities/pokemon_detail.dart';

class StatRadarBars extends StatelessWidget {
  const StatRadarBars({
    super.key,
    required this.stats,
    required this.baseStatTotal,
    this.accentColor = CyberColors.neonCyan,
  });

  final List<PokemonStat> stats;
  final int baseStatTotal;
  final Color accentColor;

  Color _statColor(int value) {
    if (value >= 100) return CyberColors.acidGreen;
    if (value >= 75) return CyberColors.neonCyan;
    if (value >= 50) return CyberColors.cyberYellow;
    return CyberColors.neonMagenta;
  }

  @override
  Widget build(BuildContext context) {
    return CyberHudCard(
      accentColor: accentColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                Text(
                  'TELEMETRÍA DE COMBATE',
                  style: CyberTextStyles.hudLabel.copyWith(color: accentColor),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.14),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.6),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'TOTAL: $baseStatTotal',
                    style: CyberTextStyles.monoTag.copyWith(
                      color: CyberColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...stats.map((stat) {
            final label = PokemonFormatters.formatStatShortLabel(stat.name);
            final barColor = _statColor(stat.baseStat);
            final normalized = (stat.baseStat / 180).clamp(0.04, 1.0);

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 46,
                    child: Text(
                      label,
                      style: CyberTextStyles.monoTag.copyWith(
                        color: CyberColors.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 36,
                    child: Text(
                      stat.baseStat.toString().padLeft(3, ' '),
                      textAlign: TextAlign.right,
                      style: CyberTextStyles.monoValue.copyWith(
                        color: barColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: CyberColors.voidBlack,
                            border: Border.all(
                              color: CyberColors.gridLine,
                              width: 0.9,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          alignment: Alignment.centerLeft,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 450),
                            curve: Curves.easeOutCubic,
                            width: constraints.maxWidth * normalized,
                            height: 10,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  barColor.withValues(alpha: 0.65),
                                  barColor,
                                ],
                              ),
                              boxShadow: CyberColors.neonGlow(
                                barColor,
                                intensity: 0.4,
                                blur: 6,
                              ),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
