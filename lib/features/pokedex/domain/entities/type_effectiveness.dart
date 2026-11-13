import 'package:equatable/equatable.dart';

class TypeMultiplierEntry extends Equatable {
  const TypeMultiplierEntry({
    required this.typeName,
    required this.multiplier,
  });

  final String typeName;
  final double multiplier;

  String get formattedMultiplier {
    if (multiplier == 4.0) return '4x';
    if (multiplier == 2.0) return '2x';
    if (multiplier == 0.5) return '1/2x';
    if (multiplier == 0.25) return '1/4x';
    if (multiplier == 0.0) return '0x';
    return '${multiplier}x';
  }

  @override
  List<Object?> get props => [typeName, multiplier];
}

class TypeEffectiveness extends Equatable {
  const TypeEffectiveness({
    required this.defensiveWeaknesses,
    required this.defensiveResistances,
    required this.defensiveImmunities,
    required this.offensiveSuperEffective,
    required this.offensiveNotVeryEffective,
    required this.offensiveNoEffect,
  });

  final List<TypeMultiplierEntry> defensiveWeaknesses;
  final List<TypeMultiplierEntry> defensiveResistances;
  final List<TypeMultiplierEntry> defensiveImmunities;
  final List<TypeMultiplierEntry> offensiveSuperEffective;
  final List<TypeMultiplierEntry> offensiveNotVeryEffective;
  final List<TypeMultiplierEntry> offensiveNoEffect;

  @override
  List<Object?> get props => [
        defensiveWeaknesses,
        defensiveResistances,
        defensiveImmunities,
        offensiveSuperEffective,
        offensiveNotVeryEffective,
        offensiveNoEffect,
      ];
}
