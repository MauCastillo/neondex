import 'package:equatable/equatable.dart';

class PokemonVarietyRef extends Equatable {
  const PokemonVarietyRef({
    required this.pokemonId,
    required this.name,
    required this.isDefault,
  });

  final int pokemonId;
  final String name;
  final bool isDefault;

  @override
  List<Object?> get props => [pokemonId, name, isDefault];
}

class PokemonSpeciesInfo extends Equatable {
  const PokemonSpeciesInfo({
    required this.id,
    required this.name,
    required this.genus,
    required this.flavorText,
    required this.habitat,
    required this.colorName,
    required this.generationName,
    required this.captureRate,
    required this.baseHappiness,
    required this.growthRate,
    required this.eggGroups,
    required this.isLegendary,
    required this.isMythical,
    required this.evolutionChainId,
    required this.varieties,
  });

  final int id;
  final String name;
  final String genus;
  final String flavorText;
  final String habitat;
  final String colorName;
  final String generationName;
  final int captureRate;
  final int baseHappiness;
  final String growthRate;
  final List<String> eggGroups;
  final bool isLegendary;
  final bool isMythical;
  final int? evolutionChainId;
  final List<PokemonVarietyRef> varieties;

  @override
  List<Object?> get props => [
        id,
        name,
        genus,
        flavorText,
        habitat,
        colorName,
        generationName,
        captureRate,
        baseHappiness,
        growthRate,
        eggGroups,
        isLegendary,
        isMythical,
        evolutionChainId,
        varieties,
      ];
}
