import '../entities/geo_location.dart';
import '../repositories/weather_radar_repository.dart';

class GetCurrentLocation {
  const GetCurrentLocation(this._repository);

  final WeatherRadarRepository _repository;

  Future<GeoLocation> call() => _repository.getCurrentLocation();
}
