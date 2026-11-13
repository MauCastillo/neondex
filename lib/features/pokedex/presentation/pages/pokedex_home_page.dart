import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/cyber_colors.dart';
import '../../../../core/theme/cyber_text_styles.dart';
import '../../../../core/widgets/cyber_error_panel.dart';
import '../../../../core/widgets/cyber_loading_indicator.dart';
import '../providers/pokedex_list_provider.dart';
import '../widgets/cyber_pokemon_card.dart';

class PokedexHomePage extends ConsumerStatefulWidget {
  const PokedexHomePage({super.key});

  @override
  ConsumerState<PokedexHomePage> createState() => _PokedexHomePageState();
}

class _PokedexHomePageState extends ConsumerState<PokedexHomePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 320) {
      ref.read(pokedexListProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pokedexAsync = ref.watch(pokedexListProvider);

    return SafeArea(
      child: Column(
        children: [
          _CyberTopHeader(
            searchController: _searchController,
            totalCount: pokedexAsync.asData?.value.totalCount,
            loadedCount: pokedexAsync.asData?.value.items.length,
            isSearchingRemote:
                pokedexAsync.asData?.value.isSearchingRemote ?? false,
            onSearchChanged: (q) =>
                ref.read(pokedexListProvider.notifier).updateSearch(q),
            onClearSearch: () {
              _searchController.clear();
              ref.read(pokedexListProvider.notifier).updateSearch('');
            },
          ),
          Expanded(
            child: pokedexAsync.when(
              loading: () => const CyberLoadingIndicator(
                label: 'SINCRONIZANDO BASE POKEAPI...',
              ),
              error: (err, _) => CyberErrorPanel(
                message: err.toString(),
                onRetry: () => ref.read(pokedexListProvider.notifier).refresh(),
              ),
              data: (state) {
                final items = state.visibleItems;
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.search_off_rounded,
                            size: 46,
                            color: CyberColors.neonMagenta,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            state.isSearchingRemote
                                ? 'ESCANEANDO POKEAPI...'
                                : 'SIN COINCIDENCIAS EN ESTE SECTOR',
                            textAlign: TextAlign.center,
                            style: CyberTextStyles.hudHeadline,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Prueba el nombre exacto o número nacional (ej. pikachu o 25).',
                            textAlign: TextAlign.center,
                            style: CyberTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  color: CyberColors.neonCyan,
                  backgroundColor: CyberColors.panelDark,
                  onRefresh: () =>
                      ref.read(pokedexListProvider.notifier).refresh(),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final crossAxisCount = width >= 900
                          ? 4
                          : width >= 600
                              ? 3
                              : 2;

                      return NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification is ScrollUpdateNotification ||
                              notification is ScrollEndNotification) {
                            if (notification.metrics.pixels >=
                                notification.metrics.maxScrollExtent - 320) {
                              ref.read(pokedexListProvider.notifier).loadMore();
                            }
                          } else if (notification is OverscrollNotification &&
                              notification.overscroll > 0) {
                            ref.read(pokedexListProvider.notifier).loadMore();
                          }
                          return false;
                        },
                        child: CustomScrollView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
                              sliver: SliverGrid(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final pokemon = items[index];
                                    return CyberPokemonCard(
                                      pokemon: pokemon,
                                      heroTagPrefix: 'pokedex-home',
                                      onTap: () =>
                                          Navigator.of(context).pushNamed(
                                        AppRoutes.pokemonDetail(pokemon.id),
                                        arguments: PokemonDetailRouteArgs(
                                          summary: pokemon,
                                          heroTag: 'pokedex-home-${pokemon.id}',
                                        ),
                                      ),
                                    );
                                  },
                                  childCount: items.length,
                                ),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 0.82,
                                ),
                              ),
                            ),
                            if (state.isLoadingMore)
                              const SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: CyberLoadingIndicator(
                                    label: 'CARGANDO SIGUIENTE BLOQUE...',
                                  ),
                                ),
                              )
                            else if (state.paginationError != null)
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: OutlinedButton.icon(
                                    onPressed: () => ref
                                        .read(pokedexListProvider.notifier)
                                        .loadMore(),
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('REINTENTAR PAGINACIÓN'),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CyberTopHeader extends StatelessWidget {
  const _CyberTopHeader({
    required this.searchController,
    required this.totalCount,
    required this.loadedCount,
    required this.isSearchingRemote,
    required this.onSearchChanged,
    required this.onClearSearch,
  });

  final TextEditingController searchController;
  final int? totalCount;
  final int? loadedCount;
  final bool isSearchingRemote;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: CyberColors.deepSpace,
        border: Border(
          bottom: BorderSide(
            color: CyberColors.neonCyan.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/neondex_logo.png',
                width: 34,
                height: 34,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.catching_pokemon,
                  color: CyberColors.neonCyan,
                  size: 30,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NEONDEX // 2099',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CyberTextStyles.hudTitle.copyWith(fontSize: 18),
                    ),
                    Text(
                      loadedCount != null && totalCount != null
                          ? 'REGISTROS: $loadedCount / $totalCount'
                          : 'ENLACE NEURAL ACTIVO',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CyberTextStyles.monoTag.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
              if (isSearchingRemote)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: CyberColors.cyberYellow,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Buscar Pokémon o ID (ej. pikachu, 150)...',
              prefixIcon: const Icon(
                Icons.manage_search_rounded,
                color: CyberColors.neonCyan,
              ),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: onClearSearch,
                      icon: const Icon(
                        Icons.close,
                        color: CyberColors.neonMagenta,
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
