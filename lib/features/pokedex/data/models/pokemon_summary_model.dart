import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/pokeapi_url_parser.dart';
import '../../domain/entities/pokemon_summary.dart';

class PokemonSummaryModel extends PokemonSummary {
  const PokemonSummaryModel({
    required super.id,
    required super.name,
    super.imageUrl,
    super.fallbackImageUrl,
    super.types,
  });

  factory PokemonSummaryModel.fromNamedResource(Map<String, dynamic> json) {
    final name = (json['name'] as String? ?? 'unknown').trim();
    final url = json['url'] as String?;
    final id = PokeApiUrlParser.extractIdFromUrl(url) ?? 0;

    return PokemonSummaryModel(
      id: id,
      name: name,
      imageUrl: id > 0 ? ApiConstants.officialArtworkUrl(id) : null,
      fallbackImageUrl: id > 0 ? ApiConstants.fallbackSpriteUrl(id) : null,
    );
  }
}
