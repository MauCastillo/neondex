import 'package:equatable/equatable.dart';

import '../../../../core/constants/api_constants.dart';

class EvolutionNode extends Equatable {
  const EvolutionNode({
    required this.speciesId,
    required this.speciesName,
    this.triggerLabel,
    this.evolvesTo = const [],
  });

  final int speciesId;
  final String speciesName;
  final String? triggerLabel;
  final List<EvolutionNode> evolvesTo;

  String get imageUrl => ApiConstants.officialArtworkUrl(speciesId);
  String get fallbackImageUrl => ApiConstants.fallbackSpriteUrl(speciesId);

  @override
  List<Object?> get props => [speciesId, speciesName, triggerLabel, evolvesTo];
}
