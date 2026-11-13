import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/pokemon_type_constants.dart';
import '../../../../core/theme/cyber_colors.dart';
import '../../../../core/theme/cyber_text_styles.dart';
import '../../../../core/utils/pokemon_formatters.dart';
import '../../../../core/widgets/cyber_error_panel.dart';
import '../../../../core/widgets/cyber_hud_card.dart';
import '../../../../core/widgets/cyber_loading_indicator.dart';
import '../providers/pokemon_detail_provider.dart';
import 'type_badge_chip.dart';

Future<void> showLazyMoveDetailModal(
  BuildContext context, {
  required String moveName,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: CyberColors.deepSpace,
    builder: (_) => _LazyMoveDetailSheet(moveName: moveName),
  );
}

class _LazyMoveDetailSheet extends ConsumerWidget {
  const _LazyMoveDetailSheet({required this.moveName});

  final String moveName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moveAsync = ref.watch(moveDetailProvider(moveName));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: 14),
              Text(
                '// LAZY-LOAD // TELEMETRÍA DE MOVIMIENTO',
                style: CyberTextStyles.monoTag,
              ),
              const SizedBox(height: 4),
              Text(
                PokemonFormatters.formatDisplayName(moveName).toUpperCase(),
                style: CyberTextStyles.hudTitle,
              ),
              const Divider(height: 22),
              moveAsync.when(
                loading: () => const CyberLoadingIndicator(
                  label: 'CONSULTANDO POKEAPI /MOVE...',
                ),
                error: (err, _) => CyberErrorPanel(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(moveDetailProvider(moveName)),
                ),
                data: (move) {
                  final typeColor = PokemonTypeConstants.of(move.typeName).color;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          TypeBadgeChip(typeName: move.typeName),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: CyberColors.panelElevated,
                              border: Border.all(color: CyberColors.gridLine),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'CLASE: ${move.damageClass.toUpperCase()}',
                              style: CyberTextStyles.monoTag.copyWith(
                                color: CyberColors.cyberYellow,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _MetricTile(
                              label: 'PODER',
                              value: move.power?.toString() ?? '--',
                              accent: typeColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _MetricTile(
                              label: 'PRECISIÓN',
                              value: move.accuracy != null
                                  ? '${move.accuracy}%'
                                  : '--',
                              accent: CyberColors.neonCyan,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _MetricTile(
                              label: 'PP',
                              value: move.pp?.toString() ?? '--',
                              accent: CyberColors.acidGreen,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _MetricTile(
                              label: 'PRIO',
                              value: move.priority.toString(),
                              accent: CyberColors.neonMagenta,
                            ),
                          ),
                        ],
                      ),
                      if (move.shortEffect.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text('EFECTO DE COMBATE', style: CyberTextStyles.hudLabel),
                        const SizedBox(height: 6),
                        Text(move.shortEffect, style: CyberTextStyles.bodyLarge),
                      ],
                      if (move.flavorText.isNotEmpty &&
                          move.flavorText != move.shortEffect) ...[
                        const SizedBox(height: 12),
                        Text(
                          'DESCRIPCIÓN',
                          style: CyberTextStyles.hudLabel.copyWith(
                            color: CyberColors.neonMagenta,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(move.flavorText, style: CyberTextStyles.bodyMedium),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return CyberHudCard(
      accentColor: accent,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      cut: 8,
      glowIntensity: 0.08,
      showCornerBrackets: false,
      child: Column(
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: CyberTextStyles.monoTag.copyWith(fontSize: 10, color: accent),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: CyberTextStyles.hudHeadline.copyWith(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
