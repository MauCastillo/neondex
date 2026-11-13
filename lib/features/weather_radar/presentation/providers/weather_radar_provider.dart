import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/service_locator.dart';
import '../../../pokedex/domain/entities/pokemon_summary.dart';
import '../../../pokedex/presentation/providers/pokedex_usecase_providers.dart';
import '../../domain/entities/geo_location.dart';
import '../../domain/entities/weather_encounter_recommendation.dart';
import '../../domain/entities/weather_forecast.dart';
import '../../domain/usecases/evaluate_weather_encounters.dart';
import '../../domain/usecases/get_current_location.dart';
import '../../domain/usecases/get_weather_forecast.dart';

final getCurrentLocationUseCaseProvider = Provider<GetCurrentLocation>(
  (ref) => sl<GetCurrentLocation>(),
);

final getWeatherForecastUseCaseProvider = Provider<GetWeatherForecast>(
  (ref) => sl<GetWeatherForecast>(),
);

final evaluateWeatherEncountersUseCaseProvider =
    Provider<EvaluateWeatherEncounters>(
  (ref) => sl<EvaluateWeatherEncounters>(),
);

class WeatherRadarBundle extends Equatable {
  const WeatherRadarBundle({
    required this.location,
    required this.forecast,
    required this.encounterReport,
    required this.sampleEncounters,
  });

  final GeoLocation location;
  final WeatherForecast forecast;
  final WeatherEncounterReport encounterReport;
  final List<PokemonSummary> sampleEncounters;

  @override
  List<Object?> get props => [
        location,
        forecast,
        encounterReport,
        sampleEncounters,
      ];
}

final weatherRadarProvider =
    AsyncNotifierProvider<WeatherRadarNotifier, WeatherRadarBundle>(
  WeatherRadarNotifier.new,
);

class WeatherRadarNotifier extends AsyncNotifier<WeatherRadarBundle> {
  @override
  Future<WeatherRadarBundle> build() async {
    final getLocation = ref.read(getCurrentLocationUseCaseProvider);
    final getForecast = ref.read(getWeatherForecastUseCaseProvider);
    final evaluate = ref.read(evaluateWeatherEncountersUseCaseProvider);
    final getTypeDetail = ref.read(getTypeDetailUseCaseProvider);

    final location = await getLocation();
    final forecast = await getForecast(
      latitude: location.latitude,
      longitude: location.longitude,
    );
    final report = evaluate(forecast);

    List<PokemonSummary> sampleEncounters = const [];
    if (report.recommendations.isNotEmpty) {
      try {
        final primaryType = report.recommendations.first.typeName;
        final typeDetail = await getTypeDetail(primaryType);
        sampleEncounters = typeDetail.pokemonList
            .where((p) => p.id <= 1025)
            .take(8)
            .toList();
      } catch (_) {
        sampleEncounters = const [];
      }
    }

    return WeatherRadarBundle(
      location: location,
      forecast: forecast,
      encounterReport: report,
      sampleEncounters: sampleEncounters,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}
