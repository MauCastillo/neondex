import 'package:neondex/features/notifications_settings/domain/entities/android_permission_item.dart';
import 'package:neondex/features/notifications_settings/domain/entities/notification_settings.dart';
import 'package:neondex/features/notifications_settings/domain/entities/recommended_pokemon_alert.dart';
import 'package:neondex/features/pokedex/domain/entities/ability_detail.dart';
import 'package:neondex/features/pokedex/domain/entities/evolution_node.dart';
import 'package:neondex/features/pokedex/domain/entities/move_detail.dart';
import 'package:neondex/features/pokedex/domain/entities/pokemon_detail.dart';
import 'package:neondex/features/pokedex/domain/entities/pokemon_list_page_result.dart';
import 'package:neondex/features/pokedex/domain/entities/pokemon_species.dart';
import 'package:neondex/features/pokedex/domain/entities/pokemon_summary.dart';
import 'package:neondex/features/pokedex/domain/entities/type_detail.dart';
import 'package:neondex/features/weather_radar/domain/entities/geo_location.dart';
import 'package:neondex/features/weather_radar/domain/entities/weather_forecast.dart';

class FakeTestFixtures {
  const FakeTestFixtures._();

  static const PokemonSummary pikachuSummary = PokemonSummary(
    id: 25,
    name: 'pikachu',
    types: ['electric'],
  );

  static const PokemonSummary raichuSummary = PokemonSummary(
    id: 26,
    name: 'raichu',
    types: ['electric'],
  );

  static const PokemonListPageResult firstPokedexPage = PokemonListPageResult(
    totalCount: 1351,
    hasMore: true,
    items: [
      PokemonSummary(id: 1, name: 'bulbasaur'),
      PokemonSummary(id: 4, name: 'charmander'),
      PokemonSummary(id: 7, name: 'squirtle'),
      PokemonSummary(id: 25, name: 'pikachu'),
    ],
  );

  static const PokemonListPageResult secondPokedexPage = PokemonListPageResult(
    totalCount: 1351,
    hasMore: false,
    items: [
      PokemonSummary(id: 26, name: 'raichu'),
      PokemonSummary(id: 94, name: 'gengar'),
    ],
  );

  static const PokemonDetail pikachuDetail = PokemonDetail(
    id: 25,
    name: 'pikachu',
    heightDecimeters: 4,
    weightHectograms: 60,
    baseExperience: 112,
    types: ['electric'],
    stats: [
      PokemonStat(name: 'hp', baseStat: 35, effort: 0),
      PokemonStat(name: 'attack', baseStat: 55, effort: 0),
      PokemonStat(name: 'defense', baseStat: 40, effort: 0),
      PokemonStat(name: 'special-attack', baseStat: 50, effort: 0),
      PokemonStat(name: 'special-defense', baseStat: 50, effort: 0),
      PokemonStat(name: 'speed', baseStat: 90, effort: 2),
    ],
    abilities: [
      PokemonAbilityRef(id: 9, name: 'static', isHidden: false, slot: 1),
      PokemonAbilityRef(id: 31, name: 'lightning-rod', isHidden: true, slot: 3),
    ],
    moves: [
      PokemonMoveRef(
        id: 85,
        name: 'thunderbolt',
        learnMethod: 'level-up',
        levelLearnedAt: 26,
      ),
      PokemonMoveRef(
        id: 98,
        name: 'quick-attack',
        learnMethod: 'level-up',
        levelLearnedAt: 10,
      ),
    ],
    speciesId: 25,
    speciesName: 'pikachu',
    spriteUrl: '',
    shinySpriteUrl: '',
    fallbackSpriteUrl: '',
  );

  static const PokemonSpeciesInfo pikachuSpecies = PokemonSpeciesInfo(
    id: 25,
    name: 'pikachu',
    genus: 'Pokémon Ratón',
    flavorText: 'Almacena electricidad en las bolsas de sus mejillas.',
    habitat: 'forest',
    colorName: 'yellow',
    generationName: 'generation-i',
    captureRate: 190,
    baseHappiness: 70,
    growthRate: 'medium',
    eggGroups: ['ground', 'fairy'],
    isLegendary: false,
    isMythical: false,
    evolutionChainId: 10,
    varieties: [
      PokemonVarietyRef(pokemonId: 25, name: 'pikachu', isDefault: true),
      PokemonVarietyRef(pokemonId: 10080, name: 'pikachu-rock-star', isDefault: false),
    ],
  );

