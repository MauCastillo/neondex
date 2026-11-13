import '../../domain/entities/ability_detail.dart';
import '../../domain/entities/evolution_node.dart';
import '../../domain/entities/move_detail.dart';
import '../../domain/entities/pokemon_detail.dart';
import '../../domain/entities/pokemon_list_page_result.dart';
import '../../domain/entities/pokemon_species.dart';
import '../../domain/entities/type_detail.dart';
import '../../domain/repositories/pokedex_repository.dart';
import '../datasources/pokedex_remote_data_source.dart';

class PokedexRepositoryImpl implements PokedexRepository {
  const PokedexRepositoryImpl(this._remoteDataSource);

  final PokedexRemoteDataSource _remoteDataSource;

  @override
  Future<PokemonListPageResult> getPokemonList({
    required int limit,
    required int offset,
  }) {
    return _remoteDataSource.fetchPokemonList(limit: limit, offset: offset);
  }

  @override
  Future<PokemonDetail> getPokemonDetail(Object idOrName) {
    return _remoteDataSource.fetchPokemonDetail(idOrName);
  }

  @override
  Future<PokemonSpeciesInfo> getPokemonSpecies(Object idOrName) {
    return _remoteDataSource.fetchPokemonSpecies(idOrName);
  }

  @override
  Future<EvolutionNode> getEvolutionChain(int chainId) {
    return _remoteDataSource.fetchEvolutionChain(chainId);
  }

  @override
  Future<TypeDetail> getTypeDetail(Object typeNameOrId) {
    return _remoteDataSource.fetchTypeDetail(typeNameOrId);
  }

  @override
  Future<AbilityDetail> getAbilityDetail(Object abilityNameOrId) {
    return _remoteDataSource.fetchAbilityDetail(abilityNameOrId);
  }

  @override
  Future<MoveDetail> getMoveDetail(Object moveNameOrId) {
    return _remoteDataSource.fetchMoveDetail(moveNameOrId);
  }
}
