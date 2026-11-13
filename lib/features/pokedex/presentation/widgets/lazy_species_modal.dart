import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/cyber_colors.dart';
import '../../../../core/theme/cyber_text_styles.dart';
import '../../../../core/utils/pokemon_formatters.dart';
import '../../../../core/widgets/cyber_hud_card.dart';
import '../../domain/entities/pokemon_species.dart';

Future<void> showLazySpeciesIntelModal(
  BuildContext context, {
  required PokemonSpeciesInfo species,
  required int currentPokemonId,
  required ValueChanged<int> onSelectVariety,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: CyberColors.deepSpace,
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
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
                '// ARCHIVO GENÉTICO // ${species.generationName.toUpperCase()}',
                style: CyberTextStyles.monoTag,
              ),
              const SizedBox(height: 4),
              Text(
                PokemonFormatters.formatDisplayName(species.name).toUpperCase(),
                style: CyberTextStyles.hudTitle,
              ),
              Text(species.genus, style: CyberTextStyles.bodyMedium),
              const Divider(height: 22),
              if (species.flavorText.isNotEmpty) ...[
                CyberHudCard(
                  accentColor: CyberColors.neonCyan,
                  glowIntensity: 0.08,
                  child: Text(
                    species.flavorText,
                    style: CyberTextStyles.bodyLarge,
                  ),
                ),
                const SizedBox(height: 14),
              ],
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _SpecBadge(
                    label: 'HÁBITAT',
                    value: PokemonFormatters.formatDisplayName(species.habitat),
                  ),
                  _SpecBadge(
                    label: 'CAPTURA',
                    value: '${species.captureRate} / 255',
                  ),
                  _SpecBadge(
                    label: 'FELICIDAD BASE',
                    value: species.baseHappiness.toString(),
                  ),
                  _SpecBadge(
                    label: 'CRECIMIENTO',
                    value: PokemonFormatters.formatDisplayName(
                      species.growthRate,
                    ),
                  ),
                  if (species.eggGroups.isNotEmpty)
                    _SpecBadge(
                      label: 'GRUPO HUEVO',
                      value: species.eggGroups
                          .map(PokemonFormatters.formatDisplayName)
                          .join(', '),
                    ),
                ],
              ),
              if (species.varieties.length > 1) ...[
                const SizedBox(height: 18),
                Text(
                  'FORMAS Y VARIANTES DETECTADAS',
                  style: CyberTextStyles.hudLabel.copyWith(
                    color: CyberColors.cyberYellow,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: species.varieties.map((v) {
                    final active = v.pokemonId == currentPokemonId;
                    return ActionChip(
                      label: Text(
                        PokemonFormatters.formatDisplayName(v.name),
                        style: CyberTextStyles.hudLabel.copyWith(
                          color: active
                              ? CyberColors.voidBlack
                              : CyberColors.textPrimary,
                        ),
                      ),
                      backgroundColor: active
                          ? CyberColors.cyberYellow
                          : CyberColors.panelElevated,
                      side: BorderSide(
                        color: active
                            ? CyberColors.cyberYellow
                            : CyberColors.neonCyan.withValues(alpha: 0.5),
                      ),
                      onPressed: active
                          ? null
                          : () {
                              Navigator.of(context).pop();
                              onSelectVariety(v.pokemonId);
                            },
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

class _SpecBadge extends StatelessWidget {
  const _SpecBadge({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: CyberColors.panelDark,
        border: Border.all(color: CyberColors.gridLine),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: CyberTextStyles.monoTag.copyWith(
              fontSize: 9,
              color: CyberColors.textMuted,
            ),
          ),
          Text(
            value,
            style: CyberTextStyles.bodyMedium.copyWith(
              color: CyberColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
