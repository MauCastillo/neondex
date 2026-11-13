import '../../domain/entities/type_detail.dart';
import 'pokemon_summary_model.dart';

class TypeDetailModel extends TypeDetail {
  const TypeDetailModel({
    required super.id,
    required super.name,
    required super.damageRelations,
    required super.pokemonList,
  });

  factory TypeDetailModel.fromJson(Map<String, dynamic> json) {
    final rel = json['damage_relations'] as Map<String, dynamic>? ?? const {};

    List<String> extractNames(String key) {
      return (rel[key] as List<dynamic>? ?? const [])
          .map((item) => ((item as Map<String, dynamic>)['name'] as String? ?? '').toLowerCase())
          .where((name) => name.isNotEmpty)
          .toList();
    }

    final pokemonEntries = (json['pokemon'] as List<dynamic>? ?? const [])
        .map((entry) {
          final map = entry as Map<String, dynamic>;
          final pokeMap = map['pokemon'] as Map<String, dynamic>?;
          if (pokeMap == null) return null;
          return PokemonSummaryModel.fromNamedResource(pokeMap);
        })
        .whereType<PokemonSummaryModel>()
        .where((p) => p.id > 0)
        .toList();

    return TypeDetailModel(
      id: json['id'] as int? ?? 0,
      name: (json['name'] as String? ?? '').toLowerCase(),
      damageRelations: TypeDamageRelations(
        doubleDamageFrom: extractNames('double_damage_from'),
        halfDamageFrom: extractNames('half_damage_from'),
        noDamageFrom: extractNames('no_damage_from'),
        doubleDamageTo: extractNames('double_damage_to'),
        halfDamageTo: extractNames('half_damage_to'),
        noDamageTo: extractNames('no_damage_to'),
      ),
      pokemonList: pokemonEntries,
    );
  }
}
