import 'package:equatable/equatable.dart';

import '../../../../core/constants/api_constants.dart';
import 'pokemon_summary.dart';

class PokemonStat extends Equatable {
  const PokemonStat({
    required this.name,
    required this.baseStat,
    required this.effort,
  });

  final String name;
  final int baseStat;
  final int effort;

  @override
  List<Object?> get props => [name, baseStat, effort];
}

class PokemonAbilityRef extends Equatable {
  const PokemonAbilityRef({
    required this.id,
    required this.name,
    required this.isHidden,
    required this.slot,
  });

  final int id;
  final String name;
  final bool isHidden;
  final int slot;

  @override
  List<Object?> get props => [id, name, isHidden, slot];
}

class PokemonMoveRef extends Equatable {
  const PokemonMoveRef({
    required this.id,
    required this.name,
    required this.learnMethod,
    required this.levelLearnedAt,
  });

  final int id;
  final String name;
  final String learnMethod;
  final int levelLearnedAt;

  @override
  List<Object?> get props => [id, name, learnMethod, levelLearnedAt];
}

class PokemonDetail extends Equatable {
  const PokemonDetail({
    required this.id,
    required this.name,
    required this.heightDecimeters,
    required this.weightHectograms,
    required this.baseExperience,
    required this.types,
    required this.stats,
    required this.abilities,
    required this.moves,
    required this.speciesId,
    required this.speciesName,
    required this.spriteUrl,
    required this.shinySpriteUrl,
    required this.fallbackSpriteUrl,
  });

  final int id;
  final String name;
  final int heightDecimeters;
  final int weightHectograms;
  final int baseExperience;
  final List<String> types;
  final List<PokemonStat> stats;
  final List<PokemonAbilityRef> abilities;
  final List<PokemonMoveRef> moves;
  final int speciesId;
  final String speciesName;
  final String spriteUrl;
  final String shinySpriteUrl;
  final String fallbackSpriteUrl;

  int get baseStatTotal =>
      stats.fold<int>(0, (sum, stat) => sum + stat.baseStat);

  PokemonSummary toSummary() => PokemonSummary(
        id: id,
        name: name,
        imageUrl: spriteUrl.isNotEmpty
            ? spriteUrl
            : ApiConstants.officialArtworkUrl(id),
        fallbackImageUrl: fallbackSpriteUrl.isNotEmpty
            ? fallbackSpriteUrl
            : ApiConstants.fallbackSpriteUrl(id),
        types: types,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        heightDecimeters,
        weightHectograms,
        baseExperience,
        types,
        stats,
        abilities,
        moves,
        speciesId,
        speciesName,
        spriteUrl,
        shinySpriteUrl,
        fallbackSpriteUrl,
      ];
}
