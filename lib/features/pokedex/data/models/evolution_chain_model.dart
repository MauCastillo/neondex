import '../../../../core/utils/pokeapi_url_parser.dart';
import '../../../../core/utils/pokemon_formatters.dart';
import '../../domain/entities/evolution_node.dart';

class EvolutionChainModel {
  const EvolutionChainModel._();

  static EvolutionNode fromJson(Map<String, dynamic> json) {
    final chain = json['chain'] as Map<String, dynamic>;
    return _parseChainLink(chain);
  }

  static EvolutionNode _parseChainLink(Map<String, dynamic> link) {
    final species = link['species'] as Map<String, dynamic>;
    final speciesName = species['name'] as String? ?? 'unknown';
    final speciesUrl = species['url'] as String?;
    final speciesId = PokeApiUrlParser.extractIdFromUrl(speciesUrl) ?? 0;

    final detailsList = link['evolution_details'] as List<dynamic>? ?? const [];
    final triggerLabel = _formatTrigger(detailsList);

    final children = (link['evolves_to'] as List<dynamic>? ?? const [])
        .map((child) => _parseChainLink(child as Map<String, dynamic>))
        .toList();

    return EvolutionNode(
      speciesId: speciesId,
      speciesName: speciesName,
      triggerLabel: triggerLabel,
      evolvesTo: children,
    );
  }

  static String? _formatTrigger(List<dynamic> detailsList) {
    if (detailsList.isEmpty) return null;
    final detail = detailsList.first as Map<String, dynamic>;

    final minLevel = detail['min_level'] as int?;
    if (minLevel != null) {
      final timeOfDay = detail['time_of_day'] as String? ?? '';
      return timeOfDay.isNotEmpty
          ? 'LVL $minLevel ($timeOfDay)'
          : 'LVL $minLevel';
    }

    final item = detail['item'] as Map<String, dynamic>?;
    if (item != null) {
      return PokemonFormatters.formatDisplayName(
        item['name'] as String? ?? 'Item',
      );
    }

    final heldItem = detail['held_item'] as Map<String, dynamic>?;
    final triggerObj = detail['trigger'] as Map<String, dynamic>?;
    final triggerName = triggerObj?['name'] as String? ?? '';

    if (triggerName == 'trade') {
      if (heldItem != null) {
        return 'Trade (${PokemonFormatters.formatDisplayName(heldItem['name'] as String? ?? '')})';
      }
      return 'Trade';
    }

    final minHappiness = detail['min_happiness'] as int?;
    if (minHappiness != null) {
      final timeOfDay = detail['time_of_day'] as String? ?? '';
      return timeOfDay.isNotEmpty
          ? 'Amistad ($timeOfDay)'
          : 'Amistad';
    }

    final minAffection = detail['min_affection'] as int?;
    if (minAffection != null) {
      return 'Afecto';
    }

    final knownMove = detail['known_move'] as Map<String, dynamic>?;
    if (knownMove != null) {
      return 'Move: ${PokemonFormatters.formatDisplayName(knownMove['name'] as String? ?? '')}';
    }

    if (detail['needs_overworld_rain'] == true) {
      return 'Lluvia + LVL';
    }

    if (triggerName.isNotEmpty) {
      return PokemonFormatters.formatDisplayName(triggerName);
    }
    return null;
  }
}
