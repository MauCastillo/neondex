import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/pokemon_summary.dart';
import 'pokedex_usecase_providers.dart';

class PokedexListState extends Equatable {
  const PokedexListState({
    required this.items,
    required this.totalCount,
    required this.hasMore,
    this.isLoadingMore = false,
    this.searchQuery = '',
    this.directSearchMatch,
    this.isSearchingRemote = false,
    this.paginationError,
  });

  final List<PokemonSummary> items;
  final int totalCount;
  final bool hasMore;
  final bool isLoadingMore;
  final String searchQuery;
  final PokemonSummary? directSearchMatch;
  final bool isSearchingRemote;
  final String? paginationError;

  List<PokemonSummary> get visibleItems {
    final q = searchQuery.trim().toLowerCase();
    if (q.isEmpty) return items;

    final filtered = items.where((p) {
      return p.name.toLowerCase().contains(q) || p.id.toString() == q;
    }).toList();

    if (directSearchMatch != null &&
        !filtered.any((item) => item.id == directSearchMatch!.id)) {
      return [directSearchMatch!, ...filtered];
    }
    return filtered;
  }

  PokedexListState copyWith({
    List<PokemonSummary>? items,
    int? totalCount,
    bool? hasMore,
    bool? isLoadingMore,
    String? searchQuery,
    PokemonSummary? directSearchMatch,
    bool clearDirectMatch = false,
    bool? isSearchingRemote,
    String? paginationError,
    bool clearPaginationError = false,
  }) {
    return PokedexListState(
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      searchQuery: searchQuery ?? this.searchQuery,
      directSearchMatch: clearDirectMatch
          ? null
          : (directSearchMatch ?? this.directSearchMatch),
      isSearchingRemote: isSearchingRemote ?? this.isSearchingRemote,
      paginationError: clearPaginationError
          ? null
          : (paginationError ?? this.paginationError),
    );
  }

  @override
  List<Object?> get props => [
        items,
        totalCount,
        hasMore,
        isLoadingMore,
        searchQuery,
        directSearchMatch,
        isSearchingRemote,
        paginationError,
      ];
}

final pokedexListProvider =
    AsyncNotifierProvider<PokedexListNotifier, PokedexListState>(
  PokedexListNotifier.new,
);

class PokedexListNotifier extends AsyncNotifier<PokedexListState> {
  @override
  Future<PokedexListState> build() async {
    final getPokemonList = ref.read(getPokemonListUseCaseProvider);
    final page = await getPokemonList(
      limit: ApiConstants.defaultPageSize,
      offset: 0,
    );
    return PokedexListState(
      items: page.items,
      totalCount: page.totalCount,
      hasMore: page.hasMore,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null ||
        !current.hasMore ||
        current.isLoadingMore ||
        current.searchQuery.trim().isNotEmpty) {
      return;
    }

    state = AsyncData(
      current.copyWith(isLoadingMore: true, clearPaginationError: true),
    );

    try {
      final getPokemonList = ref.read(getPokemonListUseCaseProvider);
      final page = await getPokemonList(
        limit: ApiConstants.defaultPageSize,
        offset: current.items.length,
      );
      if (!ref.mounted) return;
      state = AsyncData(
        current.copyWith(
          items: [...current.items, ...page.items],
          totalCount: page.totalCount,
          hasMore: page.hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = AsyncData(
        current.copyWith(
          isLoadingMore: false,
          paginationError: e.toString(),
        ),
      );
    }
  }

  Future<void> updateSearch(String query) async {
    final current = state.asData?.value;
    if (current == null) return;

    final trimmed = query.trim().toLowerCase();
    state = AsyncData(
      current.copyWith(
        searchQuery: query,
        clearDirectMatch: true,
        isSearchingRemote: false,
      ),
    );

    if (trimmed.isEmpty) return;

    final hasExactLocalMatch = current.items.any(
      (p) => p.name.toLowerCase() == trimmed || p.id.toString() == trimmed,
    );
    if (hasExactLocalMatch || trimmed.length < 2 && int.tryParse(trimmed) == null) {
      return;
    }

    state = AsyncData(
      current.copyWith(
        searchQuery: query,
        clearDirectMatch: true,
        isSearchingRemote: true,
      ),
    );

    try {
      final getPokemonDetail = ref.read(getPokemonDetailUseCaseProvider);
      final detail = await getPokemonDetail(trimmed);
      if (!ref.mounted) return;
      final latest = state.asData?.value;
      if (latest == null || latest.searchQuery.trim().toLowerCase() != trimmed) {
        return;
      }
      state = AsyncData(
        latest.copyWith(
          directSearchMatch: detail.toSummary(),
          isSearchingRemote: false,
        ),
      );
    } catch (_) {
      if (!ref.mounted) return;
      final latest = state.asData?.value;
      if (latest == null) return;
      state = AsyncData(latest.copyWith(isSearchingRemote: false));
    }
  }
}
