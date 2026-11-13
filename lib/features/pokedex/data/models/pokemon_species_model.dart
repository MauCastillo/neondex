import '../../../../core/utils/pokeapi_url_parser.dart';
import '../../../../core/utils/pokemon_formatters.dart';
import '../../domain/entities/pokemon_species.dart';

class PokemonSpeciesModel extends PokemonSpeciesInfo {
  const PokemonSpeciesModel({
    required super.id,
    required super.name,
    required super.genus,
    required super.flavorText,
    required super.habitat,
    required super.colorName,
    required super.generationName,
    required super.captureRate,
    required super.baseHappiness,
    required super.growthRate,
    required super.eggGroups,
    required super.isLegendary,
    required super.isMythical,
    required super.evolutionChainId,
    required super.varieties,
  });

  factory PokemonSpeciesModel.fromJson(Map<String, dynamic> json) {
    final genera = json['genera'] as List<dynamic>? ?? const [];
    final genus = _pickLocalizedText(
          genera,
          textKey: 'genus',
          preferredLanguages: const ['es', 'en'],
        ) ??
        'Pokémon';

    final flavorEntries =
        json['flavor_text_entries'] as List<dynamic>? ?? const [];
    final rawFlavor = _pickLocalizedText(
          flavorEntries.reversed.toList(),
          textKey: 'flavor_text',
          preferredLanguages: const ['es', 'en'],
        ) ??
        '';
    final flavorText = PokemonFormatters.sanitizeFlavorText(rawFlavor);

    final habitatMap = json['habitat'] as Map<String, dynamic>?;
    final colorMap = json['color'] as Map<String, dynamic>?;
    final generationMap = json['generation'] as Map<String, dynamic>?;
    final growthRateMap = json['growth_rate'] as Map<String, dynamic>?;
    final evoChainMap = json['evolution_chain'] as Map<String, dynamic>?;

    final eggGroups = (json['egg_groups'] as List<dynamic>? ?? const [])
        .map((e) => (e as Map<String, dynamic>)['name'] as String? ?? '')
        .where((e) => e.isNotEmpty)
        .toList();

    final varieties = (json['varieties'] as List<dynamic>? ?? const []).map((v) {
      final map = v as Map<String, dynamic>;
      final poke = map['pokemon'] as Map<String, dynamic>?;
      final url = poke?['url'] as String?;
      return PokemonVarietyRef(
        pokemonId: PokeApiUrlParser.extractIdFromUrl(url) ?? 0,
        name: poke?['name'] as String? ?? 'unknown',
        isDefault: map['is_default'] as bool? ?? false,
      );
    }).where((v) => v.pokemonId > 0).toList();

    return PokemonSpeciesModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'unknown',
      genus: genus,
      flavorText: flavorText,
      habitat: habitatMap?['name'] as String? ?? 'unknown',
      colorName: colorMap?['name'] as String? ?? 'unknown',
      generationName: generationMap?['name'] as String? ?? 'unknown',
      captureRate: json['capture_rate'] as int? ?? 0,
      baseHappiness: json['base_happiness'] as int? ?? 0,
      growthRate: growthRateMap?['name'] as String? ?? 'unknown',
      eggGroups: eggGroups,
      isLegendary: json['is_legendary'] as bool? ?? false,
      isMythical: json['is_mythical'] as bool? ?? false,
      evolutionChainId:
          PokeApiUrlParser.extractIdFromUrl(evoChainMap?['url'] as String?),
      varieties: varieties,
    );
  }

  static String? _pickLocalizedText(
    List<dynamic> entries, {
    required String textKey,
    required List<String> preferredLanguages,
  }) {
    for (final lang in preferredLanguages) {
      for (final item in entries) {
        final map = item as Map<String, dynamic>;
        final langMap = map['language'] as Map<String, dynamic>?;
        if (langMap?['name'] == lang) {
          final text = map[textKey] as String?;
          if (text != null && text.trim().isNotEmpty) {
            return text;
          }
        }
      }
    }
    return null;
  }
}
