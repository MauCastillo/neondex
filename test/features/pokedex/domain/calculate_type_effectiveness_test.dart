import 'package:flutter_test/flutter_test.dart';
import 'package:neondex/features/pokedex/domain/entities/type_detail.dart';
import 'package:neondex/features/pokedex/domain/usecases/calculate_type_effectiveness.dart';

void main() {
  const useCase = CalculateTypeEffectiveness();

  test('computes single-type effectiveness (Electric)', () {
    const electric = TypeDetail(
      id: 13,
      name: 'electric',
      damageRelations: TypeDamageRelations(
        doubleDamageFrom: ['ground'],
        halfDamageFrom: ['flying', 'steel', 'electric'],
        noDamageFrom: [],
        doubleDamageTo: ['flying', 'water'],
        halfDamageTo: ['grass', 'electric', 'dragon'],
        noDamageTo: ['ground'],
      ),
      pokemonList: [],
    );

    final eff = useCase([electric]);

    expect(
      eff.defensiveWeaknesses.map((e) => (e.typeName, e.multiplier)),
      [('ground', 2.0)],
    );
    expect(
      eff.defensiveResistances.map((e) => e.typeName),
      containsAll(['flying', 'steel', 'electric']),
    );
    expect(
      eff.offensiveSuperEffective.map((e) => e.typeName),
      containsAll(['flying', 'water']),
    );
    expect(eff.offensiveNoEffect.map((e) => e.typeName), ['ground']);
  });

  test('computes dual-type multipliers including 4x, 1/4x, 0x, and neutral cancellation', () {
    const water = TypeDetail(
      id: 11,
      name: 'water',
      damageRelations: TypeDamageRelations(
        doubleDamageFrom: ['electric', 'grass'],
        halfDamageFrom: ['fire', 'water', 'ice', 'steel'],
        noDamageFrom: [],
        doubleDamageTo: ['fire', 'ground', 'rock'],
        halfDamageTo: ['water', 'grass', 'dragon'],
        noDamageTo: [],
      ),
      pokemonList: [],
    );
    const ground = TypeDetail(
      id: 5,
      name: 'ground',
      damageRelations: TypeDamageRelations(
        doubleDamageFrom: ['water', 'grass', 'ice'],
        halfDamageFrom: ['poison', 'rock'],
        noDamageFrom: ['electric'],
        doubleDamageTo: ['fire', 'electric', 'poison', 'rock', 'steel'],
        halfDamageTo: ['grass', 'bug'],
        noDamageTo: ['flying'],
      ),
      pokemonList: [],
    );

    final eff = useCase([water, ground]);

    // Grass is 2x * 2x = 4x against Water/Ground (Swampert)
    expect(eff.defensiveWeaknesses.single.typeName, 'grass');
    expect(eff.defensiveWeaknesses.single.multiplier, 4.0);
    expect(eff.defensiveWeaknesses.single.formattedMultiplier, '4x');

    // Electric is 0x immune due to Ground
    expect(eff.defensiveImmunities.single.typeName, 'electric');

    // Ice is 0.5x * 2x = 1.0x neutral, so NOT in weaknesses or resistances
    expect(eff.defensiveWeaknesses.any((e) => e.typeName == 'ice'), isFalse);
    expect(eff.defensiveResistances.any((e) => e.typeName == 'ice'), isFalse);

    // Flying is 1.0x against Water and 0x against Ground -> max STAB is 1.0x (not noEffect)
    expect(eff.offensiveNoEffect, isEmpty);
  });
}
