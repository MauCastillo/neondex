import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/favorites/data/datasources/favorites_local_data_source.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/favorites/domain/usecases/get_favorites.dart';
import '../../features/favorites/domain/usecases/toggle_favorite.dart';
import '../../features/notifications_settings/data/datasources/android_permission_data_source.dart';
import '../../features/notifications_settings/data/datasources/local_notification_data_source.dart';
import '../../features/notifications_settings/data/datasources/notification_settings_local_data_source.dart';
import '../../features/notifications_settings/data/datasources/random_pokemon_alert_provider.dart';
import '../../features/notifications_settings/data/repositories/notification_repository_impl.dart';
import '../../features/notifications_settings/data/repositories/permission_diagnostics_repository_impl.dart';
import '../../features/notifications_settings/domain/repositories/notification_repository.dart';
import '../../features/notifications_settings/domain/repositories/permission_diagnostics_repository.dart';
import '../../features/notifications_settings/domain/usecases/check_android_permissions.dart';
import '../../features/notifications_settings/domain/usecases/get_notification_settings.dart';
import '../../features/notifications_settings/domain/usecases/request_android_permission.dart';
import '../../features/notifications_settings/domain/usecases/trigger_test_notification.dart';
import '../../features/notifications_settings/domain/usecases/update_notification_schedule.dart';
import '../../features/pokedex/data/datasources/pokedex_remote_data_source.dart';
import '../../features/pokedex/data/repositories/pokedex_repository_impl.dart';
import '../../features/pokedex/domain/repositories/pokedex_repository.dart';
import '../../features/pokedex/domain/usecases/calculate_type_effectiveness.dart';
import '../../features/pokedex/domain/usecases/get_ability_detail.dart';
import '../../features/pokedex/domain/usecases/get_evolution_chain.dart';
import '../../features/pokedex/domain/usecases/get_move_detail.dart';
import '../../features/pokedex/domain/usecases/get_pokemon_detail.dart';
import '../../features/pokedex/domain/usecases/get_pokemon_list.dart';
import '../../features/pokedex/domain/usecases/get_pokemon_species.dart';
import '../../features/pokedex/domain/usecases/get_type_detail.dart';
import '../../features/weather_radar/data/datasources/location_data_source.dart';
import '../../features/weather_radar/data/datasources/open_meteo_remote_data_source.dart';
import '../../features/weather_radar/data/repositories/weather_radar_repository_impl.dart';
import '../../features/weather_radar/domain/repositories/weather_radar_repository.dart';
import '../../features/weather_radar/domain/usecases/evaluate_weather_encounters.dart';
import '../../features/weather_radar/domain/usecases/get_current_location.dart';
import '../../features/weather_radar/domain/usecases/get_weather_forecast.dart';
import '../network/api_client.dart';
import '../router/deep_link_coordinator.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator({
  SharedPreferences? sharedPreferences,
  http.Client? httpClient,
  bool initializePlatformServices = true,
}) async {
  await sl.reset();

  final prefs = sharedPreferences ?? await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient(httpClient: httpClient));
  sl.registerLazySingleton<DeepLinkCoordinator>(() => DeepLinkCoordinator());

  // Pokedex Feature
  sl.registerLazySingleton<PokedexRemoteDataSource>(
    () => PokedexRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<PokedexRepository>(
    () => PokedexRepositoryImpl(sl<PokedexRemoteDataSource>()),
  );
  sl.registerLazySingleton(() => GetPokemonList(sl<PokedexRepository>()));
  sl.registerLazySingleton(() => GetPokemonDetail(sl<PokedexRepository>()));
  sl.registerLazySingleton(() => GetPokemonSpecies(sl<PokedexRepository>()));
  sl.registerLazySingleton(() => GetEvolutionChain(sl<PokedexRepository>()));
  sl.registerLazySingleton(() => GetTypeDetail(sl<PokedexRepository>()));
  sl.registerLazySingleton(() => GetAbilityDetail(sl<PokedexRepository>()));
  sl.registerLazySingleton(() => GetMoveDetail(sl<PokedexRepository>()));
  sl.registerLazySingleton(() => const CalculateTypeEffectiveness());

  // Favorites Feature
  sl.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(sl<FavoritesLocalDataSource>()),
  );
  sl.registerLazySingleton(() => GetFavorites(sl<FavoritesRepository>()));
  sl.registerLazySingleton(() => ToggleFavorite(sl<FavoritesRepository>()));

  // Weather Radar Feature
  sl.registerLazySingleton<LocationDataSource>(
    () => const GeolocatorDataSourceImpl(),
  );
  sl.registerLazySingleton<OpenMeteoRemoteDataSource>(
    () => OpenMeteoRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<WeatherRadarRepository>(
    () => WeatherRadarRepositoryImpl(
      locationDataSource: sl<LocationDataSource>(),
      remoteDataSource: sl<OpenMeteoRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetCurrentLocation(sl<WeatherRadarRepository>()),
  );
  sl.registerLazySingleton(
    () => GetWeatherForecast(sl<WeatherRadarRepository>()),
  );
  sl.registerLazySingleton(() => const EvaluateWeatherEncounters());

  // Notifications & Diagnostics Feature
  sl.registerLazySingleton<RandomPokemonAlertProvider>(
    () => RandomPokemonAlertProvider(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<NotificationSettingsLocalDataSource>(
    () => NotificationSettingsLocalDataSourceImpl(sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<LocalNotificationDataSource>(
    () => LocalNotificationDataSourceImpl(
      deepLinkCoordinator: sl<DeepLinkCoordinator>(),
      alertProvider: sl<RandomPokemonAlertProvider>(),
    ),
  );
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      localDataSource: sl<NotificationSettingsLocalDataSource>(),
      notificationDataSource: sl<LocalNotificationDataSource>(),
      alertProvider: sl<RandomPokemonAlertProvider>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetNotificationSettings(sl<NotificationRepository>()),
  );
  sl.registerLazySingleton(
    () => UpdateNotificationSchedule(sl<NotificationRepository>()),
  );
  sl.registerLazySingleton(
    () => TriggerTestNotification(sl<NotificationRepository>()),
  );

  sl.registerLazySingleton<AndroidPermissionDataSource>(
    () => const AndroidPermissionDataSourceImpl(),
  );
  sl.registerLazySingleton<PermissionDiagnosticsRepository>(
    () => PermissionDiagnosticsRepositoryImpl(
      sl<AndroidPermissionDataSource>(),
    ),
  );
  sl.registerLazySingleton(
    () => CheckAndroidPermissions(sl<PermissionDiagnosticsRepository>()),
  );
  sl.registerLazySingleton(
    () => RequestAndroidPermission(sl<PermissionDiagnosticsRepository>()),
  );

  if (initializePlatformServices) {
    await initializePlatformServicesSafely();
  }
}

/// Initializes platform deep links, local notifications, and background tasks
/// without throwing or blocking initial UI startup.
Future<void> initializePlatformServicesSafely() async {
  try {
    await sl<DeepLinkCoordinator>().initPlatformLinks();
  } catch (e, st) {
    debugPrint('DeepLinkCoordinator init failed: $e\n$st');
  }

  try {
    await sl<LocalNotificationDataSource>().initialize();
  } catch (e, st) {
    debugPrint('LocalNotificationDataSource init failed: $e\n$st');
    return;
  }

  try {
    final savedSettings = await sl<GetNotificationSettings>()();
    if (savedSettings.enabled) {
      await sl<LocalNotificationDataSource>().configurePeriodicSchedule(
        enabled: true,
        intervalMinutes: savedSettings.intervalMinutes,
      );
    }
  } catch (e, st) {
    debugPrint('Notification schedule restore failed: $e\n$st');
  }
}
