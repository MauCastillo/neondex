import '../../domain/entities/weather_forecast.dart';

class WeatherForecastModel extends WeatherForecast {
  const WeatherForecastModel({
    required super.latitude,
    required super.longitude,
    required super.timezone,
    required super.timezoneAbbreviation,
    required super.elevation,
    required super.temperatureC,
    required super.apparentTemperatureC,
    required super.relativeHumidity,
    required super.isDay,
    required super.precipitationMm,
    required super.rainMm,
    required super.weatherCode,
    required super.cloudCoverPercent,
    required super.windSpeedKmh,
    required super.hourlyPoints,
  });

  factory WeatherForecastModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>? ?? const {};
    final hourly = json['hourly'] as Map<String, dynamic>? ?? const {};

    final times = (hourly['time'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList();
    final temps = (hourly['temperature_2m'] as List<dynamic>? ?? const [])
        .map((e) => (e as num?)?.toDouble() ?? 0.0)
        .toList();
    final probs =
        (hourly['precipitation_probability'] as List<dynamic>? ?? const [])
            .map((e) => (e as num?)?.toInt() ?? 0)
            .toList();
    final codes = (hourly['weather_code'] as List<dynamic>? ?? const [])
        .map((e) => (e as num?)?.toInt() ?? 0)
        .toList();

    final count = [times.length, temps.length, probs.length, codes.length]
        .reduce((a, b) => a < b ? a : b);

    final hourlyPoints = List<HourlyForecastPoint>.generate(
      count,
      (i) => HourlyForecastPoint(
        timeIso: times[i],
        temperatureC: temps[i],
        precipitationProbability: probs[i],
        weatherCode: codes[i],
      ),
    );

    return WeatherForecastModel(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      timezone: json['timezone'] as String? ?? 'UTC',
      timezoneAbbreviation: json['timezone_abbreviation'] as String? ?? 'UTC',
      elevation: (json['elevation'] as num?)?.toDouble() ?? 0.0,
      temperatureC: (current['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      apparentTemperatureC:
          (current['apparent_temperature'] as num?)?.toDouble() ?? 0.0,
      relativeHumidity: (current['relative_humidity_2m'] as num?)?.toInt() ?? 0,
      isDay: ((current['is_day'] as num?)?.toInt() ?? 1) == 1,
      precipitationMm: (current['precipitation'] as num?)?.toDouble() ?? 0.0,
      rainMm: (current['rain'] as num?)?.toDouble() ?? 0.0,
      weatherCode: (current['weather_code'] as num?)?.toInt() ?? 0,
      cloudCoverPercent: (current['cloud_cover'] as num?)?.toInt() ?? 0,
      windSpeedKmh: (current['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
      hourlyPoints: hourlyPoints,
    );
  }
}
