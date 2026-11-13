import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../pokedex/domain/entities/pokemon_summary.dart';

abstract class FavoritesLocalDataSource {
  Future<List<PokemonSummary>> loadFavorites();
  Future<void> saveFavorites(List<PokemonSummary> favorites);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  const FavoritesLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<List<PokemonSummary>> loadFavorites() async {
    final raw = _prefs.getString(StorageKeys.favoritesList);
    if (raw == null || raw.trim().isEmpty) {
      return const [];
    }
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => PokemonSummary.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> saveFavorites(List<PokemonSummary> favorites) async {
    final encoded = jsonEncode(favorites.map((e) => e.toJson()).toList());
    await _prefs.setString(StorageKeys.favoritesList, encoded);
  }
}
