class PokemonFormatters {
  const PokemonFormatters._();

  static String formatDexNumber(int id) {
    if (id < 1000) {
      return '#${id.toString().padLeft(3, '0')}';
    }
    return '#$id';
  }

  static String formatDisplayName(String raw) {
    if (raw.trim().isEmpty) return 'Unknown';
    return raw
        .trim()
        .split(RegExp(r'[-_\s]+'))
        .where((part) => part.isNotEmpty)
        .map(
          (part) =>
              part[0].toUpperCase() + (part.length > 1 ? part.substring(1) : ''),
        )
        .join(' ');
  }

  static String formatHeightMeters(int decimeters) {
    return '${(decimeters / 10).toStringAsFixed(1)} m';
  }

  static String formatWeightKg(int hectograms) {
    return '${(hectograms / 10).toStringAsFixed(1)} kg';
  }

  static String sanitizeFlavorText(String text) {
    return text
        .replaceAll('\f', ' ')
        .replaceAll('\n', ' ')
        .replaceAll('\r', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static String formatStatShortLabel(String statName) {
    switch (statName.toLowerCase()) {
      case 'hp':
        return 'HP';
      case 'attack':
        return 'ATK';
      case 'defense':
        return 'DEF';
      case 'special-attack':
        return 'SP.A';
      case 'special-defense':
        return 'SP.D';
      case 'speed':
        return 'SPD';
      default:
        return statName.toUpperCase();
    }
  }
}
