import '../../../../core/utils/pokemon_formatters.dart';
import '../../domain/entities/ability_detail.dart';

class AbilityDetailModel extends AbilityDetail {
  const AbilityDetailModel({
    required super.id,
    required super.name,
    required super.shortEffect,
    required super.effect,
    required super.flavorText,
  });

  factory AbilityDetailModel.fromJson(Map<String, dynamic> json) {
    final effectEntries = json['effect_entries'] as List<dynamic>? ?? const [];
    String shortEffect = '';
    String effect = '';

    for (final lang in ['es', 'en']) {
      for (final entry in effectEntries) {
        final map = entry as Map<String, dynamic>;
        final langMap = map['language'] as Map<String, dynamic>?;
        if (langMap?['name'] == lang) {
          shortEffect = PokemonFormatters.sanitizeFlavorText(
            map['short_effect'] as String? ?? '',
          );
          effect = PokemonFormatters.sanitizeFlavorText(
            map['effect'] as String? ?? '',
          );
          break;
        }
      }
      if (shortEffect.isNotEmpty || effect.isNotEmpty) break;
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

    return AbilityDetailModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'unknown',
      shortEffect: shortEffect.isNotEmpty ? shortEffect : flavorText,
      effect: effect.isNotEmpty ? effect : shortEffect,
      flavorText: flavorText,
    );
  }
}
