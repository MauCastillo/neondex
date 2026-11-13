import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neondex/app.dart';
import 'package:neondex/core/router/deep_link_coordinator.dart';
import 'package:neondex/core/theme/cyber_theme.dart';
import 'package:neondex/features/notifications_settings/domain/entities/android_permission_item.dart';
import 'package:neondex/features/notifications_settings/presentation/pages/system_settings_page.dart';
import 'package:neondex/features/pokedex/presentation/pages/pokemon_detail_page.dart';

import '../../fixtures/mock_usecases.dart';

void main() {
  late TestUseCaseBundle bundle;

  setUp(() {
    bundle = TestUseCaseBundle()..stubDefaults();
  });

  testWidgets(
    'SystemSettingsPage configures interval, fires immediate test notification, and displays live Android permission statuses',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: bundle.buildOverrides(),
          child: MaterialApp(
            theme: CyberTheme.buildDarkTheme(),
            home: const Scaffold(body: SystemSettingsPage()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Toggle schedule and select interval preset
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      verify(
        () => bundle.updateNotificationSchedule(enabled: true, intervalMinutes: 30),
      ).called(1);

      await tester.tap(find.text('15 min'));
      await tester.pumpAndSettle();
      verify(
        () => bundle.updateNotificationSchedule(enabled: true, intervalMinutes: 15),
      ).called(1);

      // Fire immediate test notification
      await tester.tap(find.text('PROBAR NOTIFICACIÓN AHORA'));
      await tester.pumpAndSettle();
      verify(() => bundle.triggerTestNotification()).called(1);
      expect(find.text('#025 PIKACHU'), findsOneWidget);

      // Dismiss SnackBar before scrolling down to permissions
      ScaffoldMessenger.of(
        tester.element(find.byType(SystemSettingsPage)),
      ).hideCurrentSnackBar();
      await tester.pumpAndSettle();

      // Permission diagnostics section
      await tester.scrollUntilVisible(find.text('CONCEDER PERMISO'), 200);
      await tester.ensureVisible(find.text('CONCEDER PERMISO'));
      await tester.pumpAndSettle();
      expect(find.text('CONCEDIDO'), findsOneWidget);
      expect(find.text('DENEGADO'), findsOneWidget);

      await tester.tap(find.text('CONCEDER PERMISO'));
      await tester.pumpAndSettle();
      verify(
        () => bundle.requestAndroidPermission(AndroidPermissionKind.notification),
      ).called(1);
      expect(find.text('ESTADO GLOBAL: 2 / 2 MÓDULOS OPERATIVOS'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'DeepLinkCoordinator navigates automatically to PokemonDetailPage when notification payload arrives',
    (tester) async {
      final coordinator = DeepLinkCoordinator();
      addTearDown(coordinator.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: bundle.buildOverrides(),
          child: NeonDexApp(deepLinkCoordinator: coordinator),
        ),
      );
      await tester.pumpAndSettle();

      // Simulate tapping a notification with deep link payload
      coordinator.handlePayload('neondex://pokemon/25');
      await tester.pumpAndSettle();

      expect(find.byType(PokemonDetailPage), findsOneWidget);
      expect(find.text('PIKACHU'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
