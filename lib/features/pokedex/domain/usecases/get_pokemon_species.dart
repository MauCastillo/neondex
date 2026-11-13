import '../entities/pokemon_species.dart';
import '../repositories/pokedex_repository.dart';

class GetPokemonSpecies {
  const GetPokemonSpecies(this._repository);

  final PokedexRepository _repository;

  Future<PokemonSpeciesInfo> call(Object idOrName) {
    return _repository.getPokemonSpecies(idOrName);
  }
}
