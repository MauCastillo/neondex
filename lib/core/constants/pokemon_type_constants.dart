import 'package:material_ui/material_ui.dart';

class PokemonTypeMeta {
  const PokemonTypeMeta({
    required this.name,
    required this.color,
    required this.icon,
    required this.code,
  });

  final String name;
  final Color color;
  final IconData icon;
  final String code;
}

class PokemonTypeConstants {
  const PokemonTypeConstants._();

  static const List<String> allTypes = [
    'normal',
    'fire',
    'water',
    'electric',
    'grass',
    'ice',
    'fighting',
    'poison',
    'ground',
    'flying',
    'psychic',
    'bug',
    'rock',
    'ghost',
    'dragon',
    'dark',
    'steel',
    'fairy',
  ];

  static const Map<String, PokemonTypeMeta> metadata = {
    'normal': PokemonTypeMeta(
      name: 'normal',
      color: Color(0xFFB6C2D9),
      icon: Icons.radio_button_checked,
      code: 'NRM',
    ),
    'fire': PokemonTypeMeta(
      name: 'fire',
      color: Color(0xFFFF4D2E),
      icon: Icons.local_fire_department,
      code: 'FIR',
    ),
    'water': PokemonTypeMeta(
      name: 'water',
      color: Color(0xFF00D2FF),
      icon: Icons.water_drop,
      code: 'WTR',
    ),
    'electric': PokemonTypeMeta(
      name: 'electric',
      color: Color(0xFFFCE300),
      icon: Icons.bolt,
      code: 'ELC',
    ),
    'grass': PokemonTypeMeta(
      name: 'grass',
      color: Color(0xFF39FF14),
      icon: Icons.eco,
      code: 'GRS',
    ),
    'ice': PokemonTypeMeta(
      name: 'ice',
      color: Color(0xFF66F7FF),
      icon: Icons.ac_unit,
      code: 'ICE',
    ),
    'fighting': PokemonTypeMeta(
      name: 'fighting',
      color: Color(0xFFFF2A5F),
      icon: Icons.sports_mma,
      code: 'FGT',
    ),
    'poison': PokemonTypeMeta(
      name: 'poison',
      color: Color(0xFFC04CFD),
      icon: Icons.science,
      code: 'PSN',
    ),
    'ground': PokemonTypeMeta(
      name: 'ground',
      color: Color(0xFFE8A838),
      icon: Icons.terrain,
      code: 'GRD',
    ),
    'flying': PokemonTypeMeta(
      name: 'flying',
      color: Color(0xFF7FA8FF),
      icon: Icons.air,
      code: 'FLY',
    ),
    'psychic': PokemonTypeMeta(
      name: 'psychic',
      color: Color(0xFFFF007F),
      icon: Icons.psychology,
      code: 'PSY',
    ),
    'bug': PokemonTypeMeta(
      name: 'bug',
      color: Color(0xFFA8F000),
      icon: Icons.bug_report,
      code: 'BUG',
    ),
    'rock': PokemonTypeMeta(
      name: 'rock',
      color: Color(0xFFD1B464),
      icon: Icons.hexagon,
      code: 'RCK',
    ),
    'ghost': PokemonTypeMeta(
      name: 'ghost',
      color: Color(0xFF8C52FF),
      icon: Icons.visibility,
      code: 'GHS',
    ),
    'dragon': PokemonTypeMeta(
      name: 'dragon',
      color: Color(0xFF5E6BFF),
      icon: Icons.auto_awesome,
      code: 'DRG',
    ),
    'dark': PokemonTypeMeta(
      name: 'dark',
      color: Color(0xFF9C7B99),
      icon: Icons.dark_mode,
      code: 'DRK',
    ),
    'steel': PokemonTypeMeta(
      name: 'steel',
      color: Color(0xFF8AB4CC),
      icon: Icons.shield,
      code: 'STL',
    ),
    'fairy': PokemonTypeMeta(
      name: 'fairy',
      color: Color(0xFFFF6EC7),
      icon: Icons.star_half,
      code: 'FRY',
    ),
  };

  static PokemonTypeMeta of(String typeName) {
    final normalized = typeName.toLowerCase().trim();
    return metadata[normalized] ??
        PokemonTypeMeta(
          name: normalized,
          color: const Color(0xFF00F0FF),
          icon: Icons.category,
          code: normalized.length >= 3
              ? normalized.substring(0, 3).toUpperCase()
              : normalized.toUpperCase(),
        );
  }
}
