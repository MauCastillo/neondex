import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/cyber_colors.dart';
import '../../../../core/theme/cyber_text_styles.dart';
import '../../../../core/utils/pokemon_formatters.dart';
import '../../domain/entities/pokemon_detail.dart';
import 'lazy_move_modal.dart';

Future<void> showLazyMovesSheet(
  BuildContext context, {
  required String pokemonName,
  required List<PokemonMoveRef> moves,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: CyberColors.deepSpace,
    builder: (_) => _LazyMovesListSheet(
      pokemonName: pokemonName,
      moves: moves,
    ),
  );
}

class _LazyMovesListSheet extends StatefulWidget {
  const _LazyMovesListSheet({
    required this.pokemonName,
    required this.moves,
  });

  final String pokemonName;
  final List<PokemonMoveRef> moves;

  @override
  State<_LazyMovesListSheet> createState() => _LazyMovesListSheetState();
}

class _LazyMovesListSheetState extends State<_LazyMovesListSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _query.trim().isEmpty
        ? widget.moves
        : widget.moves
            .where(
              (m) => m.name.toLowerCase().contains(_query.trim().toLowerCase()),
            )
            .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.72,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: CyberColors.neonCyan.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '// ARSENAL DE COMBATE // ${widget.moves.length} MOVIMIENTOS',
                  style: CyberTextStyles.monoTag,
                ),
                const SizedBox(height: 2),
                Text(
                  PokemonFormatters.formatDisplayName(widget.pokemonName)
                      .toUpperCase(),
                  style: CyberTextStyles.hudTitle,
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value) => setState(() => _query = value),
                  decoration: const InputDecoration(
                    hintText: 'Filtrar movimiento (ej. thunderbolt)...',
                    prefixIcon: Icon(Icons.search, color: CyberColors.neonCyan),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final move = filtered[index];
                      return ListTile(
                        tileColor: CyberColors.panelDark,
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: CyberColors.neonCyan.withValues(alpha: 0.25),
                          ),
                        ),
                        title: Text(
                          PokemonFormatters.formatDisplayName(move.name),
                          style: CyberTextStyles.hudHeadline.copyWith(fontSize: 14),
                        ),
                        subtitle: Text(
                          move.levelLearnedAt > 0
                              ? 'Nivel ${move.levelLearnedAt} · ${move.learnMethod}'
                              : PokemonFormatters.formatDisplayName(
                                  move.learnMethod,
                                ),
                          style: CyberTextStyles.monoTag.copyWith(
                            fontSize: 11,
                            color: CyberColors.textSecondary,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.bolt,
                          color: CyberColors.cyberYellow,
                        ),
                        onTap: () => showLazyMoveDetailModal(
                          context,
                          moveName: move.name,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
