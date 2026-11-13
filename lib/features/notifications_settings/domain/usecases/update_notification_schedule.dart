import '../entities/notification_settings.dart';
import '../repositories/notification_repository.dart';

class UpdateNotificationSchedule {
  const UpdateNotificationSchedule(this._repository);

  final NotificationRepository _repository;

  Future<NotificationSettings> call({
    required bool enabled,
    required int intervalMinutes,
  }) {
    return _repository.updateSchedule(
      enabled: enabled,
      intervalMinutes: intervalMinutes,
    );
  }
}
