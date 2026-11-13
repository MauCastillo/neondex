import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:neondex/core/error/exceptions.dart';
import 'package:neondex/core/network/api_client.dart';
import 'package:neondex/features/pokedex/data/datasources/pokedex_remote_data_source.dart';
import 'package:neondex/features/pokedex/data/models/ability_detail_model.dart';
import 'package:neondex/features/pokedex/data/models/evolution_chain_model.dart';
import 'package:neondex/features/pokedex/data/models/move_detail_model.dart';
import 'package:neondex/features/pokedex/data/models/pokemon_detail_model.dart';
import 'package:neondex/features/pokedex/data/models/pokemon_species_model.dart';
import 'package:neondex/features/pokedex/data/models/type_detail_model.dart';
import 'package:neondex/features/pokedex/data/repositories/pokedex_repository_impl.dart';

void main() {
  group('PokeAPI Data Models', () {
    test('PokemonDetailModel parses sprites, stats, types, abilities, moves', () {
      final detail = PokemonDetailModel.fromJson({
        'id': 25,
        'name': 'pikachu',
        'height': 4,
        'weight': 60,
        'base_experience': 112,
        'types': [
          {
            'slot': 1,
            'type': {'name': 'electric', 'url': 'https://pokeapi.co/api/v2/type/13/'},
          },
        ],
        'stats': [
          {'base_stat': 35, 'effort': 0, 'stat': {'name': 'hp'}},
          {'base_stat': 90, 'effort': 2, 'stat': {'name': 'speed'}},
        ],
        'abilities': [
          {
            'is_hidden': false,
            'slot': 1,
            'ability': {'name': 'static', 'url': 'https://pokeapi.co/api/v2/ability/9/'},
          },
        ],
        'moves': [
          {
            'move': {'name': 'thunderbolt', 'url': 'https://pokeapi.co/api/v2/move/85/'},
            'version_group_details': [
              {
                'level_learned_at': 26,
                'move_learn_method': {'name': 'level-up'},
              },
            ],
          },
        ],
        'species': {
          'name': 'pikachu',
          'url': 'https://pokeapi.co/api/v2/pokemon-species/25/',
        },
        'sprites': {
          'front_default': 'https://img/25.png',
          'other': {
            'official-artwork': {
              'front_default': 'https://img/art/25.png',
              'front_shiny': 'https://img/art/shiny/25.png',
            },
          },
        },
      });

      expect(detail.id, 25);
      expect(detail.types, ['electric']);
      expect(detail.baseStatTotal, 125);
      expect(detail.abilities.first.id, 9);
      expect(detail.moves.first.levelLearnedAt, 26);
      expect(detail.spriteUrl, 'https://img/art/25.png');
    });

    test('PokemonSpeciesModel prefers Spanish and extracts evolution chain ID', () {
      final species = PokemonSpeciesModel.fromJson({
        'id': 25,
        'name': 'pikachu',
        'capture_rate': 190,
        'base_happiness': 70,
        'is_legendary': false,
        'is_mythical': false,
        'habitat': {'name': 'forest'},
        'color': {'name': 'yellow'},
        'generation': {'name': 'generation-i'},
        'growth_rate': {'name': 'medium'},
        'egg_groups': [{'name': 'ground'}, {'name': 'fairy'}],
        'evolution_chain': {'url': 'https://pokeapi.co/api/v2/evolution-chain/10/'},
        'genera': [
          {'genus': 'Mouse Pokémon', 'language': {'name': 'en'}},
          {'genus': 'Pokémon Ratón', 'language': {'name': 'es'}},
        ],
        'flavor_text_entries': [
          {'flavor_text': 'English\ntext', 'language': {'name': 'en'}},
          {'flavor_text': 'Texto\fen español', 'language': {'name': 'es'}},
        ],
        'varieties': [
          {'is_default': true, 'pokemon': {'name': 'pikachu', 'url': 'https://pokeapi.co/api/v2/pokemon/25/'}},
        ],
      });

      expect(species.genus, 'Pokémon Ratón');
      expect(species.flavorText, 'Texto en español');
      expect(species.evolutionChainId, 10);
      expect(species.varieties.single.pokemonId, 25);
    });

    test('EvolutionChainModel parses branching evolutions (Eevee)', () {
      final root = EvolutionChainModel.fromJson({
        'id': 67,
        'chain': {
          'species': {'name': 'eevee', 'url': 'https://pokeapi.co/api/v2/pokemon-species/133/'},
          'evolution_details': [],
          'evolves_to': [
            {
              'species': {'name': 'vaporeon', 'url': 'https://pokeapi.co/api/v2/pokemon-species/134/'},
              'evolution_details': [
                {'trigger': {'name': 'use-item'}, 'item': {'name': 'water-stone'}},
              ],
              'evolves_to': [],
            },
            {
              'species': {'name': 'espeon', 'url': 'https://pokeapi.co/api/v2/pokemon-species/196/'},
              'evolution_details': [
                {'trigger': {'name': 'level-up'}, 'min_happiness': 160, 'time_of_day': 'day'},
              ],
              'evolves_to': [],
            },
          ],
        },
      });

      expect(root.speciesId, 133);
      expect(root.evolvesTo.length, 2);
      expect(root.evolvesTo[0].speciesName, 'vaporeon');
      expect(root.evolvesTo[0].triggerLabel, 'Water Stone');
      expect(root.evolvesTo[1].triggerLabel, 'Amistad (day)');
    });

    test('TypeDetailModel, AbilityDetailModel, MoveDetailModel parse accurately', () {
      final typeDetail = TypeDetailModel.fromJson({
        'id': 13,
        'name': 'electric',
        'damage_relations': {
          'double_damage_from': [{'name': 'ground'}],
          'half_damage_from': [{'name': 'flying'}],
          'no_damage_from': [],
          'double_damage_to': [{'name': 'water'}],
          'half_damage_to': [{'name': 'grass'}],
          'no_damage_to': [{'name': 'ground'}],
        },
        'pokemon': [
          {'slot': 1, 'pokemon': {'name': 'pikachu', 'url': 'https://pokeapi.co/api/v2/pokemon/25/'}},
        ],
      });
      expect(typeDetail.damageRelations.doubleDamageFrom, ['ground']);
      expect(typeDetail.pokemonList.single.id, 25);

      final ability = AbilityDetailModel.fromJson({
        'id': 9,
        'name': 'static',
        'effect_entries': [
          {'short_effect': 'Paralyzes.', 'effect': 'Full effect.', 'language': {'name': 'en'}},
        ],
        'flavor_text_entries': [],
      });
      expect(ability.shortEffect, 'Paralyzes.');

      final move = MoveDetailModel.fromJson({
        'id': 85,
        'name': 'thunderbolt',
        'power': 90,
        'accuracy': 100,
        'pp': 15,
        'priority': 0,
        'effect_chance': 10,
        'type': {'name': 'electric'},
        'damage_class': {'name': 'special'},
        'effect_entries': [
          {
            'short_effect': r'Has a $effect_chance% chance to paralyze.',
            'language': {'name': 'en'},
          },
        ],
        'flavor_text_entries': [],
      });
      expect(move.power, 90);
      expect(move.shortEffect, 'Has a 10% chance to paralyze.');
    });
  });

  group('PokedexRepositoryImpl with MockClient', () {
    test('fetches paginated list and caches subsequent identical requests', () async {
      var callCount = 0;
      final mockClient = MockClient((request) async {
        callCount++;
        return http.Response(
          jsonEncode({
            'count': 1351,
            'next': 'https://pokeapi.co/api/v2/pokemon?offset=24&limit=24',
            'results': [
              {'name': 'bulbasaur', 'url': 'https://pokeapi.co/api/v2/pokemon/1/'},
              {'name': 'pikachu', 'url': 'https://pokeapi.co/api/v2/pokemon/25/'},
            ],
          }),
          200,
        );
      });

      final apiClient = ApiClient(httpClient: mockClient);
      final repo = PokedexRepositoryImpl(PokedexRemoteDataSourceImpl(apiClient));

      final page1 = await repo.getPokemonList(limit: 24, offset: 0);
      final page1Cached = await repo.getPokemonList(limit: 24, offset: 0);

      expect(page1.totalCount, 1351);
      expect(page1.hasMore, isTrue);
      expect(page1.items.length, 2);
      expect(page1Cached.items.last.id, 25);
      expect(callCount, 1);
    });

    test('maps 404 to ServerException and SocketException to NetworkException', () async {
      final client404 = MockClient((_) async => http.Response('Not Found', 404));
      final repo404 = PokedexRepositoryImpl(
        PokedexRemoteDataSourceImpl(ApiClient(httpClient: client404)),
      );
      expect(
        () => repo404.getPokemonDetail('missingno'),
        throwsA(isA<ServerException>()),
      );

      final clientNet = MockClient((_) async => throw const SocketException('offline'));
      final repoNet = PokedexRepositoryImpl(
        PokedexRemoteDataSourceImpl(ApiClient(httpClient: clientNet)),
      );
      expect(
        () => repoNet.getPokemonList(limit: 24, offset: 0),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
