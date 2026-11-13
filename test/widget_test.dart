import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neondex/app.dart';
import 'package:neondex/core/router/deep_link_coordinator.dart';
import 'package:neondex/features/notifications_settings/presentation/pages/system_settings_page.dart';

import 'fixtures/mock_usecases.dart';

void main() {
  late TestUseCaseBundle bundle;

  setUp(() {
    bundle = TestUseCaseBundle()..stubDefaults();
  });

  testWidgets(
    'NeonDexApp boots automatically on compact 320x568 viewport without layout overflow and switches all 4 tabs',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final coordinator = DeepLinkCoordinator();
      addTearDown(coordinator.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: bundle.buildOverrides(),
          child: NeonDexApp(deepLinkCoordinator: coordinator),
        ),
      );
      await tester.pumpAndSettle();

      // Main Pokedex tab auto-loads
      expect(find.text('NEONDEX // 2099'), findsOneWidget);
      expect(find.text('Bulbasaur'), findsOneWidget);
      expect(find.text('Pikachu'), findsOneWidget);

      // Switch to Weather Radar tab
      await tester.tap(find.text('CLIMA'));
      await tester.pumpAndSettle();
      expect(find.text('RADAR CLIMÁTICO GPS'), findsOneWidget);
      expect(find.text('16.4°C'), findsOneWidget);

      // Switch to Favorites tab
      await tester.tap(find.text('FAVORITOS'));
      await tester.pumpAndSettle();
      expect(find.text('BÓVEDA DE FAVORITOS VACÍA'), findsOneWidget);

      // Switch to System / Diagnostics tab
      await tester.tap(find.text('SISTEMA'));
      await tester.pumpAndSettle();
      expect(find.text('NOTIFICACIONES Y DEEP LINK'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('DIAGNÓSTICO DE PERMISOS ANDROID'),
        200,
        scrollable: find.descendant(
          of: find.byType(SystemSettingsPage),
          matching: find.byType(Scrollable),
        ),
      );
      expect(find.text('DIAGNÓSTICO DE PERMISOS ANDROID'), findsOneWidget);

      expect(tester.takeException(), isNull);
    },
  );
}
