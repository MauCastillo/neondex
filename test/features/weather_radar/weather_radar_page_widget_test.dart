import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neondex/core/error/exceptions.dart';
import 'package:neondex/core/router/app_router.dart';
import 'package:neondex/core/theme/cyber_theme.dart';
import 'package:neondex/features/pokedex/presentation/pages/type_pokemon_list_page.dart';
import 'package:neondex/features/weather_radar/presentation/pages/weather_radar_page.dart';

import '../../fixtures/mock_usecases.dart';

void main() {
  late TestUseCaseBundle bundle;

  setUp(() {
    bundle = TestUseCaseBundle()..stubDefaults();
  });

  testWidgets('WeatherRadarPage auto-loads telemetry, hourly forecast, and navigates on recommended type tap', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: bundle.buildOverrides(),
        child: MaterialApp(
          theme: CyberTheme.buildDarkTheme(),
          onGenerateRoute: AppRouter.onGenerateRoute,
          home: const Scaffold(body: WeatherRadarPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('16.4°C'), findsOneWidget);
    expect(find.text('TORMENTA ELÉCTRICA'), findsOneWidget);
    expect(find.text('18:00'), findsOneWidget);
    expect(find.text('98% AFINIDAD'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('98% AFINIDAD'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('98% AFINIDAD'));
    await tester.pumpAndSettle();

    expect(find.byType(TypePokemonListPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('WeatherRadarPage shows GPS error panel and permission CTA when location fails', (tester) async {
    when(() => bundle.getCurrentLocation()).thenThrow(
      const LocationServiceException(
        'Permiso de ubicación denegado',
        isPermissionIssue: true,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: bundle.buildOverrides(),
        child: MaterialApp(
          theme: CyberTheme.buildDarkTheme(),
          home: const Scaffold(body: WeatherRadarPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('RADAR GPS INACCESIBLE'), findsOneWidget);
    expect(find.text('SOLICITAR PERMISO DE UBICACIÓN'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
