import '../entities/pokemon_detail.dart';
import '../repositories/pokedex_repository.dart';

class GetPokemonDetail {
  const GetPokemonDetail(this._repository);

  final PokedexRepository _repository;

  Future<PokemonDetail> call(Object idOrName) {
    return _repository.getPokemonDetail(idOrName);
  }
}
