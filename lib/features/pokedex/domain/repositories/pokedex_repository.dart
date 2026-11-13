import '../entities/ability_detail.dart';
import '../entities/evolution_node.dart';
import '../entities/move_detail.dart';
import '../entities/pokemon_detail.dart';
import '../entities/pokemon_list_page_result.dart';
import '../entities/pokemon_species.dart';
import '../entities/type_detail.dart';

abstract class PokedexRepository {
  Future<PokemonListPageResult> getPokemonList({
    required int limit,
    required int offset,
  });

  Future<PokemonDetail> getPokemonDetail(Object idOrName);

  Future<PokemonSpeciesInfo> getPokemonSpecies(Object idOrName);

  Future<EvolutionNode> getEvolutionChain(int chainId);

  Future<TypeDetail> getTypeDetail(Object typeNameOrId);

  Future<AbilityDetail> getAbilityDetail(Object abilityNameOrId);

  Future<MoveDetail> getMoveDetail(Object moveNameOrId);
}
