import '../entities/weather_forecast.dart';
import '../repositories/weather_radar_repository.dart';

class GetWeatherForecast {
  const GetWeatherForecast(this._repository);

  final WeatherRadarRepository _repository;

  Future<WeatherForecast> call({
    required double latitude,
    required double longitude,
  }) {
    return _repository.getWeatherForecast(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
