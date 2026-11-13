import '../../domain/entities/notification_settings.dart';
import '../../domain/entities/recommended_pokemon_alert.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/local_notification_data_source.dart';
import '../datasources/notification_settings_local_data_source.dart';
import '../datasources/random_pokemon_alert_provider.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl({
    required this._localDataSource,
    required this._notificationDataSource,
    required this._alertProvider,
  });

  final NotificationSettingsLocalDataSource _localDataSource;
  final LocalNotificationDataSource _notificationDataSource;
  final RandomPokemonAlertProvider _alertProvider;

  @override
  Future<NotificationSettings> getSettings() {
    return _localDataSource.load();
  }

  @override
  Future<NotificationSettings> updateSchedule({
    required bool enabled,
    required int intervalMinutes,
  }) async {
    final current = await _localDataSource.load();
    await _notificationDataSource.configurePeriodicSchedule(
      enabled: enabled,
      intervalMinutes: intervalMinutes,
    );
    final updated = current.copyWith(
      enabled: enabled,
      intervalMinutes: intervalMinutes,
      lastScheduledIso: enabled ? DateTime.now().toIso8601String() : null,
    );
    return _localDataSource.save(updated);
  }

  @override
  Future<RecommendedPokemonAlert> triggerTestNotification() async {
    await _notificationDataSource.requestPermission();
    final alert = await _alertProvider.generateRandomAlert();
    await _notificationDataSource.showPokemonAlert(
      alert,
      id: DateTime.now().millisecondsSinceEpoch % 100000,
    );

    final current = await _localDataSource.load();
    await _localDataSource.save(
      current.copyWith(
        lastRecommendedId: alert.id,
        lastRecommendedName: alert.name,
        lastScheduledIso: DateTime.now().toIso8601String(),
      ),
    );
    return alert;
  }
}
