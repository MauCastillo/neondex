import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/pokemon_type_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/cyber_colors.dart';
import '../../../../core/theme/cyber_shapes.dart';
import '../../../../core/theme/cyber_text_styles.dart';
import '../../../../core/utils/pokemon_formatters.dart';
import '../../../../core/widgets/cyber_error_panel.dart';
import '../../../../core/widgets/cyber_hud_card.dart';
import '../../../../core/widgets/cyber_loading_indicator.dart';
import '../../../../core/widgets/cyber_network_image.dart';
import '../../../../core/widgets/cyber_section_header.dart';
import '../../../favorites/presentation/widgets/cyber_favorite_star.dart';
import '../../domain/entities/pokemon_summary.dart';
import '../providers/pokemon_detail_provider.dart';
import '../widgets/evolution_chain_section.dart';
import '../widgets/lazy_ability_modal.dart';
import '../widgets/lazy_moves_sheet.dart';
import '../widgets/lazy_species_modal.dart';
import '../widgets/stat_radar_bars.dart';
import '../widgets/type_badge_chip.dart';
import '../widgets/type_effectiveness_matrix.dart';

class PokemonDetailPage extends ConsumerStatefulWidget {
  const PokemonDetailPage({
    super.key,
    required this.pokemonId,
    this.initialSummary,
    this.heroTag,
  });

  final int pokemonId;
  final PokemonSummary? initialSummary;
  final String? heroTag;

