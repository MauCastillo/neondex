import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'core/router/deep_link_coordinator.dart';
import 'core/theme/cyber_theme.dart';

class NeonDexApp extends ConsumerStatefulWidget {
  const NeonDexApp({
    super.key,
    this.deepLinkCoordinator,
  });

  final DeepLinkCoordinator? deepLinkCoordinator;

  @override
  ConsumerState<NeonDexApp> createState() => _NeonDexAppState();
}

class _NeonDexAppState extends ConsumerState<NeonDexApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<int>? _deepLinkSub;

  DeepLinkCoordinator get _coordinator =>
      widget.deepLinkCoordinator ?? sl<DeepLinkCoordinator>();

  @override
  void initState() {
    super.initState();
    _deepLinkSub = _coordinator.pokemonRouteStream.listen(_navigateToPokemon);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pendingId = _coordinator.consumePendingPokemonId();
      if (pendingId != null && pendingId > 0) {
        _navigateToPokemon(pendingId);
      }
    });
  }

  void _navigateToPokemon(int pokemonId) {
    final nav = _navigatorKey.currentState;
    if (nav == null) return;
    nav.pushNamed(AppRoutes.pokemonDetail(pokemonId));
  }

  @override
  void dispose() {
    _deepLinkSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeonDex // Cyber-Pokédex',
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      theme: CyberTheme.buildDarkTheme(),
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
