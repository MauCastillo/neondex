import 'package:equatable/equatable.dart';

import 'pokemon_summary.dart';

class PokemonListPageResult extends Equatable {
  const PokemonListPageResult({
    required this.totalCount,
    required this.hasMore,
    required this.items,
  });

  final int totalCount;
  final bool hasMore;
  final List<PokemonSummary> items;

  @override
  List<Object?> get props => [totalCount, hasMore, items];
}
