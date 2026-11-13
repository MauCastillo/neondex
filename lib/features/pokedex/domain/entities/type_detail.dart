import 'package:equatable/equatable.dart';

import 'pokemon_summary.dart';

class TypeDamageRelations extends Equatable {
  const TypeDamageRelations({
    required this.doubleDamageFrom,
    required this.halfDamageFrom,
    required this.noDamageFrom,
    required this.doubleDamageTo,
    required this.halfDamageTo,
    required this.noDamageTo,
  });

  final List<String> doubleDamageFrom;
  final List<String> halfDamageFrom;
  final List<String> noDamageFrom;
  final List<String> doubleDamageTo;
  final List<String> halfDamageTo;
  final List<String> noDamageTo;

  @override
  List<Object?> get props => [
        doubleDamageFrom,
        halfDamageFrom,
        noDamageFrom,
        doubleDamageTo,
        halfDamageTo,
        noDamageTo,
      ];
}

class TypeDetail extends Equatable {
  const TypeDetail({
    required this.id,
    required this.name,
    required this.damageRelations,
    required this.pokemonList,
  });

  final int id;
  final String name;
  final TypeDamageRelations damageRelations;
  final List<PokemonSummary> pokemonList;

  @override
  List<Object?> get props => [id, name, damageRelations, pokemonList];
}
