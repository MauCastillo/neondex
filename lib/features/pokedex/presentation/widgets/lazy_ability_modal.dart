import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/cyber_colors.dart';
import '../../../../core/theme/cyber_text_styles.dart';
import '../../../../core/utils/pokemon_formatters.dart';
import '../../../../core/widgets/cyber_error_panel.dart';
import '../../../../core/widgets/cyber_loading_indicator.dart';
import '../providers/pokemon_detail_provider.dart';

Future<void> showLazyAbilityModal(
  BuildContext context, {
  required String abilityName,
  required bool isHidden,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: CyberColors.deepSpace,
    builder: (_) => _LazyAbilitySheet(
      abilityName: abilityName,
      isHidden: isHidden,
    ),
  );
}

class _LazyAbilitySheet extends ConsumerWidget {
  const _LazyAbilitySheet({
    required this.abilityName,
    required this.isHidden,
  });

  final String abilityName;
  final bool isHidden;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final abilityAsync = ref.watch(abilityDetailProvider(abilityName));

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
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '// LAZY-LOAD // HABILIDAD',
                          style: CyberTextStyles.monoTag,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          PokemonFormatters.formatDisplayName(abilityName)
                              .toUpperCase(),
                          style: CyberTextStyles.hudTitle,
                        ),
                      ],
                    ),
                  ),
                  if (isHidden)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: CyberColors.neonMagenta.withValues(alpha: 0.2),
                        border: Border.all(color: CyberColors.neonMagenta),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'OCULTA',
                        style: CyberTextStyles.monoTag.copyWith(
                          color: CyberColors.neonMagenta,
                        ),
                      ),
                    ),
                ],
              ),
              const Divider(height: 24),
              abilityAsync.when(
                loading: () => const CyberLoadingIndicator(
                  label: 'DESCARGANDO MÓDULO DE HABILIDAD...',
                ),
                error: (err, _) => CyberErrorPanel(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(abilityDetailProvider(abilityName)),
                ),
                data: (ability) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (ability.shortEffect.isNotEmpty) ...[
                      Text(
                        'EFECTO PRINCIPAL',
                        style: CyberTextStyles.hudLabel,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ability.shortEffect,
                        style: CyberTextStyles.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (ability.effect.isNotEmpty) ...[
                      Text(
                        'DETALLE TÉCNICO',
                        style: CyberTextStyles.hudLabel.copyWith(
                          color: CyberColors.cyberYellow,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ability.effect,
                        style: CyberTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (ability.flavorText.isNotEmpty) ...[
                      Text(
                        'REGISTRO DE CAMPO',
                        style: CyberTextStyles.hudLabel.copyWith(
                          color: CyberColors.neonMagenta,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ability.flavorText,
                        style: CyberTextStyles.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
