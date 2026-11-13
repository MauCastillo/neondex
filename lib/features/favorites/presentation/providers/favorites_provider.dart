import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/service_locator.dart';
import '../../../pokedex/domain/entities/pokemon_summary.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/toggle_favorite.dart';

final getFavoritesUseCaseProvider = Provider<GetFavorites>(
  (ref) => sl<GetFavorites>(),
);

final toggleFavoriteUseCaseProvider = Provider<ToggleFavorite>(
  (ref) => sl<ToggleFavorite>(),
);

final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, List<PokemonSummary>>(
  FavoritesNotifier.new,
);

class FavoritesNotifier extends AsyncNotifier<List<PokemonSummary>> {
  @override
  Future<List<PokemonSummary>> build() {
    return ref.read(getFavoritesUseCaseProvider)();
  }

  Future<void> toggle(PokemonSummary pokemon) async {
    final updated = await ref.read(toggleFavoriteUseCaseProvider)(pokemon);
    if (!ref.mounted) return;
    state = AsyncData(updated);
  }
}

final isPokemonFavoriteProvider = Provider.family<bool, int>((ref, pokemonId) {
  final favs = ref.watch(favoritesProvider).asData?.value ?? const [];
  return favs.any((p) => p.id == pokemonId);
});
