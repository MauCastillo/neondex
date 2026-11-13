import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/cyber_colors.dart';
import '../../../../core/theme/cyber_text_styles.dart';
import '../../../../core/widgets/cyber_error_panel.dart';
import '../../../../core/widgets/cyber_hud_card.dart';
import '../../../../core/widgets/cyber_loading_indicator.dart';
import '../../../../core/widgets/cyber_section_header.dart';
import '../../../pokedex/presentation/widgets/cyber_pokemon_card.dart';
import '../providers/favorites_provider.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favsAsync = ref.watch(favoritesProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: CyberSectionHeader(
              title: 'FAVORITOS GUARDADOS',
              codeTag: 'MEMORIA LOCAL PERSISTENTE',
              accentColor: CyberColors.cyberYellow,
              trailing: favsAsync.asData != null
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: CyberColors.cyberYellow.withValues(alpha: 0.14),
                        border: Border.all(color: CyberColors.cyberYellow),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${favsAsync.asData!.value.length}',
                        style: CyberTextStyles.monoTag.copyWith(
                          color: CyberColors.cyberYellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          Expanded(
            child: favsAsync.when(
              loading: () => const CyberLoadingIndicator(
                label: 'CARGANDO ARCHIVO LOCAL...',
                color: CyberColors.cyberYellow,
              ),
              error: (err, _) => CyberErrorPanel(message: err.toString()),
              data: (favorites) {
                if (favorites.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: CyberHudCard(
                        accentColor: CyberColors.cyberYellow,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_outline_rounded,
                              size: 54,
                              color: CyberColors.cyberYellow,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'BÓVEDA DE FAVORITOS VACÍA',
                              textAlign: TextAlign.center,
                              style: CyberTextStyles.hudHeadline,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pulsa la estrella neón en cualquier Pokémon para guardarlo localmente en tu dispositivo.',
                              textAlign: TextAlign.center,
                              style: CyberTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final crossAxisCount = width >= 900
                        ? 4
                        : width >= 600
                            ? 3
                            : 2;

                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(14, 6, 14, 16),
                      itemCount: favorites.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.82,
                      ),
                      itemBuilder: (context, index) {
                        final pokemon = favorites[index];
                        return CyberPokemonCard(
                          pokemon: pokemon,
                          heroTagPrefix: 'favorites-grid',
                          onTap: () => Navigator.of(context).pushNamed(
                            AppRoutes.pokemonDetail(pokemon.id),
                            arguments: PokemonDetailRouteArgs(
                              summary: pokemon,
                              heroTag: 'favorites-grid-${pokemon.id}',
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
