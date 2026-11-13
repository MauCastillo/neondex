import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/di/service_locator.dart';
import 'core/theme/cyber_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: CyberColors.deepSpace,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await setupServiceLocator(initializePlatformServices: false);

  runApp(
    const ProviderScope(
      child: NeonDexApp(),
    ),
  );

  // Initialize notifications, WorkManager, and deep-link listeners after frame 1
  // so Android always clears the splash screen immediately.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    initializePlatformServicesSafely();
  });
}
