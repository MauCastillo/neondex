import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/pokeapi_url_parser.dart';
import '../../domain/entities/pokemon_detail.dart';

class PokemonDetailModel extends PokemonDetail {
  const PokemonDetailModel({
    required super.id,
    required super.name,
    required super.heightDecimeters,
    required super.weightHectograms,
    required super.baseExperience,
    required super.types,
    required super.stats,
    required super.abilities,
    required super.moves,
    required super.speciesId,
    required super.speciesName,
    required super.spriteUrl,
    required super.shinySpriteUrl,
    required super.fallbackSpriteUrl,
  });

  factory PokemonDetailModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final name = json['name'] as String? ?? 'unknown';

    final typesList = (json['types'] as List<dynamic>? ?? [])
        .map((entry) {
          final map = entry as Map<String, dynamic>;
          final typeObj = map['type'] as Map<String, dynamic>?;
          return (typeObj?['name'] as String? ?? '').toLowerCase();
        })
        .where((t) => t.isNotEmpty)
        .toList();

    final statsList = (json['stats'] as List<dynamic>? ?? []).map((entry) {
      final map = entry as Map<String, dynamic>;
      final statObj = map['stat'] as Map<String, dynamic>?;
      return PokemonStat(
        name: statObj?['name'] as String? ?? 'stat',
        baseStat: map['base_stat'] as int? ?? 0,
        effort: map['effort'] as int? ?? 0,
      );
    }).toList();

    final abilitiesList = (json['abilities'] as List<dynamic>? ?? []).map((entry) {
      final map = entry as Map<String, dynamic>;
      final abilityObj = map['ability'] as Map<String, dynamic>?;
      final url = abilityObj?['url'] as String?;
      return PokemonAbilityRef(
        id: PokeApiUrlParser.extractIdFromUrl(url) ?? 0,
        name: abilityObj?['name'] as String? ?? 'unknown',
        isHidden: map['is_hidden'] as bool? ?? false,
        slot: map['slot'] as int? ?? 1,
      );
    }).toList();

    final movesList = (json['moves'] as List<dynamic>? ?? []).map((entry) {
      final map = entry as Map<String, dynamic>;
      final moveObj = map['move'] as Map<String, dynamic>?;
      final url = moveObj?['url'] as String?;
      final versionDetails =
          map['version_group_details'] as List<dynamic>? ?? const [];
      String learnMethod = 'level-up';
      int level = 0;
      if (versionDetails.isNotEmpty) {
        final latest = versionDetails.last as Map<String, dynamic>;
        final methodObj = latest['move_learn_method'] as Map<String, dynamic>?;
        learnMethod = methodObj?['name'] as String? ?? 'level-up';
        level = latest['level_learned_at'] as int? ?? 0;
      }
      return PokemonMoveRef(
        id: PokeApiUrlParser.extractIdFromUrl(url) ?? 0,
        name: moveObj?['name'] as String? ?? 'unknown',
        learnMethod: learnMethod,
        levelLearnedAt: level,
      );
    }).toList();

    movesList.sort((a, b) {
      if (a.learnMethod == 'level-up' && b.learnMethod != 'level-up') return -1;
      if (a.learnMethod != 'level-up' && b.learnMethod == 'level-up') return 1;
      return a.levelLearnedAt.compareTo(b.levelLearnedAt);
    });

    final speciesMap = json['species'] as Map<String, dynamic>?;
    final speciesUrl = speciesMap?['url'] as String?;
    final speciesId = PokeApiUrlParser.extractIdFromUrl(speciesUrl) ?? id;
    final speciesName = speciesMap?['name'] as String? ?? name;

    final sprites = json['sprites'] as Map<String, dynamic>? ?? const {};
    final other = sprites['other'] as Map<String, dynamic>? ?? const {};
    final artwork =
        other['official-artwork'] as Map<String, dynamic>? ?? const {};
    final home = other['home'] as Map<String, dynamic>? ?? const {};

    final spriteUrl = (artwork['front_default'] as String?) ??
        (home['front_default'] as String?) ??
        (sprites['front_default'] as String?) ??
        ApiConstants.officialArtworkUrl(id);

    final shinyUrl = (artwork['front_shiny'] as String?) ??
        (home['front_shiny'] as String?) ??
        (sprites['front_shiny'] as String?) ??
        ApiConstants.shinyOfficialArtworkUrl(id);

    final fallbackUrl = (sprites['front_default'] as String?) ??
        ApiConstants.fallbackSpriteUrl(id);

    return PokemonDetailModel(
      id: id,
      name: name,
      heightDecimeters: json['height'] as int? ?? 0,
      weightHectograms: json['weight'] as int? ?? 0,
      baseExperience: json['base_experience'] as int? ?? 0,
      types: typesList,
      stats: statsList,
      abilities: abilitiesList,
      moves: movesList,
      speciesId: speciesId,
      speciesName: speciesName,
      spriteUrl: spriteUrl,
      shinySpriteUrl: shinyUrl,
      fallbackSpriteUrl: fallbackUrl,
    );
  }
}
