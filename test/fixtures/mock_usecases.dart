import 'package:mocktail/mocktail.dart';
import 'package:neondex/features/favorites/domain/usecases/get_favorites.dart';
import 'package:neondex/features/favorites/domain/usecases/toggle_favorite.dart';
import 'package:neondex/features/notifications_settings/domain/entities/android_permission_item.dart';
import 'package:neondex/features/notifications_settings/domain/entities/notification_settings.dart';
import 'package:neondex/features/notifications_settings/domain/repositories/permission_diagnostics_repository.dart';
import 'package:neondex/features/notifications_settings/domain/usecases/check_android_permissions.dart';
import 'package:neondex/features/notifications_settings/domain/usecases/get_notification_settings.dart';
import 'package:neondex/features/notifications_settings/domain/usecases/request_android_permission.dart';
import 'package:neondex/features/notifications_settings/domain/usecases/trigger_test_notification.dart';
import 'package:neondex/features/notifications_settings/domain/usecases/update_notification_schedule.dart';
import 'package:neondex/features/pokedex/domain/entities/pokemon_summary.dart';
import 'package:neondex/features/pokedex/domain/usecases/get_ability_detail.dart';
import 'package:neondex/features/pokedex/domain/usecases/get_evolution_chain.dart';
import 'package:neondex/features/pokedex/domain/usecases/get_move_detail.dart';
import 'package:neondex/features/pokedex/domain/usecases/get_pokemon_detail.dart';
import 'package:neondex/features/pokedex/domain/usecases/get_pokemon_list.dart';
import 'package:neondex/features/pokedex/domain/usecases/get_pokemon_species.dart';
import 'package:neondex/features/pokedex/domain/usecases/get_type_detail.dart';
import 'package:neondex/features/weather_radar/domain/usecases/get_current_location.dart';
import 'package:neondex/features/weather_radar/domain/usecases/get_weather_forecast.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:neondex/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:neondex/features/notifications_settings/presentation/providers/notification_settings_provider.dart';
import 'package:neondex/features/notifications_settings/presentation/providers/permissions_diagnostics_provider.dart';
import 'package:neondex/features/pokedex/domain/usecases/calculate_type_effectiveness.dart';
import 'package:neondex/features/pokedex/presentation/providers/pokedex_usecase_providers.dart';
import 'package:neondex/features/weather_radar/domain/usecases/evaluate_weather_encounters.dart';
import 'package:neondex/features/weather_radar/presentation/providers/weather_radar_provider.dart';

import 'fake_data.dart';

class MockGetPokemonList extends Mock implements GetPokemonList {}

class MockGetPokemonDetail extends Mock implements GetPokemonDetail {}

class MockGetPokemonSpecies extends Mock implements GetPokemonSpecies {}

class MockGetEvolutionChain extends Mock implements GetEvolutionChain {}

class MockGetTypeDetail extends Mock implements GetTypeDetail {}

class MockGetAbilityDetail extends Mock implements GetAbilityDetail {}

class MockGetMoveDetail extends Mock implements GetMoveDetail {}

class MockGetFavorites extends Mock implements GetFavorites {}

class MockToggleFavorite extends Mock implements ToggleFavorite {}

class MockGetCurrentLocation extends Mock implements GetCurrentLocation {}

class MockGetWeatherForecast extends Mock implements GetWeatherForecast {}

class MockGetNotificationSettings extends Mock
    implements GetNotificationSettings {}

class MockUpdateNotificationSchedule extends Mock
    implements UpdateNotificationSchedule {}

class MockTriggerTestNotification extends Mock
    implements TriggerTestNotification {}

class MockCheckAndroidPermissions extends Mock
    implements CheckAndroidPermissions {}

class MockRequestAndroidPermission extends Mock
    implements RequestAndroidPermission {}

class MockPermissionDiagnosticsRepository extends Mock
    implements PermissionDiagnosticsRepository {}

class TestUseCaseBundle {
  TestUseCaseBundle() {
    registerFallbackValue(FakeTestFixtures.pikachuSummary);
    registerFallbackValue(AndroidPermissionKind.notification);
  }

  final getPokemonList = MockGetPokemonList();
  final getPokemonDetail = MockGetPokemonDetail();
  final getPokemonSpecies = MockGetPokemonSpecies();
  final getEvolutionChain = MockGetEvolutionChain();
  final getTypeDetail = MockGetTypeDetail();
  final getAbilityDetail = MockGetAbilityDetail();
  final getMoveDetail = MockGetMoveDetail();
  final getFavorites = MockGetFavorites();
  final toggleFavorite = MockToggleFavorite();
  final getCurrentLocation = MockGetCurrentLocation();
  final getWeatherForecast = MockGetWeatherForecast();
  final getNotificationSettings = MockGetNotificationSettings();
  final updateNotificationSchedule = MockUpdateNotificationSchedule();
  final triggerTestNotification = MockTriggerTestNotification();
  final checkAndroidPermissions = MockCheckAndroidPermissions();
  final requestAndroidPermission = MockRequestAndroidPermission();
  final permissionRepo = MockPermissionDiagnosticsRepository();

