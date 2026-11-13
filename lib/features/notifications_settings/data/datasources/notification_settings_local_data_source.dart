import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../domain/entities/notification_settings.dart';

abstract class NotificationSettingsLocalDataSource {
  Future<NotificationSettings> load();
  Future<NotificationSettings> save(NotificationSettings settings);
}

class NotificationSettingsLocalDataSourceImpl
    implements NotificationSettingsLocalDataSource {
  const NotificationSettingsLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<NotificationSettings> load() async {
    return NotificationSettings(
      enabled: _prefs.getBool(StorageKeys.notificationEnabled) ?? false,
      intervalMinutes:
          _prefs.getInt(StorageKeys.notificationIntervalMinutes) ?? 30,
      lastRecommendedId: _prefs.getInt(StorageKeys.lastRecommendedPokemonId),
      lastRecommendedName:
          _prefs.getString(StorageKeys.lastRecommendedPokemonName),
      lastScheduledIso: _prefs.getString(StorageKeys.lastScheduledIso),
    );
  }

  @override
  Future<NotificationSettings> save(NotificationSettings settings) async {
    await _prefs.setBool(StorageKeys.notificationEnabled, settings.enabled);
    await _prefs.setInt(
      StorageKeys.notificationIntervalMinutes,
      settings.intervalMinutes,
    );
    if (settings.lastRecommendedId != null) {
      await _prefs.setInt(
        StorageKeys.lastRecommendedPokemonId,
        settings.lastRecommendedId!,
      );
    }
    if (settings.lastRecommendedName != null) {
      await _prefs.setString(
        StorageKeys.lastRecommendedPokemonName,
        settings.lastRecommendedName!,
      );
    }
    if (settings.lastScheduledIso != null) {
      await _prefs.setString(
        StorageKeys.lastScheduledIso,
        settings.lastScheduledIso!,
      );
    }
    return settings;
  }
}
