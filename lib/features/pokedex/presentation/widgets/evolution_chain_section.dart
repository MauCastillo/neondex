import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/cyber_colors.dart';
import '../../../../core/theme/cyber_shapes.dart';
import '../../../../core/theme/cyber_text_styles.dart';
import '../../../../core/utils/pokemon_formatters.dart';
import '../../../../core/widgets/cyber_hud_card.dart';
import '../../../../core/widgets/cyber_network_image.dart';
import '../../domain/entities/evolution_node.dart';

class EvolutionChainSection extends StatelessWidget {
  const EvolutionChainSection({
    super.key,
    required this.rootNode,
    required this.currentSpeciesId,
    required this.onNodeTap,
  });

  final EvolutionNode rootNode;
  final int currentSpeciesId;
  final ValueChanged<EvolutionNode> onNodeTap;

  @override
  Widget build(BuildContext context) {
    return CyberHudCard(
      accentColor: CyberColors.neonCyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'LÍNEA EVOLUTIVA INTERACTIVA',
            style: CyberTextStyles.hudLabel,
          ),
          const SizedBox(height: 6),
          Text(
            rootNode.evolvesTo.isEmpty
                ? 'Espécimen de fase única sin evoluciones registradas.'
                : 'Pulsa cualquier fase evolutiva para abrir su ficha completa.',
            style: CyberTextStyles.bodyMedium.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 14),
          _EvolutionStageTree(
            node: rootNode,
            currentSpeciesId: currentSpeciesId,
            onNodeTap: onNodeTap,
            depth: 0,
          ),
        ],
      ),
    );
  }
}

class _EvolutionStageTree extends StatelessWidget {
  const _EvolutionStageTree({
    required this.node,
    required this.currentSpeciesId,
    required this.onNodeTap,
    required this.depth,
  });

  final EvolutionNode node;
  final int currentSpeciesId;
  final ValueChanged<EvolutionNode> onNodeTap;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final isSingleLinearChain =
        node.evolvesTo.length <= 1 &&
        (node.evolvesTo.isEmpty || node.evolvesTo.first.evolvesTo.length <= 1);

    if (depth == 0 && isSingleLinearChain) {
      final flat = <EvolutionNode>[];
      EvolutionNode? cursor = node;
      while (cursor != null) {
        flat.add(cursor);
        cursor = cursor.evolvesTo.isNotEmpty ? cursor.evolvesTo.first : null;
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var i = 0; i < flat.length; i++) ...[
              if (i > 0)
                _EvolutionArrow(
                  label: flat[i].triggerLabel,
                  horizontal: true,
                ),
              _EvolutionNodeTile(
                node: flat[i],
                isCurrent: flat[i].speciesId == currentSpeciesId,
                onTap: () => onNodeTap(flat[i]),
              ),
            ],
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: _EvolutionNodeTile(
            node: node,
            isCurrent: node.speciesId == currentSpeciesId,
            onTap: () => onNodeTap(node),
          ),
        ),
        if (node.evolvesTo.isNotEmpty) ...[
          const SizedBox(height: 10),
          Center(
            child: Icon(
              Icons.keyboard_double_arrow_down_rounded,
              color: CyberColors.neonCyan.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: node.evolvesTo.map((child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (child.triggerLabel != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: CyberColors.cyberYellow.withValues(alpha: 0.14),
                            border: Border.all(
                              color:
                                  CyberColors.cyberYellow.withValues(alpha: 0.6),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            child.triggerLabel!,
                            style: CyberTextStyles.monoTag.copyWith(
                              fontSize: 10,
                              color: CyberColors.cyberYellow,
                            ),
                          ),
                        ),
                      ),
                    if (child.evolvesTo.isEmpty)
                      _EvolutionNodeTile(
                        node: child,
                        isCurrent: child.speciesId == currentSpeciesId,
                        onTap: () => onNodeTap(child),
                      )
                    else
                      _EvolutionStageTree(
                        node: child,
                        currentSpeciesId: currentSpeciesId,
                        onNodeTap: onNodeTap,
                        depth: depth + 1,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}

class _EvolutionArrow extends StatelessWidget {
  const _EvolutionArrow({
    this.label,
    required this.horizontal,
  });

  final String? label;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null)
            Container(
              constraints: const BoxConstraints(maxWidth: 88),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: CyberColors.cyberYellow.withValues(alpha: 0.14),
                border: Border.all(
                  color: CyberColors.cyberYellow.withValues(alpha: 0.6),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                label!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: CyberTextStyles.monoTag.copyWith(
                  fontSize: 9,
                  color: CyberColors.cyberYellow,
                ),
              ),
            ),
          const SizedBox(height: 4),
          Icon(
            horizontal
                ? Icons.double_arrow_rounded
                : Icons.keyboard_double_arrow_down_rounded,
            color: CyberColors.neonCyan,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _EvolutionNodeTile extends StatelessWidget {
  const _EvolutionNodeTile({
    required this.node,
    required this.isCurrent,
    required this.onTap,
  });

  final EvolutionNode node;
  final bool isCurrent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isCurrent ? CyberColors.cyberYellow : CyberColors.neonCyan;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: CyberShapes.chamfered(cut: 10, borderColor: borderColor),
        child: Container(
          width: 106,
          padding: const EdgeInsets.all(8),
          decoration: CyberShapes.chamferedDecoration(
            backgroundColor: isCurrent
                ? CyberColors.panelElevated
                : CyberColors.deepSpace,
            borderColor: borderColor.withValues(alpha: isCurrent ? 1.0 : 0.45),
            cut: 10,
            borderWidth: isCurrent ? 1.6 : 1.0,
            shadows: isCurrent
                ? CyberColors.neonGlow(
                    CyberColors.cyberYellow,
                    intensity: 0.35,
                    blur: 10,
                  )
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                PokemonFormatters.formatDexNumber(node.speciesId),
                style: CyberTextStyles.monoTag.copyWith(
                  fontSize: 10,
                  color: borderColor,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 58,
                width: 58,
                child: CyberNetworkImage(
                  imageUrl: node.imageUrl,
                  fallbackUrl: node.fallbackImageUrl,
                  accentColor: borderColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                PokemonFormatters.formatDisplayName(node.speciesName),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: CyberTextStyles.hudLabel.copyWith(
                  fontSize: 11,
                  color: CyberColors.textPrimary,
                ),
              ),
              if (isCurrent) ...[
                const SizedBox(height: 2),
                Text(
                  'ACTUAL',
                  style: CyberTextStyles.monoTag.copyWith(
                    fontSize: 9,
                    color: CyberColors.cyberYellow,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
