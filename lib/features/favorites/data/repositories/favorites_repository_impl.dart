import '../../../pokedex/domain/entities/pokemon_summary.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  const FavoritesRepositoryImpl(this._localDataSource);

  final FavoritesLocalDataSource _localDataSource;

  @override
  Future<List<PokemonSummary>> getFavorites() {
    return _localDataSource.loadFavorites();
  }

  @override
  Future<bool> isFavorite(int pokemonId) async {
    final items = await _localDataSource.loadFavorites();
    return items.any((item) => item.id == pokemonId);
  }

  @override
  Future<List<PokemonSummary>> toggleFavorite(PokemonSummary pokemon) async {
    final current = List<PokemonSummary>.from(
      await _localDataSource.loadFavorites(),
    );
    final existingIndex = current.indexWhere((item) => item.id == pokemon.id);
    if (existingIndex >= 0) {
      current.removeAt(existingIndex);
    } else {
      current.insert(0, pokemon);
    }
    await _localDataSource.saveFavorites(current);
    return List<PokemonSummary>.unmodifiable(current);
  }
}
