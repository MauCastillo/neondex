import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/cyber_colors.dart';
import '../../../../core/widgets/cyber_error_panel.dart';
import '../../../../core/widgets/cyber_loading_indicator.dart';
import '../../../../core/widgets/cyber_section_header.dart';
import '../../../notifications_settings/domain/entities/android_permission_item.dart';
import '../../../notifications_settings/presentation/providers/permissions_diagnostics_provider.dart';
import '../providers/weather_radar_provider.dart';
import '../widgets/hourly_forecast_strip.dart';
import '../widgets/weather_encounter_panel.dart';
import '../widgets/weather_telemetry_card.dart';

class WeatherRadarPage extends ConsumerWidget {
  const WeatherRadarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherRadarProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: CyberSectionHeader(
              title: 'RADAR CLIMÁTICO GPS',
              codeTag: 'OPEN-METEO LIVE + ENCUENTROS',
              accentColor: CyberColors.neonCyan,
              trailing: IconButton(
                onPressed: () =>
                    ref.read(weatherRadarProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh, color: CyberColors.neonCyan),
                tooltip: 'Actualizar telemetría',
              ),
            ),
          ),
          Expanded(
            child: weatherAsync.when(
              loading: () => const CyberLoadingIndicator(
                label: 'OBTENIENDO GPS Y TELEMETRÍA OPEN-METEO...',
              ),
              error: (err, _) => SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CyberErrorPanel(
                      title: 'RADAR GPS INACCESIBLE',
                      message: err.toString(),
                      onRetry: () =>
                          ref.read(weatherRadarProvider.notifier).refresh(),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () async {
                        await ref
                            .read(permissionsDiagnosticsProvider.notifier)
                            .request(AndroidPermissionKind.locationWhenInUse);
                        ref.read(weatherRadarProvider.notifier).refresh();
                      },
                      icon: const Icon(Icons.location_on),
                      label: const Text('SOLICITAR PERMISO DE UBICACIÓN'),
                    ),
                  ],
                ),
              ),
              data: (bundle) => RefreshIndicator(
                color: CyberColors.neonCyan,
                backgroundColor: CyberColors.panelDark,
                onRefresh: () =>
                    ref.read(weatherRadarProvider.notifier).refresh(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      WeatherTelemetryCard(
                        location: bundle.location,
                        forecast: bundle.forecast,
                        conditionTitle: bundle.encounterReport.conditionTitle,
                        biomeTag: bundle.encounterReport.biomeTag,
                        onRefresh: () =>
                            ref.read(weatherRadarProvider.notifier).refresh(),
                      ),
                      const SizedBox(height: 16),
                      HourlyForecastStrip(points: bundle.forecast.hourlyPoints),
                      const SizedBox(height: 16),
                      WeatherEncounterPanel(
                        recommendations:
                            bundle.encounterReport.recommendations,
                        sampleEncounters: bundle.sampleEncounters,
                        onTypeTap: (typeName) => Navigator.of(context)
                            .pushNamed(AppRoutes.typeList(typeName)),
                        onPokemonTap: (pokemon) =>
                            Navigator.of(context).pushNamed(
                          AppRoutes.pokemonDetail(pokemon.id),
                          arguments: pokemon,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
