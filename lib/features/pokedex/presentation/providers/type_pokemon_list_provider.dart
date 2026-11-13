import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/pokemon_summary.dart';
import '../../domain/entities/type_detail.dart';
import 'pokedex_usecase_providers.dart';

class TypePokemonListState extends Equatable {
  const TypePokemonListState({
    required this.typeDetail,
    required this.visibleItems,
    required this.hasMore,
  });

  final TypeDetail typeDetail;
  final List<PokemonSummary> visibleItems;
  final bool hasMore;

  int get totalCount => typeDetail.pokemonList.length;

  TypePokemonListState copyWith({
    TypeDetail? typeDetail,
    List<PokemonSummary>? visibleItems,
    bool? hasMore,
  }) {
    return TypePokemonListState(
      typeDetail: typeDetail ?? this.typeDetail,
      visibleItems: visibleItems ?? this.visibleItems,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [typeDetail, visibleItems, hasMore];
}

final typePokemonListProvider = AsyncNotifierProvider.autoDispose
    .family<TypePokemonListNotifier, TypePokemonListState, String>(
  TypePokemonListNotifier.new,
);

class TypePokemonListNotifier extends AsyncNotifier<TypePokemonListState> {
  TypePokemonListNotifier(this.typeName);

  final String typeName;

  @override
  Future<TypePokemonListState> build() async {
    final getTypeDetail = ref.read(getTypeDetailUseCaseProvider);
    final detail = await getTypeDetail(typeName);
    final initial = detail.pokemonList
        .take(ApiConstants.defaultPageSize)
        .toList();
    return TypePokemonListState(
      typeDetail: detail,
      visibleItems: initial,
      hasMore: initial.length < detail.pokemonList.length,
    );
  }

  void loadMore() {
    final current = state.asData?.value;
    if (current == null || !current.hasMore) return;

    final all = current.typeDetail.pokemonList;
    final nextCount = (current.visibleItems.length + ApiConstants.defaultPageSize)
        .clamp(0, all.length);

    state = AsyncData(
      current.copyWith(
        visibleItems: all.sublist(0, nextCount),
        hasMore: nextCount < all.length,
      ),
    );
  }
}
