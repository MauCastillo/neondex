import '../../../pokedex/domain/entities/pokemon_summary.dart';
import '../repositories/favorites_repository.dart';

class GetFavorites {
  const GetFavorites(this._repository);

  final FavoritesRepository _repository;

  Future<List<PokemonSummary>> call() => _repository.getFavorites();
}
