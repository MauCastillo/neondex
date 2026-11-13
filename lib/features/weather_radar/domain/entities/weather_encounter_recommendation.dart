import 'package:equatable/equatable.dart';

class WeatherEncounterRecommendation extends Equatable {
  const WeatherEncounterRecommendation({
    required this.typeName,
    required this.affinityPercent,
    required this.reason,
  });

  final String typeName;
  final int affinityPercent;
  final String reason;

  @override
  List<Object?> get props => [typeName, affinityPercent, reason];
}

class WeatherEncounterReport extends Equatable {
  const WeatherEncounterReport({
    required this.conditionTitle,
    required this.biomeTag,
    required this.recommendations,
  });

  final String conditionTitle;
  final String biomeTag;
  final List<WeatherEncounterRecommendation> recommendations;

  @override
  List<Object?> get props => [conditionTitle, biomeTag, recommendations];
}
