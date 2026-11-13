import '../../../../core/constants/pokemon_type_constants.dart';
import '../entities/type_detail.dart';
import '../entities/type_effectiveness.dart';

class CalculateTypeEffectiveness {
  const CalculateTypeEffectiveness();

  TypeEffectiveness call(List<TypeDetail> pokemonTypes) {
    final defensiveMap = <String, double>{
      for (final type in PokemonTypeConstants.allTypes) type: 1.0,
    };

    for (final typeDetail in pokemonTypes) {
      final rel = typeDetail.damageRelations;
      for (final atk in rel.doubleDamageFrom) {
        if (defensiveMap.containsKey(atk)) {
          defensiveMap[atk] = defensiveMap[atk]! * 2.0;
        }
      }
      for (final atk in rel.halfDamageFrom) {
        if (defensiveMap.containsKey(atk)) {
          defensiveMap[atk] = defensiveMap[atk]! * 0.5;
        }
      }
      for (final atk in rel.noDamageFrom) {
        if (defensiveMap.containsKey(atk)) {
          defensiveMap[atk] = 0.0;
        }
      }
    }

    final weaknesses = <TypeMultiplierEntry>[];
    final resistances = <TypeMultiplierEntry>[];
    final immunities = <TypeMultiplierEntry>[];

    defensiveMap.forEach((typeName, mult) {
      if (mult > 1.0) {
        weaknesses.add(TypeMultiplierEntry(typeName: typeName, multiplier: mult));
      } else if (mult == 0.0) {
        immunities.add(TypeMultiplierEntry(typeName: typeName, multiplier: 0.0));
      } else if (mult < 1.0) {
        resistances.add(TypeMultiplierEntry(typeName: typeName, multiplier: mult));
      }
    });

    weaknesses.sort((a, b) => b.multiplier.compareTo(a.multiplier));
    resistances.sort((a, b) => a.multiplier.compareTo(b.multiplier));

    final offensiveMap = <String, double>{};
    for (final defender in PokemonTypeConstants.allTypes) {
      double best = 0.0;
      if (pokemonTypes.isEmpty) {
        best = 1.0;
      } else {
        for (final typeDetail in pokemonTypes) {
          final rel = typeDetail.damageRelations;
          final double value;
          if (rel.doubleDamageTo.contains(defender)) {
            value = 2.0;
          } else if (rel.noDamageTo.contains(defender)) {
            value = 0.0;
          } else if (rel.halfDamageTo.contains(defender)) {
            value = 0.5;
          } else {
            value = 1.0;
          }
          if (value > best) {
            best = value;
          }
        }
      }
      offensiveMap[defender] = best;
    }

    final superEffective = <TypeMultiplierEntry>[];
    final notVeryEffective = <TypeMultiplierEntry>[];
    final noEffect = <TypeMultiplierEntry>[];

    offensiveMap.forEach((typeName, mult) {
      if (mult > 1.0) {
        superEffective.add(TypeMultiplierEntry(typeName: typeName, multiplier: mult));
      } else if (mult == 0.0) {
        noEffect.add(TypeMultiplierEntry(typeName: typeName, multiplier: 0.0));
      } else if (mult < 1.0) {
        notVeryEffective.add(TypeMultiplierEntry(typeName: typeName, multiplier: mult));
      }
    });

    return TypeEffectiveness(
      defensiveWeaknesses: weaknesses,
      defensiveResistances: resistances,
      defensiveImmunities: immunities,
      offensiveSuperEffective: superEffective,
      offensiveNotVeryEffective: notVeryEffective,
      offensiveNoEffect: noEffect,
    );
  }
}
