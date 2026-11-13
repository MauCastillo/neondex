import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neondex/core/di/service_locator.dart';
import 'package:neondex/core/network/api_client.dart';
import 'package:neondex/core/router/deep_link_coordinator.dart';
import 'package:neondex/features/notifications_settings/data/datasources/local_notification_data_source.dart';
import 'package:neondex/features/notifications_settings/data/datasources/notification_settings_local_data_source.dart';
import 'package:neondex/features/notifications_settings/data/datasources/random_pokemon_alert_provider.dart';
import 'package:neondex/features/notifications_settings/data/repositories/notification_repository_impl.dart';
import 'package:neondex/features/notifications_settings/domain/entities/recommended_pokemon_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockLocalNotificationDataSource extends Mock
    implements LocalNotificationDataSource {}

class _MockDeepLinkCoordinator extends Mock implements DeepLinkCoordinator {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const RecommendedPokemonAlert(
        id: 25,
        name: 'pikachu',
        types: ['electric'],
        hp: 35,
        attack: 55,
        speed: 90,
      ),
    );
  });

  test('RandomPokemonAlertProvider parses API response and falls back cleanly offline', () async {
    final liveClient = MockClient((_) async {
      return http.Response(
        jsonEncode({
          'id': 25,
          'name': 'pikachu',
          'height': 4,
          'weight': 60,
          'base_experience': 112,
          'types': [
            {'slot': 1, 'type': {'name': 'electric'}},
          ],
          'stats': [
            {'base_stat': 35, 'effort': 0, 'stat': {'name': 'hp'}},
            {'base_stat': 55, 'effort': 0, 'stat': {'name': 'attack'}},
            {'base_stat': 90, 'effort': 2, 'stat': {'name': 'speed'}},
          ],
          'abilities': [],
          'moves': [],
          'species': {'name': 'pikachu', 'url': 'https://pokeapi.co/api/v2/pokemon-species/25/'},
          'sprites': {},
        }),
        200,
      );
    });

    final liveProvider = RandomPokemonAlertProvider(
      apiClient: ApiClient(httpClient: liveClient),
      random: Random(1),
    );
    final liveAlert = await liveProvider.generateRandomAlert();
    expect(liveAlert.id, 25);
    expect(liveAlert.hp, 35);
    expect(liveAlert.deepLinkPayload, 'neondex://pokemon/25');

    final offlineClient = MockClient((_) async => http.Response('err', 500));
    final offlineProvider = RandomPokemonAlertProvider(
      apiClient: ApiClient(httpClient: offlineClient),
      random: Random(2),
    );
    final fallbackAlert = await offlineProvider.generateRandomAlert();
    expect(fallbackAlert.id, greaterThan(0));
    expect(fallbackAlert.types, isNotEmpty);
  });

  test('NotificationRepositoryImpl updates schedule and dispatches test alerts', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final localDs = NotificationSettingsLocalDataSourceImpl(prefs);
    final notifDs = _MockLocalNotificationDataSource();

    when(() => notifDs.configurePeriodicSchedule(
          enabled: any(named: 'enabled'),
          intervalMinutes: any(named: 'intervalMinutes'),
        )).thenAnswer((_) async {});
    when(() => notifDs.requestPermission()).thenAnswer((_) async => true);
    when(() => notifDs.showPokemonAlert(any(), id: any(named: 'id')))
        .thenAnswer((_) async {});

    final offlineClient = MockClient((_) async => http.Response('err', 500));
    final alertProvider = RandomPokemonAlertProvider(
      apiClient: ApiClient(httpClient: offlineClient),
      random: Random(4),
    );

    final repo = NotificationRepositoryImpl(
      localDataSource: localDs,
      notificationDataSource: notifDs,
      alertProvider: alertProvider,
    );

    final updated = await repo.updateSchedule(enabled: true, intervalMinutes: 45);
    expect(updated.enabled, isTrue);
    expect(updated.intervalMinutes, 45);
    expect(updated.usesBackgroundWorkManager, isTrue);

    final dispatched = await repo.triggerTestNotification();
    expect(dispatched.id, greaterThan(0));
    verify(() => notifDs.showPokemonAlert(dispatched, id: any(named: 'id')))
        .called(1);

    final persisted = await repo.getSettings();
    expect(persisted.lastRecommendedId, dispatched.id);
  });

  test('initializePlatformServicesSafely never throws when platform plugins fail',
      () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final offlineClient = MockClient((_) async => http.Response('err', 500));

    await setupServiceLocator(
      sharedPreferences: prefs,
      httpClient: offlineClient,
      initializePlatformServices: false,
    );

    final mockDeepLink = _MockDeepLinkCoordinator();
    final mockNotifDs = _MockLocalNotificationDataSource();

    when(() => mockDeepLink.initPlatformLinks())
        .thenThrow(Exception('link channel error'));
    when(() => mockNotifDs.initialize())
        .thenThrow(Exception('invalid_icon'));

    sl.unregister<DeepLinkCoordinator>();
    sl.registerSingleton<DeepLinkCoordinator>(mockDeepLink);
    sl.unregister<LocalNotificationDataSource>();
    sl.registerSingleton<LocalNotificationDataSource>(mockNotifDs);

    await expectLater(initializePlatformServicesSafely(), completes);
    verify(() => mockDeepLink.initPlatformLinks()).called(1);
    verify(() => mockNotifDs.initialize()).called(1);

    await sl.reset();
  });
}
