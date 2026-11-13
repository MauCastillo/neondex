import '../entities/notification_settings.dart';
import '../repositories/notification_repository.dart';

class GetNotificationSettings {
  const GetNotificationSettings(this._repository);

  final NotificationRepository _repository;

  Future<NotificationSettings> call() => _repository.getSettings();
}
