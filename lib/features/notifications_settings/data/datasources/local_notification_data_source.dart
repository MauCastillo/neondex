import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

import '../../../../core/router/deep_link_coordinator.dart';
import '../../../../core/theme/cyber_colors.dart';
import '../../domain/entities/recommended_pokemon_alert.dart';
import 'random_pokemon_alert_provider.dart';

const String kPeriodicPokemonTaskUniqueName = 'neondex_periodic_pokemon_radar';
const String kPeriodicPokemonTaskName = 'neondexPeriodicPokemonTask';

@pragma('vm:entry-point')
void neondexBackgroundDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      final plugin = FlutterLocalNotificationsPlugin();
      const androidInit = AndroidInitializationSettings('ic_stat_neondex');
      const darwinInit = DarwinInitializationSettings();
      await plugin.initialize(
        settings: const InitializationSettings(
          android: androidInit,
          iOS: darwinInit,
        ),
      );

      final alertProvider = RandomPokemonAlertProvider();
      final alert = await alertProvider.generateRandomAlert();
      await LocalNotificationDataSourceImpl.showAlertWithPlugin(
        plugin: plugin,
        alert: alert,
        notificationId: 8801,
      );
      return true;
    } catch (_) {
      return false;
    }
  });
}

abstract class LocalNotificationDataSource {
  Future<void> initialize();

  Future<void> showPokemonAlert(RecommendedPokemonAlert alert, {int id = 1001});

  Future<void> configurePeriodicSchedule({
    required bool enabled,
    required int intervalMinutes,
  });

  Future<bool> requestPermission();
}

class LocalNotificationDataSourceImpl implements LocalNotificationDataSource {
  LocalNotificationDataSourceImpl({
    required this._deepLinkCoordinator,
    required this._alertProvider,
    FlutterLocalNotificationsPlugin? plugin,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final DeepLinkCoordinator _deepLinkCoordinator;
  final RandomPokemonAlertProvider _alertProvider;
  final FlutterLocalNotificationsPlugin _plugin;

  static const String _channelId = 'neondex_encounters';
  static const String _channelName = 'Radar de Encuentros NeonDex';
  static const String _channelDesc =
      'Recomendaciones periódicas de Pokémon y notificaciones de prueba.';
  static const int _scheduledNextId = 7701;

  bool _initialized = false;
  Timer? _rapidDemoTimer;

  static String _androidSmallIcon = 'ic_stat_neondex';

  static NotificationDetails _buildNotificationDetails(String body) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.high,
        priority: Priority.high,
        icon: _androidSmallIcon,
        color: CyberColors.neonCyan,
        styleInformation: BigTextStyleInformation(body),
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  static Future<void> showAlertWithPlugin({
    required FlutterLocalNotificationsPlugin plugin,
    required RecommendedPokemonAlert alert,
    required int notificationId,
  }) async {
    await plugin.show(
      id: notificationId,
      title: alert.notificationTitle,
      body: alert.notificationBody,
      notificationDetails: _buildNotificationDetails(alert.notificationBody),
      payload: alert.deepLinkPayload,
    );
  }

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    try {
      tz_data.initializeTimeZones();
    } catch (_) {
      // Never block startup if timezone database fails to initialize.
    }

    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      return;
    }

    const darwinInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    Future<void> initWithIcon(String iconName) {
      return _plugin.initialize(
        settings: InitializationSettings(
          android: AndroidInitializationSettings(iconName),
          iOS: darwinInit,
        ),
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          _deepLinkCoordinator.handlePayload(response.payload);
        },
      );
    }

    try {
      await initWithIcon(_androidSmallIcon);
    } catch (_) {
      // Fallback to launcher mipmap if custom drawable is stripped/unavailable.
      _androidSmallIcon = '@mipmap/ic_launcher';
      try {
        await initWithIcon(_androidSmallIcon);
      } catch (_) {
        // Keep initialization non-fatal so UI can always boot.
      }
    }

    try {
      final launchDetails = await _plugin.getNotificationAppLaunchDetails();
      if (launchDetails != null && launchDetails.didNotificationLaunchApp) {
        _deepLinkCoordinator.handlePayload(
          launchDetails.notificationResponse?.payload,
        );
      }
    } catch (_) {}

    if (Platform.isAndroid) {
      try {
        final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        await androidPlugin?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDesc,
            importance: Importance.high,
          ),
        );
      } catch (_) {}
    }

    try {
      await Workmanager().initialize(neondexBackgroundDispatcher);
    } catch (_) {
      // WorkManager may be unavailable in unit/widget test harnesses.
    }
  }

  @override
  Future<bool> requestPermission() async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      return true;
    }
    if (Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      return (await androidPlugin?.requestNotificationsPermission()) ?? true;
    }
    if (Platform.isIOS) {
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      return (await iosPlugin?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          )) ??
          true;
    }
    return true;
  }

  @override
  Future<void> showPokemonAlert(
    RecommendedPokemonAlert alert, {
    int id = 1001,
  }) async {
    if (!_initialized) {
      await initialize();
    }
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      return;
    }
    await showAlertWithPlugin(
      plugin: _plugin,
      alert: alert,
      notificationId: id,
    );
  }

  @override
  Future<void> configurePeriodicSchedule({
    required bool enabled,
    required int intervalMinutes,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    _rapidDemoTimer?.cancel();
    _rapidDemoTimer = null;

    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      return;
    }

    try {
      await _plugin.cancel(id: _scheduledNextId);
    } catch (_) {}

    try {
      await Workmanager().cancelByUniqueName(kPeriodicPokemonTaskUniqueName);
    } catch (_) {}

    if (!enabled) return;

    await requestPermission();

    if (intervalMinutes >= 15) {
      await Workmanager().registerPeriodicTask(
        kPeriodicPokemonTaskUniqueName,
        kPeriodicPokemonTaskName,
        frequency: Duration(minutes: intervalMinutes),
        initialDelay: Duration(minutes: intervalMinutes),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
      );
    } else {
      // Rapid demo mode (<15 min): schedule next zoned alert + foreground periodic ticker.
      await _scheduleNextOneShot(intervalMinutes);
      _rapidDemoTimer = Timer.periodic(
        Duration(minutes: intervalMinutes),
        (_) async {
          final alert = await _alertProvider.generateRandomAlert();
          await showPokemonAlert(alert, id: _scheduledNextId + 1);
          await _scheduleNextOneShot(intervalMinutes);
        },
      );
    }
  }

  Future<void> _scheduleNextOneShot(int intervalMinutes) async {
    final nextAlert = await _alertProvider.generateRandomAlert();
    final scheduledAt = tz.TZDateTime.now(tz.UTC).add(
      Duration(minutes: intervalMinutes),
    );
    await _plugin.zonedSchedule(
      id: _scheduledNextId,
      title: nextAlert.notificationTitle,
      body: nextAlert.notificationBody,
      scheduledDate: scheduledAt,
      notificationDetails:
          _buildNotificationDetails(nextAlert.notificationBody),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: nextAlert.deepLinkPayload,
    );
  }
}
