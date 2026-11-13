import 'package:equatable/equatable.dart';

class NotificationSettings extends Equatable {
  const NotificationSettings({
    required this.enabled,
    required this.intervalMinutes,
    this.lastRecommendedId,
    this.lastRecommendedName,
    this.lastScheduledIso,
  });

  final bool enabled;
  final int intervalMinutes;
  final int? lastRecommendedId;
  final String? lastRecommendedName;
  final String? lastScheduledIso;

  bool get usesBackgroundWorkManager => intervalMinutes >= 15;

  NotificationSettings copyWith({
    bool? enabled,
    int? intervalMinutes,
    int? lastRecommendedId,
    String? lastRecommendedName,
    String? lastScheduledIso,
  }) {
    return NotificationSettings(
      enabled: enabled ?? this.enabled,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      lastRecommendedId: lastRecommendedId ?? this.lastRecommendedId,
      lastRecommendedName: lastRecommendedName ?? this.lastRecommendedName,
      lastScheduledIso: lastScheduledIso ?? this.lastScheduledIso,
    );
  }

  @override
  List<Object?> get props => [
        enabled,
        intervalMinutes,
        lastRecommendedId,
        lastRecommendedName,
        lastScheduledIso,
      ];
}
