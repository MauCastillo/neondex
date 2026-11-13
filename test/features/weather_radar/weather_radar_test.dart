import 'package:flutter_test/flutter_test.dart';
import 'package:neondex/features/weather_radar/data/models/weather_forecast_model.dart';
import 'package:neondex/features/weather_radar/domain/entities/weather_forecast.dart';
import 'package:neondex/features/weather_radar/domain/usecases/evaluate_weather_encounters.dart';

void main() {
  group('WeatherForecastModel', () {
    test('parses real Open-Meteo JSON response structure', () {
      final model = WeatherForecastModel.fromJson({
        'latitude': 19.4376,
        'longitude': -99.1071,
        'timezone': 'America/Mexico_City',
        'timezone_abbreviation': 'GMT-6',
        'elevation': 2230.0,
        'current': {
          'temperature_2m': 14.6,
          'relative_humidity_2m': 88,
          'apparent_temperature': 14.6,
          'is_day': 1,
          'precipitation': 0.1,
          'rain': 0.0,
          'weather_code': 51,
          'cloud_cover': 91,
          'wind_speed_10m': 5.6,
        },
        'hourly': {
          'time': ['2026-11-12T17:00', '2026-11-12T18:00'],
          'temperature_2m': [15.0, 14.6],
          'precipitation_probability': [100, 95],
          'weather_code': [95, 53],
        },
      });

      expect(model.temperatureC, 14.6);
      expect(model.relativeHumidity, 88);
      expect(model.isDay, isTrue);
      expect(model.weatherCode, 51);
      expect(model.hourlyPoints.length, 2);
      expect(model.hourlyPoints.first.hourLabel, '17:00');
      expect(model.hourlyPoints.first.precipitationProbability, 100);
    });
  });

  group('EvaluateWeatherEncounters', () {
    const evaluator = EvaluateWeatherEncounters();

    WeatherForecast buildForecast({
      required int code,
      double temp = 20,
      double wind = 10,
      bool isDay = true,
      double elevation = 100,
    }) {
      return WeatherForecast(
        latitude: 0,
        longitude: 0,
        timezone: 'UTC',
        timezoneAbbreviation: 'UTC',
        elevation: elevation,
        temperatureC: temp,
        apparentTemperatureC: temp,
        relativeHumidity: 60,
        isDay: isDay,
        precipitationMm: 0,
        rainMm: 0,
        weatherCode: code,
        cloudCoverPercent: 30,
        windSpeedKmh: wind,
        hourlyPoints: const [],
      );
    }

    test('recommends Electric on thunderstorm and Water on rainfall', () {
      final storm = evaluator(buildForecast(code: 95, wind: 28));
      expect(storm.recommendations.first.typeName, 'electric');
      expect(storm.recommendations.any((r) => r.typeName == 'flying'), isTrue);

      final rain = evaluator(buildForecast(code: 61));
      expect(rain.recommendations.first.typeName, 'water');
    });

    test('recommends Ice in freezing weather, Fire when hot, Dark at night', () {
      final snow = evaluator(buildForecast(code: 73, temp: -2));
      expect(snow.recommendations.first.typeName, 'ice');

      final hot = evaluator(buildForecast(code: 0, temp: 33));
      expect(hot.recommendations.first.typeName, 'fire');

      final night = evaluator(buildForecast(code: 1, temp: 18, isDay: false));
      expect(night.recommendations.first.typeName, 'dark');
    });
  });
}
