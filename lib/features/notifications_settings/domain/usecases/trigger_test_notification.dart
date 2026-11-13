import '../entities/recommended_pokemon_alert.dart';
import '../repositories/notification_repository.dart';

class TriggerTestNotification {
  const TriggerTestNotification(this._repository);

  final NotificationRepository _repository;

  Future<RecommendedPokemonAlert> call() =>
      _repository.triggerTestNotification();
}
