import '../../../../core/utils/pokemon_formatters.dart';
import '../../domain/entities/move_detail.dart';

class MoveDetailModel extends MoveDetail {
  const MoveDetailModel({
    required super.id,
    required super.name,
    required super.typeName,
    required super.damageClass,
    required super.power,
    required super.accuracy,
    required super.pp,
    required super.priority,
    required super.effectChance,
    required super.shortEffect,
    required super.flavorText,
  });

  factory MoveDetailModel.fromJson(Map<String, dynamic> json) {
    final typeMap = json['type'] as Map<String, dynamic>?;
    final damageClassMap = json['damage_class'] as Map<String, dynamic>?;
    final effectChance = json['effect_chance'] as int?;

    final effectEntries = json['effect_entries'] as List<dynamic>? ?? const [];
    String shortEffect = '';
    for (final lang in ['es', 'en']) {
      for (final entry in effectEntries) {
        final map = entry as Map<String, dynamic>;
        final langMap = map['language'] as Map<String, dynamic>?;
        if (langMap?['name'] == lang) {
          var raw = map['short_effect'] as String? ?? '';
          if (effectChance != null) {
            raw = raw.replaceAll(r'$effect_chance', effectChance.toString());
          }
          shortEffect = PokemonFormatters.sanitizeFlavorText(raw);
          break;
        }
      }
      if (shortEffect.isNotEmpty) break;
    }

    final flavorEntries =
        json['flavor_text_entries'] as List<dynamic>? ?? const [];
    String flavorText = '';
    for (final lang in ['es', 'en']) {
      for (final entry in flavorEntries.reversed) {
        final map = entry as Map<String, dynamic>;
        final langMap = map['language'] as Map<String, dynamic>?;
        if (langMap?['name'] == lang) {
          flavorText = PokemonFormatters.sanitizeFlavorText(
            map['flavor_text'] as String? ?? '',
          );
          break;
        }
      }
      if (flavorText.isNotEmpty) break;
    }

    return MoveDetailModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'unknown',
      typeName: (typeMap?['name'] as String? ?? 'normal').toLowerCase(),
      damageClass: (damageClassMap?['name'] as String? ?? 'status').toLowerCase(),
      power: json['power'] as int?,
      accuracy: json['accuracy'] as int?,
      pp: json['pp'] as int?,
      priority: json['priority'] as int? ?? 0,
      effectChance: effectChance,
      shortEffect: shortEffect.isNotEmpty ? shortEffect : flavorText,
      flavorText: flavorText,
    );
  }
}
