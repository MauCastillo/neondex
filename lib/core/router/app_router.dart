import 'package:material_ui/material_ui.dart';

import '../../features/pokedex/domain/entities/pokemon_summary.dart';
import '../../features/pokedex/presentation/pages/pokemon_detail_page.dart';
import '../../features/pokedex/presentation/pages/type_pokemon_list_page.dart';
import '../../shell/cyber_shell_page.dart';
import 'deep_link_coordinator.dart';

class AppRoutes {
  const AppRoutes._();

  static const String home = '/';
  static String pokemonDetail(int id) => '/pokemon/$id';
  static String typeList(String typeName) => '/type/$typeName';
}

class PokemonDetailRouteArgs {
  const PokemonDetailRouteArgs({this.summary, this.heroTag});

  final PokemonSummary? summary;
  final String? heroTag;
}

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? AppRoutes.home;

    if (name == AppRoutes.home) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const CyberShellPage(),
      );
    }

    final pokemonId = DeepLinkCoordinator.parsePokemonId(name);
    if (pokemonId != null && pokemonId > 0) {
      PokemonSummary? summary;
      String? heroTag;
      if (settings.arguments is PokemonDetailRouteArgs) {
        final args = settings.arguments as PokemonDetailRouteArgs;
        summary = args.summary;
        heroTag = args.heroTag;
      } else if (settings.arguments is PokemonSummary) {
        summary = settings.arguments as PokemonSummary;
      }
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => PokemonDetailPage(
          pokemonId: pokemonId,
          initialSummary: summary,
          heroTag: heroTag,
        ),
      );
    }

    if (name.startsWith('/type/')) {
      final typeName = name.substring('/type/'.length).trim().toLowerCase();
      if (typeName.isNotEmpty) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => TypePokemonListPage(typeName: typeName),
        );
      }
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => const CyberShellPage(),
    );
  }
}