  void stubDefaults() {
    when(
      () => getPokemonList(limit: any(named: 'limit'), offset: 0),
    ).thenAnswer((_) async => FakeTestFixtures.firstPokedexPage);
    when(
      () => getPokemonList(limit: any(named: 'limit'), offset: 4),
    ).thenAnswer((_) async => FakeTestFixtures.secondPokedexPage);

    when(() => getPokemonDetail(any()))
        .thenAnswer((_) async => FakeTestFixtures.pikachuDetail);
    when(() => getPokemonSpecies(any()))
        .thenAnswer((_) async => FakeTestFixtures.pikachuSpecies);
    when(() => getEvolutionChain(any()))
        .thenAnswer((_) async => FakeTestFixtures.pikachuEvolutionChain);
    when(() => getTypeDetail(any()))
        .thenAnswer((_) async => FakeTestFixtures.electricTypeDetail);
    when(() => getAbilityDetail(any()))
        .thenAnswer((_) async => FakeTestFixtures.staticAbility);
    when(() => getMoveDetail(any()))
        .thenAnswer((_) async => FakeTestFixtures.thunderboltMove);

    final favStore = <PokemonSummary>[];
    when(() => getFavorites()).thenAnswer((_) async => List.of(favStore));
    when(() => toggleFavorite(any())).thenAnswer((invocation) async {
      final p = invocation.positionalArguments.first as PokemonSummary;
      final idx = favStore.indexWhere((e) => e.id == p.id);
      if (idx >= 0) {
        favStore.removeAt(idx);
      } else {
        favStore.insert(0, p);
      }
      return List.of(favStore);
    });

    when(() => getCurrentLocation())
        .thenAnswer((_) async => FakeTestFixtures.testLocation);
    when(
      () => getWeatherForecast(
        latitude: any(named: 'latitude'),
        longitude: any(named: 'longitude'),
      ),
    ).thenAnswer((_) async => FakeTestFixtures.stormForecast);

    var notifState = FakeTestFixtures.defaultNotifSettings;
    when(() => getNotificationSettings()).thenAnswer((_) async => notifState);
    when(
      () => updateNotificationSchedule(
        enabled: any(named: 'enabled'),
        intervalMinutes: any(named: 'intervalMinutes'),
      ),
    ).thenAnswer((invocation) async {
      notifState = NotificationSettings(
        enabled: invocation.namedArguments[#enabled] as bool,
        intervalMinutes: invocation.namedArguments[#intervalMinutes] as int,
      );
      return notifState;
    });
    when(() => triggerTestNotification()).thenAnswer((_) async {
      notifState = notifState.copyWith(
        lastRecommendedId: FakeTestFixtures.sampleAlert.id,
        lastRecommendedName: FakeTestFixtures.sampleAlert.name,
      );
      return FakeTestFixtures.sampleAlert;
    });

    when(() => checkAndroidPermissions())
        .thenAnswer((_) async => FakeTestFixtures.samplePermissions);
    when(() => requestAndroidPermission(any())).thenAnswer((_) async => [
          FakeTestFixtures.samplePermissions.first,
          const AndroidPermissionItem(
            kind: AndroidPermissionKind.notification,
            title: 'Notificaciones Locales',
            manifestPermission: 'POST_NOTIFICATIONS (Android 13+)',
            description: 'Permite alertas programadas y pruebas interactivas.',
            status: DiagnosticPermissionStatus.granted,
            canRequestInApp: true,
          ),
        ]);
  }

  List<Override> buildOverrides() {
    return [
      getPokemonListUseCaseProvider.overrideWithValue(getPokemonList),
      getPokemonDetailUseCaseProvider.overrideWithValue(getPokemonDetail),
      getPokemonSpeciesUseCaseProvider.overrideWithValue(getPokemonSpecies),
      getEvolutionChainUseCaseProvider.overrideWithValue(getEvolutionChain),
      getTypeDetailUseCaseProvider.overrideWithValue(getTypeDetail),
      getAbilityDetailUseCaseProvider.overrideWithValue(getAbilityDetail),
      getMoveDetailUseCaseProvider.overrideWithValue(getMoveDetail),
      calculateTypeEffectivenessUseCaseProvider
          .overrideWithValue(const CalculateTypeEffectiveness()),
      getFavoritesUseCaseProvider.overrideWithValue(getFavorites),
      toggleFavoriteUseCaseProvider.overrideWithValue(toggleFavorite),
      getCurrentLocationUseCaseProvider.overrideWithValue(getCurrentLocation),
      getWeatherForecastUseCaseProvider.overrideWithValue(getWeatherForecast),
      evaluateWeatherEncountersUseCaseProvider
          .overrideWithValue(const EvaluateWeatherEncounters()),
      getNotificationSettingsUseCaseProvider
          .overrideWithValue(getNotificationSettings),
      updateNotificationScheduleUseCaseProvider
          .overrideWithValue(updateNotificationSchedule),
      triggerTestNotificationUseCaseProvider
          .overrideWithValue(triggerTestNotification),
      checkAndroidPermissionsUseCaseProvider
          .overrideWithValue(checkAndroidPermissions),
      requestAndroidPermissionUseCaseProvider
          .overrideWithValue(requestAndroidPermission),
      permissionDiagnosticsRepositoryProvider.overrideWithValue(permissionRepo),
    ];
  }
}
