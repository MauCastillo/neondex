import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neondex/core/router/app_router.dart';
import 'package:neondex/core/theme/cyber_theme.dart';
import 'package:neondex/features/favorites/presentation/pages/favorites_page.dart';
import 'package:neondex/features/pokedex/presentation/pages/pokedex_home_page.dart';
import 'package:neondex/features/pokedex/presentation/pages/pokemon_detail_page.dart';
import 'package:neondex/features/pokedex/presentation/pages/type_pokemon_list_page.dart';

import '../../fixtures/fake_data.dart';
import '../../fixtures/mock_usecases.dart';

void main() {
  late TestUseCaseBundle bundle;

  setUp(() {
    bundle = TestUseCaseBundle()..stubDefaults();
  });

  Widget buildTestHost(Widget home) {
    return ProviderScope(
      overrides: bundle.buildOverrides(),
      child: MaterialApp(
        theme: CyberTheme.buildDarkTheme(),
        onGenerateRoute: AppRouter.onGenerateRoute,
        home: Scaffold(body: home),
      ),
    );
  }

  testWidgets('PokedexHomePage auto-loads, toggles favorites, and paginates on scroll', (tester) async {
    tester.view.physicalSize = const Size(411, 891);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestHost(const PokedexHomePage()));
    await tester.pumpAndSettle();

    expect(find.text('Pikachu'), findsOneWidget);
    expect(find.text('Bulbasaur'), findsOneWidget);

    // Toggle favorite star on first card
    final stars = find.byIcon(Icons.star_outline_rounded);
    expect(stars, findsWidgets);
    await tester.tap(stars.first);
    await tester.pumpAndSettle();
    verify(() => bundle.toggleFavorite(any())).called(1);

    // Search filters visible items
    await tester.enterText(find.byType(TextField), 'pika');
    await tester.pumpAndSettle();
    expect(find.text('Pikachu'), findsOneWidget);
    expect(find.text('Bulbasaur'), findsNothing);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();

    // Drag down to trigger pagination
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1000));
    await tester.pumpAndSettle();
    verify(
      () => bundle.getPokemonList(limit: any(named: 'limit'), offset: 4),
    ).called(1);
    expect(find.text('Gengar'), findsOneWidget);
  });

  testWidgets(
    'PokemonDetailPage auto-loads stats, lazy modals, type navigation, and evolution chain',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestHost(const PokemonDetailPage(pokemonId: 25)),
      );
      await tester.pumpAndSettle();

      expect(find.text('PIKACHU'), findsOneWidget);
      expect(find.text('Pokémon Ratón'), findsOneWidget);
      expect(find.text('TOTAL: 320'), findsOneWidget);
      expect(find.text('LÍNEA EVOLUTIVA INTERACTIVA'), findsOneWidget);

      // Lazy-load Ability modal
      await tester.scrollUntilVisible(
        find.text('Static'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Static'));
      await tester.pumpAndSettle();
      verify(() => bundle.getAbilityDetail('static')).called(1);
      expect(find.text('Has a 30% chance of paralyzing attacking Pokémon on contact.'), findsOneWidget);

      // Close modal
      Navigator.of(tester.element(find.text('EFECTO PRINCIPAL'))).pop();
      await tester.pumpAndSettle();

      // Open Moves sheet & lazy-load move detail
      await tester.scrollUntilVisible(
        find.text('INSPECCIONAR 2 MOVIMIENTOS'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('INSPECCIONAR 2 MOVIMIENTOS'));
      await tester.pumpAndSettle();
      expect(find.text('Thunderbolt'), findsOneWidget);

      await tester.tap(find.text('Thunderbolt'));
      await tester.pumpAndSettle();
      verify(() => bundle.getMoveDetail('thunderbolt')).called(1);
      expect(find.text('90'), findsOneWidget);

      // Close move detail and moves sheet
      Navigator.of(tester.element(find.text('EFECTO DE COMBATE'))).pop();
      await tester.pumpAndSettle();
      Navigator.of(tester.element(find.text('Quick Attack'))).pop();
      await tester.pumpAndSettle();

      // Switch effectiveness tab to ATAQUE and tap WATER to open TypePokemonListPage
      await tester.scrollUntilVisible(
        find.text('ATAQUE'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('ATAQUE'));
      await tester.pumpAndSettle();
      expect(find.text('FUERTE CONTRA (2x STAB)'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('WATER'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('WATER'));
      await tester.pumpAndSettle();

      expect(find.byType(TypePokemonListPage), findsOneWidget);
      expect(find.text('SECTOR // TIPO WATER'), findsOneWidget);

      // Navigate back to Detail and tap Raichu in EvolutionChainSection
      Navigator.of(tester.element(find.byType(TypePokemonListPage))).pop();
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Raichu'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(find.text('Raichu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Raichu'));
      await tester.pumpAndSettle();
      verify(() => bundle.getPokemonDetail(26)).called(1);
    },
  );

  testWidgets(
    'PokemonDetailPage renders without overflow on compact 320x568 viewport',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestHost(const PokemonDetailPage(pokemonId: 25)),
      );
      await tester.pumpAndSettle();

      expect(find.text('PIKACHU'), findsOneWidget);
      await tester.drag(
        find.byType(Scrollable).first,
        const Offset(0, -600),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'FavoritesPage renders saved Pokemon without overflow on compact 320x568 viewport',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      when(() => bundle.getFavorites()).thenAnswer(
        (_) async => const [
          FakeTestFixtures.pikachuSummary,
          FakeTestFixtures.raichuSummary,
        ],
      );
      await tester.pumpWidget(buildTestHost(const FavoritesPage()));
      await tester.pumpAndSettle();

      expect(find.text('Pikachu'), findsOneWidget);
      expect(find.text('Raichu'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('TypePokemonListPage auto-loads type roster cleanly', (tester) async {
    await tester.pumpWidget(
      buildTestHost(const TypePokemonListPage(typeName: 'electric')),
    );
    await tester.pumpAndSettle();

    expect(find.text('ESPECÍMENES DE TIPO ELECTRIC'), findsOneWidget);
    expect(find.text('Pikachu'), findsOneWidget);
    expect(find.text('Jolteon'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
