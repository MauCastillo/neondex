import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/cyber_colors.dart';
import '../../../../core/theme/cyber_text_styles.dart';
import '../../../../core/widgets/cyber_hud_card.dart';
import '../../domain/entities/weather_forecast.dart';

class HourlyForecastStrip extends StatelessWidget {
  const HourlyForecastStrip({
    super.key,
    required this.points,
  });

  final List<HourlyForecastPoint> points;

  IconData _smallIcon(int code) {
    if (code >= 95) return Icons.bolt;
    if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
      return Icons.water_drop;
    }
    if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
      return Icons.ac_unit;
    }
    if (code >= 2 && code <= 48) return Icons.cloud;
    return Icons.wb_sunny;
  }

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();

    return CyberHudCard(
      accentColor: CyberColors.neonCyan,
      glowIntensity: 0.1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'PRONÓSTICO POR HORA // OPEN-METEO',
            style: CyberTextStyles.hudLabel,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 114,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: points.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final item = points[index];
                return Container(
                  width: 72,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: CyberColors.deepSpace,
                    border: Border.all(
                      color: CyberColors.neonCyan.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.hourLabel,
                        style: CyberTextStyles.monoTag.copyWith(
                          fontSize: 11,
                          color: CyberColors.textSecondary,
                        ),
                      ),
                      Icon(
                        _smallIcon(item.weatherCode),
                        size: 20,
                        color: item.precipitationProbability >= 60
                            ? CyberColors.neonCyan
                            : CyberColors.cyberYellow,
                      ),
                      Text(
                        '${item.temperatureC.toStringAsFixed(0)}°C',
                        style: CyberTextStyles.hudHeadline.copyWith(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '${item.precipitationProbability}%',
                        style: CyberTextStyles.monoTag.copyWith(
                          fontSize: 10,
                          color: CyberColors.neonCyan,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
