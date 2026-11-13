import 'package:material_ui/material_ui.dart';

import '../../../../core/constants/pokemon_type_constants.dart';
import '../../../../core/theme/cyber_colors.dart';
import '../../../../core/theme/cyber_text_styles.dart';
import '../../../../core/widgets/cyber_hud_card.dart';
import '../../../pokedex/domain/entities/pokemon_summary.dart';
import '../../../pokedex/presentation/widgets/cyber_pokemon_card.dart';
import '../../../pokedex/presentation/widgets/type_badge_chip.dart';
import '../../domain/entities/weather_encounter_recommendation.dart';

class WeatherEncounterPanel extends StatelessWidget {
  const WeatherEncounterPanel({
    super.key,
    required this.recommendations,
    required this.sampleEncounters,
    required this.onTypeTap,
    required this.onPokemonTap,
  });

  final List<WeatherEncounterRecommendation> recommendations;
  final List<PokemonSummary> sampleEncounters;
  final ValueChanged<String> onTypeTap;
  final ValueChanged<PokemonSummary> onPokemonTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CyberHudCard(
          accentColor: CyberColors.acidGreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'PROBABILIDAD DE ENCUENTROS POR CLIMA',
                style: CyberTextStyles.hudLabel.copyWith(
                  color: CyberColors.acidGreen,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Según las condiciones atmosféricas actuales, estos tipos aparecen con mayor frecuencia. Pulsa cualquiera para ver su catálogo:',
                style: CyberTextStyles.bodyMedium.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 12),
              ...recommendations.map((rec) {
                final meta = PokemonTypeConstants.of(rec.typeName);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => onTypeTap(rec.typeName),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: CyberColors.deepSpace,
                        border: Border.all(
                          color: meta.color.withValues(alpha: 0.45),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                TypeBadgeChip(
                                  typeName: rec.typeName,
                                  compact: true,
                                  onTap: () => onTypeTap(rec.typeName),
                                ),
                                Text(
                                  '${rec.affinityPercent}% AFINIDAD',
                                  style: CyberTextStyles.monoTag.copyWith(
                                    color: meta.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: rec.affinityPercent / 100.0,
                            minHeight: 6,
                            backgroundColor: CyberColors.voidBlack,
                            color: meta.color,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            rec.reason,
                            style: CyberTextStyles.bodyMedium.copyWith(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        if (sampleEncounters.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            '// AVISTAMIENTOS PROBABLES EN TU ZONA',
            style: CyberTextStyles.monoTag.copyWith(
              color: CyberColors.cyberYellow,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 192,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: sampleEncounters.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final pokemon = sampleEncounters[index];
                return SizedBox(
                  width: 148,
                  child: CyberPokemonCard(
                    pokemon: pokemon,
                    onTap: () => onPokemonTap(pokemon),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
