import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/service_locator.dart';
import '../../domain/usecases/calculate_type_effectiveness.dart';
import '../../domain/usecases/get_ability_detail.dart';
import '../../domain/usecases/get_evolution_chain.dart';
import '../../domain/usecases/get_move_detail.dart';
import '../../domain/usecases/get_pokemon_detail.dart';
import '../../domain/usecases/get_pokemon_list.dart';
import '../../domain/usecases/get_pokemon_species.dart';
import '../../domain/usecases/get_type_detail.dart';

final getPokemonListUseCaseProvider = Provider<GetPokemonList>(
  (ref) => sl<GetPokemonList>(),
);

final getPokemonDetailUseCaseProvider = Provider<GetPokemonDetail>(
  (ref) => sl<GetPokemonDetail>(),
);

final getPokemonSpeciesUseCaseProvider = Provider<GetPokemonSpecies>(
  (ref) => sl<GetPokemonSpecies>(),
);

final getEvolutionChainUseCaseProvider = Provider<GetEvolutionChain>(
  (ref) => sl<GetEvolutionChain>(),
);

final getTypeDetailUseCaseProvider = Provider<GetTypeDetail>(
  (ref) => sl<GetTypeDetail>(),
);

final getAbilityDetailUseCaseProvider = Provider<GetAbilityDetail>(
  (ref) => sl<GetAbilityDetail>(),
);

final getMoveDetailUseCaseProvider = Provider<GetMoveDetail>(
  (ref) => sl<GetMoveDetail>(),
);

final calculateTypeEffectivenessUseCaseProvider =
    Provider<CalculateTypeEffectiveness>(
  (ref) => sl<CalculateTypeEffectiveness>(),
);
