import 'package:equatable/equatable.dart';

class MoveDetail extends Equatable {
  const MoveDetail({
    required this.id,
    required this.name,
    required this.typeName,
    required this.damageClass,
    required this.power,
    required this.accuracy,
    required this.pp,
    required this.priority,
    required this.effectChance,
    required this.shortEffect,
    required this.flavorText,
  });

  final int id;
  final String name;
  final String typeName;
  final String damageClass;
  final int? power;
  final int? accuracy;
  final int? pp;
  final int priority;
  final int? effectChance;
  final String shortEffect;
  final String flavorText;

  @override
  List<Object?> get props => [
        id,
        name,
        typeName,
        damageClass,
        power,
        accuracy,
        pp,
        priority,
        effectChance,
        shortEffect,
        flavorText,
      ];
}
