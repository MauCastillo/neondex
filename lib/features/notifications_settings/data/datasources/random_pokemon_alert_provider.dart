import 'dart:math';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../pokedex/data/models/pokemon_detail_model.dart';
import '../../domain/entities/recommended_pokemon_alert.dart';

class RandomPokemonAlertProvider {
  RandomPokemonAlertProvider({
    ApiClient? apiClient,
    Random? random,
  })  : _apiClient = apiClient ?? ApiClient(),
        _random = random ?? Random();

  final ApiClient _apiClient;
  final Random _random;

  static const List<RecommendedPokemonAlert> fallbackRoster = [
    RecommendedPokemonAlert(
      id: 25,
      name: 'pikachu',
      types: ['electric'],
      hp: 35,
      attack: 55,
      speed: 90,
    ),
    RecommendedPokemonAlert(
      id: 6,
      name: 'charizard',
      types: ['fire', 'flying'],
      hp: 78,
      attack: 84,
      speed: 100,
    ),
    RecommendedPokemonAlert(
      id: 94,
      name: 'gengar',
      types: ['ghost', 'poison'],
      hp: 60,
      attack: 65,
      speed: 110,
    ),
    RecommendedPokemonAlert(
      id: 150,
      name: 'mewtwo',
      types: ['psychic'],
      hp: 106,
      attack: 110,
      speed: 130,
    ),
    RecommendedPokemonAlert(
      id: 197,
      name: 'umbreon',
      types: ['dark'],
      hp: 95,
      attack: 65,
      speed: 65,
    ),
    RecommendedPokemonAlert(
      id: 282,
      name: 'gardevoir',
      types: ['psychic', 'fairy'],
      hp: 68,
      attack: 65,
      speed: 80,
    ),
    RecommendedPokemonAlert(
      id: 384,
      name: 'rayquaza',
      types: ['dragon', 'flying'],
      hp: 105,
      attack: 150,
      speed: 95,
    ),
    RecommendedPokemonAlert(
      id: 448,
      name: 'lucario',
      types: ['fighting', 'steel'],
      hp: 70,
      attack: 110,
      speed: 90,
    ),
    RecommendedPokemonAlert(
      id: 658,
      name: 'greninja',
      types: ['water', 'dark'],
      hp: 72,
      attack: 95,
      speed: 122,
    ),
    RecommendedPokemonAlert(
      id: 937,
      name: 'ceruledge',
      types: ['fire', 'ghost'],
      hp: 75,
      attack: 125,
      speed: 85,
    ),
    RecommendedPokemonAlert(
      id: 1008,
      name: 'miraidon',
      types: ['electric', 'dragon'],
      hp: 100,
      attack: 85,
      speed: 135,
    ),
  ];

  Future<RecommendedPokemonAlert> generateRandomAlert() async {
    final randomId = _random.nextInt(ApiConstants.maxStandardPokemonId) + 1;
    try {
      final json = await _apiClient
          .getJson(ApiConstants.pokemonDetailEndpoint(randomId), useCache: false)
          .timeout(const Duration(seconds: 6));
      final detail = PokemonDetailModel.fromJson(json);

      int statValue(String key) {
        for (final stat in detail.stats) {
          if (stat.name == key) return stat.baseStat;
        }
        return 0;
      }

      return RecommendedPokemonAlert(
        id: detail.id,
        name: detail.name,
        types: detail.types,
        hp: statValue('hp'),
        attack: statValue('attack'),
        speed: statValue('speed'),
      );
    } catch (_) {
      return fallbackRoster[_random.nextInt(fallbackRoster.length)];
    }
  }
}