  @override
  ConsumerState<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends ConsumerState<PokemonDetailPage> {
  bool _showShiny = false;

  void _openPokemon(int targetId) {
    if (targetId == widget.pokemonId) return;
    Navigator.of(context).pushNamed(AppRoutes.pokemonDetail(targetId));
  }

  void _openTypeList(String typeName) {
    Navigator.of(context).pushNamed(AppRoutes.typeList(typeName));
  }

  @override
  Widget build(BuildContext context) {
    final bundleAsync = ref.watch(pokemonDetailProvider(widget.pokemonId));
    final summaryForFav = bundleAsync.asData?.value.detail.toSummary() ??
        widget.initialSummary ??
        PokemonSummary(
          id: widget.pokemonId,
          name: 'pokemon-${widget.pokemonId}',
        );

    final primaryType = bundleAsync.asData?.value.detail.types.isNotEmpty == true
        ? bundleAsync.asData!.value.detail.types.first
        : null;
    final accentColor = primaryType != null
        ? PokemonTypeConstants.of(primaryType).color
        : CyberColors.neonCyan;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          bundleAsync.asData != null
              ? '${PokemonFormatters.formatDexNumber(bundleAsync.asData!.value.detail.id)} ${PokemonFormatters.formatDisplayName(bundleAsync.asData!.value.detail.name).toUpperCase()}'
              : PokemonFormatters.formatDexNumber(widget.pokemonId),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CyberFavoriteStarButton(pokemon: summaryForFav),
          ),
        ],
      ),
      body: SafeArea(
        child: bundleAsync.when(
          loading: () => const CyberLoadingIndicator(
            label: 'DECODIFICANDO FICHA GENÉTICA...',
          ),
          error: (err, _) => CyberErrorPanel(
            message: err.toString(),
            onRetry: () =>
                ref.invalidate(pokemonDetailProvider(widget.pokemonId)),
          ),
          data: (bundle) {
            final detail = bundle.detail;
            final species = bundle.species;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HeroDisplayCard(
                    detail: detail,
                    speciesGenus: species?.genus,
                    isLegendary: species?.isLegendary ?? false,
                    isMythical: species?.isMythical ?? false,
                    accentColor: accentColor,
                    showShiny: _showShiny,
                    heroTag: widget.heroTag,
                    onToggleShiny: () =>
                        setState(() => _showShiny = !_showShiny),
                    onTypeTap: _openTypeList,
                  ),
                  const SizedBox(height: 16),
                  if (species != null && species.flavorText.isNotEmpty) ...[
                    CyberHudCard(
                      accentColor: accentColor,
                      glowIntensity: 0.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'REGISTRO BIO-DIGITAL',
                                  style: CyberTextStyles.hudLabel
                                      .copyWith(color: accentColor),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () => showLazySpeciesIntelModal(
                                  context,
                                  species: species,
                                  currentPokemonId: detail.id,
                                  onSelectVariety: _openPokemon,
                                ),
                                icon: const Icon(Icons.biotech, size: 16),
                                label: const Text('INTEL / FORMAS'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            species.flavorText,
                            style: CyberTextStyles.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  _PhysicalSpecsRow(detail: detail, accentColor: accentColor),
                  const SizedBox(height: 16),
                  StatRadarBars(
                    stats: detail.stats,
                    baseStatTotal: detail.baseStatTotal,
                    accentColor: accentColor,
                  ),
                  const SizedBox(height: 16),
                  CyberHudCard(
                    accentColor: CyberColors.cyberYellow,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const CyberSectionHeader(
                          title: 'HABILIDADES Y ARSENAL',
                          codeTag: 'LAZY-LOAD MODALS',
                          accentColor: CyberColors.cyberYellow,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Toca una habilidad o el arsenal para consultar su descripción detallada en vivo:',
                          style: CyberTextStyles.bodyMedium.copyWith(fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: detail.abilities.map((ab) {
                            return ActionChip(
                              avatar: Icon(
                                ab.isHidden
                                    ? Icons.visibility_off
                                    : Icons.memory,
                                size: 16,
                                color: ab.isHidden
                                    ? CyberColors.neonMagenta
                                    : CyberColors.cyberYellow,
                              ),
                              label: Text(
                                ab.isHidden
                                    ? '${PokemonFormatters.formatDisplayName(ab.name)} (Oculta)'
                                    : PokemonFormatters.formatDisplayName(ab.name),
                                style: CyberTextStyles.hudLabel.copyWith(
                                  color: CyberColors.textPrimary,
                                ),
                              ),
                              backgroundColor: CyberColors.panelElevated,
                              side: BorderSide(
                                color: ab.isHidden
                                    ? CyberColors.neonMagenta
                                    : CyberColors.cyberYellow
                                        .withValues(alpha: 0.7),
                              ),
                              onPressed: () => showLazyAbilityModal(
                                context,
                                abilityName: ab.name,
                                isHidden: ab.isHidden,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () => showLazyMovesSheet(
                            context,
                            pokemonName: detail.name,
                            moves: detail.moves,
                          ),
                          icon: const Icon(Icons.flash_on_rounded),
                          label: Text(
                            'INSPECCIONAR ${detail.moves.length} MOVIMIENTOS',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TypeEffectivenessMatrix(
                    effectiveness: bundle.typeEffectiveness,
                    onTypeTap: _openTypeList,
                  ),
                  if (bundle.evolutionChain != null) ...[
                    const SizedBox(height: 16),
                    EvolutionChainSection(
                      rootNode: bundle.evolutionChain!,
                      currentSpeciesId: detail.speciesId,
                      onNodeTap: (node) => _openPokemon(node.speciesId),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeroDisplayCard extends StatelessWidget {
  const _HeroDisplayCard({
    required this.detail,
    required this.speciesGenus,
    required this.isLegendary,
    required this.isMythical,
    required this.accentColor,
    required this.showShiny,
    required this.heroTag,
    required this.onToggleShiny,
    required this.onTypeTap,
  });

  final dynamic detail;
  final String? speciesGenus;
  final bool isLegendary;
  final bool isMythical;
  final Color accentColor;
  final bool showShiny;
  final String? heroTag;
  final VoidCallback onToggleShiny;
  final ValueChanged<String> onTypeTap;

  @override
  Widget build(BuildContext context) {
    final imageUrl = showShiny ? detail.shinySpriteUrl : detail.spriteUrl;

    return CyberHudCard(
      accentColor: accentColor,
      glowIntensity: 0.25,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      PokemonFormatters.formatDexNumber(detail.id as int),
                      style: CyberTextStyles.monoTag.copyWith(color: accentColor),
                    ),
                    if (speciesGenus != null && speciesGenus!.isNotEmpty)
                      Text(
                        speciesGenus!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: CyberTextStyles.bodyMedium,
                      ),
                  ],
                ),
              ),
              if (isLegendary || isMythical)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: CyberShapes.chamferedDecoration(
                    backgroundColor:
                        CyberColors.cyberYellow.withValues(alpha: 0.18),
                    borderColor: CyberColors.cyberYellow,
                    cut: 6,
                  ),
                  child: Text(
                    isMythical ? 'MÍTICO' : 'LEGENDARIO',
                    style: CyberTextStyles.monoTag.copyWith(
                      fontSize: 10,
                      color: CyberColors.cyberYellow,
                    ),
                  ),
                ),
              FilterChip(
                selected: showShiny,
                onSelected: (_) => onToggleShiny(),
                avatar: Icon(
                  Icons.auto_awesome,
                  size: 16,
                  color: showShiny
                      ? CyberColors.voidBlack
                      : CyberColors.cyberYellow,
                ),
                label: Text(
                  'SHINY',
                  style: CyberTextStyles.hudLabel.copyWith(
                    color: showShiny
                        ? CyberColors.voidBlack
                        : CyberColors.cyberYellow,
                  ),
                ),
                selectedColor: CyberColors.cyberYellow,
                backgroundColor: CyberColors.panelElevated,
                side: const BorderSide(color: CyberColors.cyberYellow),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 195,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        accentColor.withValues(alpha: 0.30),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                if (heroTag != null)
                  Hero(
                    tag: heroTag!,
                    child: CyberNetworkImage(
                      imageUrl: imageUrl as String,
                      fallbackUrl: detail.fallbackSpriteUrl as String,
                      height: 180,
                      width: 180,
                      accentColor: accentColor,
                    ),
                  )
                else
                  CyberNetworkImage(
                    imageUrl: imageUrl as String,
                    fallbackUrl: detail.fallbackSpriteUrl as String,
                    height: 180,
                    width: 180,
                    accentColor: accentColor,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            PokemonFormatters.formatDisplayName(detail.name as String)
                .toUpperCase(),
            textAlign: TextAlign.center,
            style: CyberTextStyles.hudTitle.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: (detail.types as List<String>)
                .map(
                  (t) => TypeBadgeChip(
                    typeName: t,
                    onTap: () => onTypeTap(t),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _PhysicalSpecsRow extends StatelessWidget {
  const _PhysicalSpecsRow({
    required this.detail,
    required this.accentColor,
  });

  final dynamic detail;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SpecCard(
            label: 'ALTURA',
            value: PokemonFormatters.formatHeightMeters(
              detail.heightDecimeters as int,
            ),
            icon: Icons.height,
            accentColor: accentColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SpecCard(
            label: 'PESO',
            value: PokemonFormatters.formatWeightKg(
              detail.weightHectograms as int,
            ),
            icon: Icons.scale,
            accentColor: CyberColors.neonMagenta,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SpecCard(
            label: 'EXP BASE',
            value: '${detail.baseExperience}',
            icon: Icons.bolt,
            accentColor: CyberColors.cyberYellow,
          ),
        ),
      ],
    );
  }
}

class _SpecCard extends StatelessWidget {
  const _SpecCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return CyberHudCard(
      accentColor: accentColor,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      cut: 10,
      glowIntensity: 0.1,
      showCornerBrackets: false,
      child: Column(
        children: [
          Icon(icon, size: 18, color: accentColor),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: CyberTextStyles.monoTag.copyWith(
              fontSize: 10,
              color: CyberColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: CyberTextStyles.hudHeadline.copyWith(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
