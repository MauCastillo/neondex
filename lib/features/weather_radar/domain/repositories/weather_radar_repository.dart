import '../entities/geo_location.dart';
import '../entities/weather_forecast.dart';

abstract class WeatherRadarRepository {
  Future<GeoLocation> getCurrentLocation();

  Future<WeatherForecast> getWeatherForecast({
    required double latitude,
    required double longitude,
  });
}
