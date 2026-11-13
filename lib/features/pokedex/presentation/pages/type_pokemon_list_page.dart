import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/pokemon_type_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/cyber_colors.dart';
import '../../../../core/theme/cyber_text_styles.dart';
import '../../../../core/widgets/cyber_error_panel.dart';
import '../../../../core/widgets/cyber_hud_card.dart';
import '../../../../core/widgets/cyber_loading_indicator.dart';
import '../providers/type_pokemon_list_provider.dart';
import '../widgets/cyber_pokemon_card.dart';

class TypePokemonListPage extends ConsumerStatefulWidget {
  const TypePokemonListPage({
    super.key,
    required this.typeName,
  });

  final String typeName;

  @override
  ConsumerState<TypePokemonListPage> createState() =>
      _TypePokemonListPageState();
}

class _TypePokemonListPageState extends ConsumerState<TypePokemonListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 280) {
      ref.read(typePokemonListProvider(widget.typeName).notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final typeAsync = ref.watch(typePokemonListProvider(widget.typeName));
    final typeMeta = PokemonTypeConstants.of(widget.typeName);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(typeMeta.icon, color: typeMeta.color, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'SECTOR // TIPO ${typeMeta.name.toUpperCase()}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: typeAsync.when(
          loading: () => CyberLoadingIndicator(
            label: 'FILTRANDO ELEMENTO ${typeMeta.name.toUpperCase()}...',
            color: typeMeta.color,
          ),
          error: (err, _) => CyberErrorPanel(
            message: err.toString(),
            onRetry: () =>
                ref.invalidate(typePokemonListProvider(widget.typeName)),
          ),
          data: (state) {
            return LayoutBuilder(
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
                        ref
                            .read(typePokemonListProvider(widget.typeName)
                                .notifier)
                            .loadMore();
                      }
                    } else if (notification is OverscrollNotification &&
                        notification.overscroll > 0) {
                      ref
                          .read(
                              typePokemonListProvider(widget.typeName).notifier)
                          .loadMore();
                    }
                    return false;
                  },
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                        child: CyberHudCard(
                          accentColor: typeMeta.color,
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Icon(
                                typeMeta.icon,
                                size: 32,
                                color: typeMeta.color,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ESPECÍMENES DE TIPO ${typeMeta.name.toUpperCase()}',
                                      style: CyberTextStyles.hudLabel.copyWith(
                                        color: typeMeta.color,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Mostrando ${state.visibleItems.length} de ${state.totalCount} registros paginados',
                                      style: CyberTextStyles.monoTag.copyWith(
                                        fontSize: 11,
                                        color: CyberColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(14, 6, 14, 16),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final pokemon = state.visibleItems[index];
                            return CyberPokemonCard(
                              pokemon: pokemon,
                              heroTagPrefix: 'type-${widget.typeName}',
                              onTap: () => Navigator.of(context).pushNamed(
                                AppRoutes.pokemonDetail(pokemon.id),
                                arguments: PokemonDetailRouteArgs(
                                  summary: pokemon,
                                  heroTag:
                                      'type-${widget.typeName}-${pokemon.id}',
                                ),
                              ),
                            );
                          },
                          childCount: state.visibleItems.length,
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
                    if (state.hasMore)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                          child: OutlinedButton.icon(
                            onPressed: () => ref
                                .read(
                                  typePokemonListProvider(widget.typeName)
                                      .notifier,
                                )
                                .loadMore(),
                            icon: const Icon(Icons.expand_more),
                            label: const Text('CARGAR MÁS POKÉMON'),
                          ),
                        ),
                      ),
                  ],
                ),
              );
              },
            );
          },
        ),
      ),
    );
  }
}
