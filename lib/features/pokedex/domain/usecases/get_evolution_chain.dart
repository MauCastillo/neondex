import '../entities/evolution_node.dart';
import '../repositories/pokedex_repository.dart';

class GetEvolutionChain {
  const GetEvolutionChain(this._repository);

  final PokedexRepository _repository;

  Future<EvolutionNode> call(int chainId) {
    return _repository.getEvolutionChain(chainId);
  }
}
