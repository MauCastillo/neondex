import 'package:flutter_test/flutter_test.dart';
import 'package:neondex/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:neondex/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:neondex/features/favorites/domain/usecases/get_favorites.dart';
import 'package:neondex/features/favorites/domain/usecases/toggle_favorite.dart';
import 'package:neondex/features/pokedex/domain/entities/pokemon_summary.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('FavoritesRepositoryImpl persists add/remove across SharedPreferences', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repo = FavoritesRepositoryImpl(FavoritesLocalDataSourceImpl(prefs));
    final getFavorites = GetFavorites(repo);
    final toggleFavorite = ToggleFavorite(repo);

    const pikachu = PokemonSummary(id: 25, name: 'pikachu', types: ['electric']);
    const gengar = PokemonSummary(id: 94, name: 'gengar', types: ['ghost', 'poison']);

    expect(await getFavorites(), isEmpty);

    await toggleFavorite(pikachu);
    await toggleFavorite(gengar);
    expect(await repo.isFavorite(25), isTrue);
    expect(await repo.isFavorite(94), isTrue);

    // Re-create repository from same SharedPreferences instance to verify persistence.
    final reloadedRepo = FavoritesRepositoryImpl(FavoritesLocalDataSourceImpl(prefs));
    final persisted = await reloadedRepo.getFavorites();
    expect(persisted.map((p) => p.id), [94, 25]);

    await toggleFavorite(pikachu);
    expect(await reloadedRepo.isFavorite(25), isFalse);
    expect((await reloadedRepo.getFavorites()).map((p) => p.id), [94]);
  });
}
