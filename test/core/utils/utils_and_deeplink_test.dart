import 'package:flutter_test/flutter_test.dart';
import 'package:neondex/core/router/deep_link_coordinator.dart';
import 'package:neondex/core/utils/pokeapi_url_parser.dart';
import 'package:neondex/core/utils/pokemon_formatters.dart';

void main() {
  group('PokeApiUrlParser', () {
    test('extracts integer IDs from PokeAPI resource URLs', () {
      expect(
        PokeApiUrlParser.extractIdFromUrl(
          'https://pokeapi.co/api/v2/pokemon/25/',
        ),
        25,
      );
      expect(
        PokeApiUrlParser.extractIdFromUrl(
          'https://pokeapi.co/api/v2/pokemon-species/386',
        ),
        386,
      );
      expect(
        PokeApiUrlParser.extractIdFromUrl(
          'https://pokeapi.co/api/v2/evolution-chain/67/',
        ),
        67,
      );
      expect(PokeApiUrlParser.extractIdFromUrl(null), isNull);
      expect(PokeApiUrlParser.extractIdFromUrl('invalid'), isNull);
    });
  });

  group('PokemonFormatters', () {
    test('formats dex numbers, measurements, names, and flavor text', () {
      expect(PokemonFormatters.formatDexNumber(1), '#001');
      expect(PokemonFormatters.formatDexNumber(25), '#025');
      expect(PokemonFormatters.formatDexNumber(1008), '#1008');

      expect(PokemonFormatters.formatDisplayName('lightning-rod'), 'Lightning Rod');
      expect(PokemonFormatters.formatDisplayName('mr-mime'), 'Mr Mime');

      expect(PokemonFormatters.formatHeightMeters(4), '0.4 m');
      expect(PokemonFormatters.formatWeightKg(60), '6.0 kg');

      expect(
        PokemonFormatters.sanitizeFlavorText('Line1\fLine2\n  Line3'),
        'Line1 Line2 Line3',
      );
      expect(PokemonFormatters.formatStatShortLabel('special-attack'), 'SP.A');
      expect(PokemonFormatters.formatStatShortLabel('speed'), 'SPD');
    });
  });

  group('DeepLinkCoordinator', () {
    test('parses custom URI, path, JSON, and numeric payloads', () {
      expect(DeepLinkCoordinator.parsePokemonId('neondex://pokemon/25'), 25);
      expect(DeepLinkCoordinator.parsePokemonId('/pokemon/150'), 150);
      expect(DeepLinkCoordinator.parsePokemonId('{"pokemonId": 384}'), 384);
      expect(DeepLinkCoordinator.parsePokemonId('94'), 94);
      expect(DeepLinkCoordinator.parsePokemonId(''), isNull);
      expect(DeepLinkCoordinator.parsePokemonId('neondex://unknown'), isNull);
    });

    test('emits parsed pokemon ID on stream and stores pending ID', () async {
      final coordinator = DeepLinkCoordinator();
      addTearDown(coordinator.dispose);

      final emitted = <int>[];
      final sub = coordinator.pokemonRouteStream.listen(emitted.add);

      coordinator.handlePayload('neondex://pokemon/25');
      await Future<void>.delayed(Duration.zero);

      expect(emitted, [25]);
      expect(coordinator.consumePendingPokemonId(), 25);
      expect(coordinator.consumePendingPokemonId(), isNull);
      await sub.cancel();
    });
  });
}
