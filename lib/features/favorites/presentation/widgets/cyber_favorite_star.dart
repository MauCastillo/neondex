import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/cyber_colors.dart';
import '../../../pokedex/domain/entities/pokemon_summary.dart';
import '../providers/favorites_provider.dart';

class CyberFavoriteStarButton extends ConsumerWidget {
  const CyberFavoriteStarButton({
    super.key,
    required this.pokemon,
    this.size = 24,
    this.compact = false,
  });

  final PokemonSummary pokemon;
  final double size;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(isPokemonFavoriteProvider(pokemon.id));

    return Material(
      color: Colors.transparent,
      child: InkResponse(
        onTap: () => ref.read(favoritesProvider.notifier).toggle(pokemon),
        radius: compact ? 18 : 22,
        splashColor: CyberColors.cyberYellow.withValues(alpha: 0.28),
        child: Container(
          padding: EdgeInsets.all(compact ? 4 : 6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFav
                ? CyberColors.cyberYellow.withValues(alpha: 0.14)
                : CyberColors.deepSpace.withValues(alpha: 0.6),
            border: Border.all(
              color: isFav
                  ? CyberColors.cyberYellow
                  : CyberColors.gridLine,
              width: 1,
            ),
            boxShadow: isFav
                ? CyberColors.neonGlow(
                    CyberColors.cyberYellow,
                    intensity: 0.45,
                    blur: 10,
                  )
                : null,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Icon(
              isFav ? Icons.star_rounded : Icons.star_outline_rounded,
              key: ValueKey(isFav),
              size: size,
              color: isFav ? CyberColors.cyberYellow : CyberColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
