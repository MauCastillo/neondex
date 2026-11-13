import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/cyber_colors.dart';
import '../../../../core/theme/cyber_text_styles.dart';
import '../../../../core/widgets/cyber_hud_card.dart';
import '../../domain/entities/geo_location.dart';
import '../../domain/entities/weather_forecast.dart';

class WeatherTelemetryCard extends StatelessWidget {
  const WeatherTelemetryCard({
    super.key,
    required this.location,
    required this.forecast,
    required this.conditionTitle,
    required this.biomeTag,
    required this.onRefresh,
  });

  final GeoLocation location;
  final WeatherForecast forecast;
  final String conditionTitle;
  final String biomeTag;
  final VoidCallback onRefresh;

  IconData _wmoIcon(int code, bool isDay) {
    if (code >= 95) return Icons.thunderstorm_rounded;
    if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
      return Icons.umbrella_rounded;
    }
    if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
      return Icons.ac_unit_rounded;
    }
    if (code == 45 || code == 48) return Icons.foggy;
    if (code == 2 || code == 3) return Icons.cloud_rounded;
    return isDay ? Icons.wb_sunny_rounded : Icons.nightlight_round;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = forecast.weatherCode >= 95
        ? CyberColors.cyberYellow
        : forecast.isDay
            ? CyberColors.neonCyan
            : CyberColors.synthPurple;

    return CyberHudCard(
      accentColor: primaryColor,
      glowIntensity: 0.22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '// $biomeTag',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CyberTextStyles.monoTag.copyWith(
                        fontSize: 10,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      forecast.timezone.replaceAll('_', ' '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CyberTextStyles.hudHeadline,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onRefresh,
                tooltip: 'Reescanear sector',
                icon: Icon(Icons.my_location_rounded, color: primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withValues(alpha: 0.14),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.7),
                  ),
                ),
                child: Icon(
                  _wmoIcon(forecast.weatherCode, forecast.isDay),
                  size: 38,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${forecast.temperatureC.toStringAsFixed(1)}°C',
                        style: CyberTextStyles.hudTitle.copyWith(fontSize: 30),
                      ),
                    ),
                    Text(
                      conditionTitle.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CyberTextStyles.hudLabel.copyWith(
                        color: CyberColors.cyberYellow,
                      ),
                    ),
                    Text(
                      'Sensación ${forecast.apparentTemperatureC.toStringAsFixed(1)}°C · ${forecast.isDay ? "Ciclo Diurno" : "Ciclo Nocturno"}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CyberTextStyles.bodyMedium.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _TelemetryChip(
                icon: Icons.water_drop_outlined,
                label: 'HUMEDAD ${forecast.relativeHumidity}%',
              ),
              _TelemetryChip(
                icon: Icons.air,
                label: 'VIENTO ${forecast.windSpeedKmh.toStringAsFixed(1)} km/h',
              ),
              _TelemetryChip(
                icon: Icons.cloud_queue,
                label: 'NUBES ${forecast.cloudCoverPercent}%',
              ),
              _TelemetryChip(
                icon: Icons.grain,
                label: 'LLUVIA ${forecast.precipitationMm.toStringAsFixed(1)} mm',
              ),
              _TelemetryChip(
                icon: Icons.gps_fixed,
                label:
                    'GPS ${location.latitude.toStringAsFixed(3)}, ${location.longitude.toStringAsFixed(3)}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TelemetryChip extends StatelessWidget {
  const _TelemetryChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: CyberColors.deepSpace,
        border: Border.all(color: CyberColors.gridLine),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: CyberColors.neonCyan),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CyberTextStyles.monoTag.copyWith(
                fontSize: 11,
                color: CyberColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
