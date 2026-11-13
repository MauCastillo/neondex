import '../entities/notification_settings.dart';
import '../entities/recommended_pokemon_alert.dart';

abstract class NotificationRepository {
  Future<NotificationSettings> getSettings();

  Future<NotificationSettings> updateSchedule({
    required bool enabled,
    required int intervalMinutes,
  });

  Future<RecommendedPokemonAlert> triggerTestNotification();
}
