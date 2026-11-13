import '../../../pokedex/domain/entities/pokemon_summary.dart';
import '../repositories/favorites_repository.dart';

class ToggleFavorite {
  const ToggleFavorite(this._repository);

  final FavoritesRepository _repository;

  Future<List<PokemonSummary>> call(PokemonSummary pokemon) =>
      _repository.toggleFavorite(pokemon);
}
