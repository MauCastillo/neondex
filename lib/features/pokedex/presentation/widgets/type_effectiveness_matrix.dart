import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/cyber_colors.dart';
import '../../../../core/theme/cyber_text_styles.dart';
import '../../../../core/widgets/cyber_hud_card.dart';
import '../../domain/entities/type_effectiveness.dart';
import 'type_badge_chip.dart';

class TypeEffectivenessMatrix extends StatefulWidget {
  const TypeEffectivenessMatrix({
    super.key,
    required this.effectiveness,
    required this.onTypeTap,
  });

  final TypeEffectiveness effectiveness;
  final ValueChanged<String> onTypeTap;

  @override
  State<TypeEffectivenessMatrix> createState() =>
      _TypeEffectivenessMatrixState();
}

class _TypeEffectivenessMatrixState extends State<TypeEffectivenessMatrix> {
  bool _showDefense = true;

  @override
  Widget build(BuildContext context) {
    final eff = widget.effectiveness;

    return CyberHudCard(
      accentColor: _showDefense ? CyberColors.neonMagenta : CyberColors.acidGreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Text(
                _showDefense
                    ? 'MATRIZ DEFENSIVA // DAÑO RECIBIDO'
                    : 'MATRIZ OFENSIVA // DAÑO INFLIGIDO',
                style: CyberTextStyles.hudLabel.copyWith(
                  color: _showDefense
                      ? CyberColors.neonMagenta
                      : CyberColors.acidGreen,
                ),
              ),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('DEFENSA')),
                  ButtonSegment(value: false, label: Text('ATAQUE')),
                ],
                selected: {_showDefense},
                onSelectionChanged: (selection) {
                  setState(() => _showDefense = selection.first);
                },
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  textStyle: WidgetStatePropertyAll(
                    CyberTextStyles.hudLabel.copyWith(fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Pulsa cualquier tipo para explorar todos los Pokémon de ese elemento.',
            style: CyberTextStyles.bodyMedium.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 12),
          if (_showDefense) ...[
            _EffectivenessGroup(
              title: 'DÉBIL CONTRA (2x / 4x)',
              accentColor: CyberColors.alertRed,
              entries: eff.defensiveWeaknesses,
              emptyText: 'Sin debilidades registradas.',
              onTypeTap: widget.onTypeTap,
            ),
            const SizedBox(height: 12),
            _EffectivenessGroup(
              title: 'RESISTE CONTRA (1/2x / 1/4x)',
              accentColor: CyberColors.acidGreen,
              entries: eff.defensiveResistances,
              emptyText: 'Sin resistencias elementales.',
              onTypeTap: widget.onTypeTap,
            ),
            if (eff.defensiveImmunities.isNotEmpty) ...[
              const SizedBox(height: 12),
              _EffectivenessGroup(
                title: 'INMUNE A (0x)',
                accentColor: CyberColors.neonCyan,
                entries: eff.defensiveImmunities,
                emptyText: '',
                onTypeTap: widget.onTypeTap,
              ),
            ],
          ] else ...[
            _EffectivenessGroup(
              title: 'FUERTE CONTRA (2x STAB)',
              accentColor: CyberColors.acidGreen,
              entries: eff.offensiveSuperEffective,
              emptyText: 'Sin ventajas directas 2x.',
              onTypeTap: widget.onTypeTap,
            ),
            const SizedBox(height: 12),
            _EffectivenessGroup(
              title: 'POCO EFICAZ CONTRA (1/2x)',
              accentColor: CyberColors.warningAmber,
              entries: eff.offensiveNotVeryEffective,
              emptyText: 'Cobertura neutra o superior.',
              onTypeTap: widget.onTypeTap,
            ),
            if (eff.offensiveNoEffect.isNotEmpty) ...[
              const SizedBox(height: 12),
              _EffectivenessGroup(
                title: 'SIN EFECTO CONTRA (0x)',
                accentColor: CyberColors.alertRed,
                entries: eff.offensiveNoEffect,
                emptyText: '',
                onTypeTap: widget.onTypeTap,
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _EffectivenessGroup extends StatelessWidget {
  const _EffectivenessGroup({
    required this.title,
    required this.accentColor,
    required this.entries,
    required this.emptyText,
    required this.onTypeTap,
  });

  final String title;
  final Color accentColor;
  final List<TypeMultiplierEntry> entries;
  final String emptyText;
  final ValueChanged<String> onTypeTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: CyberTextStyles.monoTag.copyWith(
            fontSize: 11,
            color: accentColor,
          ),
        ),
        const SizedBox(height: 6),
        if (entries.isEmpty)
          Text(
            emptyText,
            style: CyberTextStyles.bodyMedium.copyWith(
              color: CyberColors.textMuted,
              fontSize: 13,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: entries
                .map(
                  (e) => TypeBadgeChip(
                    typeName: e.typeName,
                    multiplierLabel: e.formattedMultiplier,
                    compact: true,
                    onTap: () => onTypeTap(e.typeName),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
