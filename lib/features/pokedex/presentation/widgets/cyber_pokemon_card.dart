import 'package:material_ui/material_ui.dart';

import '../../../../core/constants/pokemon_type_constants.dart';
import '../../../../core/theme/cyber_colors.dart';
import '../../../../core/theme/cyber_text_styles.dart';
import '../../../../core/utils/pokemon_formatters.dart';
import '../../../../core/widgets/cyber_hud_card.dart';
import '../../../../core/widgets/cyber_network_image.dart';
import '../../../favorites/presentation/widgets/cyber_favorite_star.dart';
import '../../domain/entities/pokemon_summary.dart';

class CyberPokemonCard extends StatelessWidget {
  const CyberPokemonCard({
    super.key,
    required this.pokemon,
    required this.onTap,
    this.heroTagPrefix,
  });

  final PokemonSummary pokemon;
  final VoidCallback onTap;
  final String? heroTagPrefix;

  @override
  Widget build(BuildContext context) {
    final accentColor = pokemon.types.isNotEmpty
        ? PokemonTypeConstants.of(pokemon.types.first).color
        : CyberColors.neonCyan;

    return CyberHudCard(
      accentColor: accentColor,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      cut: 12,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  PokemonFormatters.formatDexNumber(pokemon.id),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CyberTextStyles.monoTag.copyWith(
                    color: accentColor,
                    fontSize: 11,
                  ),
                ),
              ),
              CyberFavoriteStarButton(
                pokemon: pokemon,
                size: 16,
                compact: true,
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          accentColor.withValues(alpha: 0.22),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  if (heroTagPrefix != null)
                    Hero(
                      tag: '$heroTagPrefix-${pokemon.id}',
                      child: CyberNetworkImage(
                        imageUrl: pokemon.resolvedImageUrl,
                        fallbackUrl: pokemon.resolvedFallbackImageUrl,
                        accentColor: accentColor,
                      ),
                    )
                  else
                    CyberNetworkImage(
                      imageUrl: pokemon.resolvedImageUrl,
                      fallbackUrl: pokemon.resolvedFallbackImageUrl,
                      accentColor: accentColor,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            PokemonFormatters.formatDisplayName(pokemon.name),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: CyberTextStyles.hudHeadline.copyWith(
              fontSize: 13,
              letterSpacing: 0.7,
            ),
          ),
          if (pokemon.types.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              pokemon.types.map((t) => PokemonTypeConstants.of(t).code).join(' · '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: CyberTextStyles.monoTag.copyWith(
                fontSize: 10,
                color: CyberColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
