class ApiConstants {
  const ApiConstants._();

  static const String pokeApiBaseUrl = 'https://pokeapi.co/api/v2';
  static const String openMeteoBaseUrl = 'https://api.open-meteo.com/v1';

  static const int defaultPageSize = 24;
  static const Duration requestTimeout = Duration(seconds: 15);
  static const int maxStandardPokemonId = 1025;

  static String officialArtworkUrl(int id) =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

  static String shinyOfficialArtworkUrl(int id) =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/$id.png';

  static String fallbackSpriteUrl(int id) =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

  static String shinyFallbackSpriteUrl(int id) =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/$id.png';

  static String pokemonListEndpoint({required int limit, required int offset}) =>
      '$pokeApiBaseUrl/pokemon?limit=$limit&offset=$offset';

  static String pokemonDetailEndpoint(Object idOrName) =>
      '$pokeApiBaseUrl/pokemon/${idOrName.toString().toLowerCase().trim()}';

  static String pokemonSpeciesEndpoint(Object idOrName) =>
      '$pokeApiBaseUrl/pokemon-species/${idOrName.toString().toLowerCase().trim()}';

  static String evolutionChainEndpoint(int id) =>
      '$pokeApiBaseUrl/evolution-chain/$id';

  static String typeEndpoint(Object idOrName) =>
      '$pokeApiBaseUrl/type/${idOrName.toString().toLowerCase().trim()}';

  static String abilityEndpoint(Object idOrName) =>
      '$pokeApiBaseUrl/ability/${idOrName.toString().toLowerCase().trim()}';

  static String moveEndpoint(Object idOrName) =>
      '$pokeApiBaseUrl/move/${idOrName.toString().toLowerCase().trim()}';

  static String openMeteoForecastEndpoint({
    required double latitude,
    required double longitude,
  }) {
    final uri = Uri.parse('$openMeteoBaseUrl/forecast').replace(
      queryParameters: {
        'latitude': latitude.toStringAsFixed(4),
        'longitude': longitude.toStringAsFixed(4),
        'current':
            'temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,rain,weather_code,cloud_cover,wind_speed_10m',
        'hourly': 'temperature_2m,precipitation_probability,weather_code',
        'timezone': 'auto',
        'forecast_days': '1',
      },
    );
    return uri.toString();
  }
}
