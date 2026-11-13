import '../../../pokedex/domain/entities/pokemon_summary.dart';

abstract class FavoritesRepository {
  Future<List<PokemonSummary>> getFavorites();
  Future<List<PokemonSummary>> toggleFavorite(PokemonSummary pokemon);
  Future<bool> isFavorite(int pokemonId);
}
