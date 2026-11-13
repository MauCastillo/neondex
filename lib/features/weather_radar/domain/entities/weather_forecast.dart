import 'package:equatable/equatable.dart';

class HourlyForecastPoint extends Equatable {
  const HourlyForecastPoint({
    required this.timeIso,
    required this.temperatureC,
    required this.precipitationProbability,
    required this.weatherCode,
  });

  final String timeIso;
  final double temperatureC;
  final int precipitationProbability;
  final int weatherCode;

  String get hourLabel {
    final tIndex = timeIso.indexOf('T');
    if (tIndex != -1 && timeIso.length >= tIndex + 6) {
      return timeIso.substring(tIndex + 1, tIndex + 6);
    }
    return timeIso;
  }

  @override
  List<Object?> get props => [
        timeIso,
        temperatureC,
        precipitationProbability,
        weatherCode,
      ];
}

class WeatherForecast extends Equatable {
  const WeatherForecast({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.elevation,
    required this.temperatureC,
    required this.apparentTemperatureC,
    required this.relativeHumidity,
    required this.isDay,
    required this.precipitationMm,
    required this.rainMm,
    required this.weatherCode,
    required this.cloudCoverPercent,
    required this.windSpeedKmh,
    required this.hourlyPoints,
  });

  final double latitude;
  final double longitude;
  final String timezone;
  final String timezoneAbbreviation;
  final double elevation;
  final double temperatureC;
  final double apparentTemperatureC;
  final int relativeHumidity;
  final bool isDay;
  final double precipitationMm;
  final double rainMm;
  final int weatherCode;
  final int cloudCoverPercent;
  final double windSpeedKmh;
  final List<HourlyForecastPoint> hourlyPoints;

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        timezone,
        timezoneAbbreviation,
        elevation,
        temperatureC,
        apparentTemperatureC,
        relativeHumidity,
        isDay,
        precipitationMm,
        rainMm,
        weatherCode,
        cloudCoverPercent,
        windSpeedKmh,
        hourlyPoints,
      ];
}
