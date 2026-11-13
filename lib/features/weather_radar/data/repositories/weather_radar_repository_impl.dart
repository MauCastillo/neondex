import '../../domain/entities/geo_location.dart';
import '../../domain/entities/weather_forecast.dart';
import '../../domain/repositories/weather_radar_repository.dart';
import '../datasources/location_data_source.dart';
import '../datasources/open_meteo_remote_data_source.dart';

class WeatherRadarRepositoryImpl implements WeatherRadarRepository {
  const WeatherRadarRepositoryImpl({
    required this._locationDataSource,
    required this._remoteDataSource,
  });

  final LocationDataSource _locationDataSource;
  final OpenMeteoRemoteDataSource _remoteDataSource;

  @override
  Future<GeoLocation> getCurrentLocation() {
    return _locationDataSource.getCurrentLocation();
  }

  @override
  Future<WeatherForecast> getWeatherForecast({
    required double latitude,
    required double longitude,
  }) {
    return _remoteDataSource.fetchForecast(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
