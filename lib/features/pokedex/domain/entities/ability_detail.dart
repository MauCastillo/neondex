import 'package:equatable/equatable.dart';

class AbilityDetail extends Equatable {
  const AbilityDetail({
    required this.id,
    required this.name,
    required this.shortEffect,
    required this.effect,
    required this.flavorText,
  });

  final int id;
  final String name;
  final String shortEffect;
  final String effect;
  final String flavorText;

  @override
  List<Object?> get props => [id, name, shortEffect, effect, flavorText];
}
