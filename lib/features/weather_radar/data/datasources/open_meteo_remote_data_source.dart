import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/weather_forecast_model.dart';

abstract class OpenMeteoRemoteDataSource {
  Future<WeatherForecastModel> fetchForecast({
    required double latitude,
    required double longitude,
  });
}

class OpenMeteoRemoteDataSourceImpl implements OpenMeteoRemoteDataSource {
  const OpenMeteoRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<WeatherForecastModel> fetchForecast({
    required double latitude,
    required double longitude,
  }) async {
    final json = await _apiClient.getJson(
      ApiConstants.openMeteoForecastEndpoint(
        latitude: latitude,
        longitude: longitude,
      ),
      useCache: false,
    );
    return WeatherForecastModel.fromJson(json);
  }
}
