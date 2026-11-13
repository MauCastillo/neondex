import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/ability_detail.dart';
import '../../domain/entities/evolution_node.dart';
import '../../domain/entities/move_detail.dart';
import '../../domain/entities/pokemon_detail.dart';
import '../../domain/entities/pokemon_species.dart';
import '../../domain/entities/type_detail.dart';
import '../../domain/entities/type_effectiveness.dart';
import 'pokedex_usecase_providers.dart';

class PokemonDetailBundle extends Equatable {
  const PokemonDetailBundle({
    required this.detail,
    required this.species,
    required this.evolutionChain,
    required this.typeEffectiveness,
  });

  final PokemonDetail detail;
  final PokemonSpeciesInfo? species;
  final EvolutionNode? evolutionChain;
  final TypeEffectiveness typeEffectiveness;

  @override
  List<Object?> get props => [
        detail,
        species,
        evolutionChain,
        typeEffectiveness,
      ];
}

final pokemonDetailProvider = AsyncNotifierProvider.autoDispose
    .family<PokemonDetailNotifier, PokemonDetailBundle, int>(
  PokemonDetailNotifier.new,
);

class PokemonDetailNotifier extends AsyncNotifier<PokemonDetailBundle> {
  PokemonDetailNotifier(this.pokemonId);

  final int pokemonId;

  @override
  Future<PokemonDetailBundle> build() async {
    final getDetail = ref.read(getPokemonDetailUseCaseProvider);
    final getSpecies = ref.read(getPokemonSpeciesUseCaseProvider);
    final getEvoChain = ref.read(getEvolutionChainUseCaseProvider);
    final getTypeDetail = ref.read(getTypeDetailUseCaseProvider);
    final calcEffectiveness = ref.read(calculateTypeEffectivenessUseCaseProvider);

    final detail = await getDetail(pokemonId);

    final speciesFuture = getSpecies(detail.speciesId).then<PokemonSpeciesInfo?>(
      (value) => value,
      onError: (_, _) => null,
    );

    final typeDetailsFuture = Future.wait<TypeDetail>(
      detail.types.map((t) => getTypeDetail(t)),
    ).catchError((_) => <TypeDetail>[]);

    final results = await Future.wait([speciesFuture, typeDetailsFuture]);
    final species = results[0] as PokemonSpeciesInfo?;
    final typeDetails = results[1] as List<TypeDetail>;

    EvolutionNode? evolutionChain;
    if (species?.evolutionChainId != null) {
      try {
        evolutionChain = await getEvoChain(species!.evolutionChainId!);
      } catch (_) {
        evolutionChain = null;
      }
    }

    final effectiveness = calcEffectiveness(typeDetails);

    return PokemonDetailBundle(
      detail: detail,
      species: species,
      evolutionChain: evolutionChain,
      typeEffectiveness: effectiveness,
    );
  }
}

final abilityDetailProvider = FutureProvider.autoDispose.family<AbilityDetail, String>(
  (ref, abilityName) {
    final useCase = ref.read(getAbilityDetailUseCaseProvider);
    return useCase(abilityName);
  },
);

final moveDetailProvider = FutureProvider.autoDispose.family<MoveDetail, String>(
  (ref, moveName) {
    final useCase = ref.read(getMoveDetailUseCaseProvider);
    return useCase(moveName);
  },
);
