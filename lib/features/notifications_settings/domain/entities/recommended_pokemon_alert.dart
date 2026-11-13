import 'package:equatable/equatable.dart';

import '../../../../core/utils/pokemon_formatters.dart';

class RecommendedPokemonAlert extends Equatable {
  const RecommendedPokemonAlert({
    required this.id,
    required this.name,
    required this.types,
    required this.hp,
    required this.attack,
    required this.speed,
  });

  final int id;
  final String name;
  final List<String> types;
  final int hp;
  final int attack;
  final int speed;

  String get notificationTitle =>
      'NEONDEX RADAR // ${PokemonFormatters.formatDexNumber(id)} ${PokemonFormatters.formatDisplayName(name).toUpperCase()}';

  String get notificationBody {
    final typeText = types.map((t) => t.toUpperCase()).join(' / ');
    return 'Tipo: $typeText · HP $hp · ATK $attack · SPD $speed. Pulsa para abrir análisis completo.';
  }

  String get deepLinkPayload => 'neondex://pokemon/$id';

  @override
  List<Object?> get props => [id, name, types, hp, attack, speed];
}
