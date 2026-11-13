import '../entities/pokemon_list_page_result.dart';
import '../repositories/pokedex_repository.dart';

class GetPokemonList {
  const GetPokemonList(this._repository);

  final PokedexRepository _repository;

  Future<PokemonListPageResult> call({
    required int limit,
    required int offset,
  }) {
    return _repository.getPokemonList(limit: limit, offset: offset);
  }
}
