import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/service_locator.dart';
import '../../domain/entities/notification_settings.dart';
import '../../domain/entities/recommended_pokemon_alert.dart';
import '../../domain/usecases/get_notification_settings.dart';
import '../../domain/usecases/trigger_test_notification.dart';
import '../../domain/usecases/update_notification_schedule.dart';

final getNotificationSettingsUseCaseProvider =
    Provider<GetNotificationSettings>(
  (ref) => sl<GetNotificationSettings>(),
);

final updateNotificationScheduleUseCaseProvider =
    Provider<UpdateNotificationSchedule>(
  (ref) => sl<UpdateNotificationSchedule>(),
);

final triggerTestNotificationUseCaseProvider =
    Provider<TriggerTestNotification>(
  (ref) => sl<TriggerTestNotification>(),
);

final notificationSettingsProvider =
    AsyncNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
  NotificationSettingsNotifier.new,
);

class NotificationSettingsNotifier extends AsyncNotifier<NotificationSettings> {
  @override
  Future<NotificationSettings> build() {
    return ref.read(getNotificationSettingsUseCaseProvider)();
  }

  Future<void> updateSchedule({
    required bool enabled,
    required int intervalMinutes,
  }) async {
    final updated = await ref.read(updateNotificationScheduleUseCaseProvider)(
      enabled: enabled,
      intervalMinutes: intervalMinutes,
    );
    if (!ref.mounted) return;
    state = AsyncData(updated);
  }

  Future<RecommendedPokemonAlert> triggerTest() async {
    final alert = await ref.read(triggerTestNotificationUseCaseProvider)();
    final refreshed = await ref.read(getNotificationSettingsUseCaseProvider)();
    if (ref.mounted) {
      state = AsyncData(refreshed);
    }
    return alert;
  }
}