  static const EvolutionNode pikachuEvolutionChain = EvolutionNode(
    speciesId: 172,
    speciesName: 'pichu',
    evolvesTo: [
      EvolutionNode(
        speciesId: 25,
        speciesName: 'pikachu',
        triggerLabel: 'Amistad',
        evolvesTo: [
          EvolutionNode(
            speciesId: 26,
            speciesName: 'raichu',
            triggerLabel: 'Thunder Stone',
          ),
        ],
      ),
    ],
  );

  static const TypeDetail electricTypeDetail = TypeDetail(
    id: 13,
    name: 'electric',
    damageRelations: TypeDamageRelations(
      doubleDamageFrom: ['ground'],
      halfDamageFrom: ['flying', 'steel', 'electric'],
      noDamageFrom: [],
      doubleDamageTo: ['flying', 'water'],
      halfDamageTo: ['grass', 'electric', 'dragon'],
      noDamageTo: ['ground'],
    ),
    pokemonList: [
      PokemonSummary(id: 25, name: 'pikachu'),
      PokemonSummary(id: 26, name: 'raichu'),
      PokemonSummary(id: 81, name: 'magnemite'),
      PokemonSummary(id: 100, name: 'voltorb'),
      PokemonSummary(id: 135, name: 'jolteon'),
    ],
  );

  static const AbilityDetail staticAbility = AbilityDetail(
    id: 9,
    name: 'static',
    shortEffect: 'Has a 30% chance of paralyzing attacking Pokémon on contact.',
    effect: 'Whenever a move makes contact with this Pokémon, the attacker may be paralyzed.',
    flavorText: 'Paralyzes on contact.',
  );

  static const MoveDetail thunderboltMove = MoveDetail(
    id: 85,
    name: 'thunderbolt',
    typeName: 'electric',
    damageClass: 'special',
    power: 90,
    accuracy: 100,
    pp: 15,
    priority: 0,
    effectChance: 10,
    shortEffect: 'Has a 10% chance to paralyze the target.',
    flavorText: 'A strong electric blast crashes down on the target.',
  );

  static const GeoLocation testLocation = GeoLocation(
    latitude: 19.4326,
    longitude: -99.1332,
    accuracyMeters: 15.0,
  );

  static const WeatherForecast stormForecast = WeatherForecast(
    latitude: 19.43,
    longitude: -99.13,
    timezone: 'America/Mexico_City',
    timezoneAbbreviation: 'CST',
    elevation: 2230,
    temperatureC: 16.4,
    apparentTemperatureC: 15.2,
    relativeHumidity: 86,
    isDay: true,
    precipitationMm: 2.4,
    rainMm: 2.4,
    weatherCode: 95,
    cloudCoverPercent: 92,
    windSpeedKmh: 26.0,
    hourlyPoints: [
      HourlyForecastPoint(
        timeIso: '2026-11-12T18:00',
        temperatureC: 16.4,
        precipitationProbability: 90,
        weatherCode: 95,
      ),
      HourlyForecastPoint(
        timeIso: '2026-11-12T19:00',
        temperatureC: 15.8,
        precipitationProbability: 85,
        weatherCode: 61,
      ),
    ],
  );

  static const NotificationSettings defaultNotifSettings = NotificationSettings(
    enabled: false,
    intervalMinutes: 30,
  );

  static const RecommendedPokemonAlert sampleAlert = RecommendedPokemonAlert(
    id: 25,
    name: 'pikachu',
    types: ['electric'],
    hp: 35,
    attack: 55,
    speed: 90,
  );

  static const List<AndroidPermissionItem> samplePermissions = [
    AndroidPermissionItem(
      kind: AndroidPermissionKind.locationWhenInUse,
      title: 'Ubicación GPS (En uso)',
      manifestPermission: 'ACCESS_FINE_LOCATION / COARSE',
      description: 'Necesario para coordenadas GPS y Open-Meteo.',
      status: DiagnosticPermissionStatus.granted,
      canRequestInApp: true,
    ),
    AndroidPermissionItem(
      kind: AndroidPermissionKind.notification,
      title: 'Notificaciones Locales',
      manifestPermission: 'POST_NOTIFICATIONS (Android 13+)',
      description: 'Permite alertas programadas y pruebas interactivas.',
      status: DiagnosticPermissionStatus.denied,
      canRequestInApp: true,
    ),
  ];
}
