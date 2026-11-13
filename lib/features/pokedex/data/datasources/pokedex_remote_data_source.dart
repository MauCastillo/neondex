import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/evolution_node.dart';
import '../../domain/entities/pokemon_list_page_result.dart';
import '../models/ability_detail_model.dart';
import '../models/evolution_chain_model.dart';
import '../models/move_detail_model.dart';
import '../models/pokemon_detail_model.dart';
import '../models/pokemon_species_model.dart';
import '../models/pokemon_summary_model.dart';
import '../models/type_detail_model.dart';

abstract class PokedexRemoteDataSource {
  Future<PokemonListPageResult> fetchPokemonList({
    required int limit,
    required int offset,
  });

  Future<PokemonDetailModel> fetchPokemonDetail(Object idOrName);

  Future<PokemonSpeciesModel> fetchPokemonSpecies(Object idOrName);

  Future<EvolutionNode> fetchEvolutionChain(int chainId);

  Future<TypeDetailModel> fetchTypeDetail(Object typeNameOrId);

  Future<AbilityDetailModel> fetchAbilityDetail(Object abilityNameOrId);

  Future<MoveDetailModel> fetchMoveDetail(Object moveNameOrId);
}

class PokedexRemoteDataSourceImpl implements PokedexRemoteDataSource {
  const PokedexRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<PokemonListPageResult> fetchPokemonList({
    required int limit,
    required int offset,
  }) async {
    final json = await _apiClient.getJson(
      ApiConstants.pokemonListEndpoint(limit: limit, offset: offset),
    );
    final totalCount = json['count'] as int? ?? 0;
    final hasMore = json['next'] != null;
    final results = (json['results'] as List<dynamic>? ?? const [])
        .map((e) => PokemonSummaryModel.fromNamedResource(e as Map<String, dynamic>))
        .where((p) => p.id > 0)
        .toList();

    return PokemonListPageResult(
      totalCount: totalCount,
      hasMore: hasMore,
      items: results,
    );
  }

  @override
  Future<PokemonDetailModel> fetchPokemonDetail(Object idOrName) async {
    final json = await _apiClient.getJson(
      ApiConstants.pokemonDetailEndpoint(idOrName),
    );
    return PokemonDetailModel.fromJson(json);
  }

  @override
  Future<PokemonSpeciesModel> fetchPokemonSpecies(Object idOrName) async {
    final json = await _apiClient.getJson(
      ApiConstants.pokemonSpeciesEndpoint(idOrName),
    );
    return PokemonSpeciesModel.fromJson(json);
  }

  @override
  Future<EvolutionNode> fetchEvolutionChain(int chainId) async {
    final json = await _apiClient.getJson(
      ApiConstants.evolutionChainEndpoint(chainId),
    );
    return EvolutionChainModel.fromJson(json);
  }

  @override
  Future<TypeDetailModel> fetchTypeDetail(Object typeNameOrId) async {
    final json = await _apiClient.getJson(
      ApiConstants.typeEndpoint(typeNameOrId),
    );
    return TypeDetailModel.fromJson(json);
  }

  @override
  Future<AbilityDetailModel> fetchAbilityDetail(Object abilityNameOrId) async {
    final json = await _apiClient.getJson(
      ApiConstants.abilityEndpoint(abilityNameOrId),
    );
    return AbilityDetailModel.fromJson(json);
  }

  @override
  Future<MoveDetailModel> fetchMoveDetail(Object moveNameOrId) async {
    final json = await _apiClient.getJson(
      ApiConstants.moveEndpoint(moveNameOrId),
    );
    return MoveDetailModel.fromJson(json);
  }
}
