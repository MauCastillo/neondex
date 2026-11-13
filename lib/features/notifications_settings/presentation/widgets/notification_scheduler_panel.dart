import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/cyber_colors.dart';
import '../../../../core/theme/cyber_shapes.dart';
import '../../../../core/theme/cyber_text_styles.dart';
import '../../../../core/utils/pokemon_formatters.dart';
import '../../../../core/widgets/cyber_hud_card.dart';
import '../../../../core/widgets/cyber_loading_indicator.dart';
import '../../../../core/widgets/cyber_section_header.dart';
import '../../domain/entities/recommended_pokemon_alert.dart';
import '../providers/notification_settings_provider.dart';

class NotificationSchedulerPanel extends ConsumerStatefulWidget {
  const NotificationSchedulerPanel({super.key});

  @override
  ConsumerState<NotificationSchedulerPanel> createState() =>
      _NotificationSchedulerPanelState();
}

class _NotificationSchedulerPanelState
    extends ConsumerState<NotificationSchedulerPanel> {
  static const List<int> _presetMinutes = [1, 5, 15, 30, 60, 180, 360, 1440];

  bool _sendingTest = false;
  RecommendedPokemonAlert? _lastDispatched;

  String _formatInterval(int minutes) {
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final rem = minutes % 60;
    if (rem == 0) return '$hours h';
    return '$hours h $rem m';
  }

  Future<void> _sendImmediateTest() async {
    setState(() => _sendingTest = true);
    try {
      final alert =
          await ref.read(notificationSettingsProvider.notifier).triggerTest();
      if (!mounted) return;
      setState(() => _lastDispatched = alert);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Notificación enviada: ${PokemonFormatters.formatDexNumber(alert.id)} ${PokemonFormatters.formatDisplayName(alert.name)}',
          ),
          action: SnackBarAction(
            label: 'VER FICHA',
            textColor: CyberColors.neonCyan,
            onPressed: () => Navigator.of(context).pushNamed(
              AppRoutes.pokemonDetail(alert.id),
            ),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar notificación: $e')),
      );
    } finally {
      if (mounted) setState(() => _sendingTest = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(notificationSettingsProvider);

    return CyberHudCard(
      accentColor: CyberColors.neonMagenta,
      child: settingsAsync.when(
        loading: () => const CyberLoadingIndicator(
          label: 'CARGANDO PLANIFICADOR...',
          color: CyberColors.neonMagenta,
        ),
        error: (err, _) => Text(
          'Error cargando configuración: $err',
          style: CyberTextStyles.bodyMedium.copyWith(color: CyberColors.alertRed),
        ),
        data: (settings) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CyberSectionHeader(
                title: 'NOTIFICACIONES Y DEEP LINK',
                codeTag: 'ALERTAS PERIÓDICAS POKÉMON',
                accentColor: CyberColors.neonMagenta,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Recomendaciones Automáticas',
                  style: CyberTextStyles.hudHeadline.copyWith(fontSize: 15),
                ),
                subtitle: Text(
                  settings.enabled
                      ? 'Activo cada ${_formatInterval(settings.intervalMinutes)} (${settings.usesBackgroundWorkManager ? "WorkManager" : "Modo Demo Rápido"})'
                      : 'Desactivado. Activa para recibir encuentros aleatorios.',
                  style: CyberTextStyles.bodyMedium.copyWith(fontSize: 13),
                ),
                value: settings.enabled,
                activeThumbColor: CyberColors.neonCyan,
                onChanged: (value) {
                  ref.read(notificationSettingsProvider.notifier).updateSchedule(
                        enabled: value,
                        intervalMinutes: settings.intervalMinutes,
                      );
                },
              ),
              const Divider(height: 20),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      'INTERVALO PROGRAMADO',
                      style: CyberTextStyles.hudLabel.copyWith(
                        color: CyberColors.cyberYellow,
                      ),
                    ),
                    Text(
                      _formatInterval(settings.intervalMinutes),
                      style: CyberTextStyles.monoValue.copyWith(
                        color: CyberColors.cyberYellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _presetMinutes.map((mins) {
                  final selected = settings.intervalMinutes == mins;
                  return ChoiceChip(
                    label: Text(
                      mins < 15 ? '${_formatInterval(mins)} (Demo)' : _formatInterval(mins),
                      style: CyberTextStyles.monoTag.copyWith(
                        fontSize: 11,
                        color: selected
                            ? CyberColors.voidBlack
                            : CyberColors.textPrimary,
                      ),
                    ),
                    selected: selected,
                    selectedColor: CyberColors.neonCyan,
                    backgroundColor: CyberColors.deepSpace,
                    side: BorderSide(
                      color: selected
                          ? CyberColors.neonCyan
                          : CyberColors.gridLine,
                    ),
                    onSelected: (_) {
                      ref
                          .read(notificationSettingsProvider.notifier)
                          .updateSchedule(
                            enabled: settings.enabled,
                            intervalMinutes: mins,
                          );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Slider(
                value: settings.intervalMinutes.clamp(1, 180).toDouble(),
                min: 1,
                max: 180,
                divisions: 179,
                activeColor: CyberColors.neonCyan,
                inactiveColor: CyberColors.gridLine,
                label: _formatInterval(settings.intervalMinutes.clamp(1, 180)),
                onChanged: (val) {
                  ref
                      .read(notificationSettingsProvider.notifier)
                      .updateSchedule(
                        enabled: settings.enabled,
                        intervalMinutes: val.round(),
                      );
                },
              ),
              Text(
                'Nota Android: intervalos ≥ 15 min usan WorkManager persistente en segundo plano; intervalos < 15 min ejecutan alarma inexacta y temporizador activo para pruebas rápidas.',
                style: CyberTextStyles.bodyMedium.copyWith(
                  fontSize: 12,
                  color: CyberColors.textMuted,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _sendingTest ? null : _sendImmediateTest,
                style: FilledButton.styleFrom(
                  backgroundColor: CyberColors.neonMagenta,
                  foregroundColor: CyberColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: _sendingTest
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: CyberColors.textPrimary,
                        ),
                      )
                    : const Icon(Icons.notifications_active_rounded),
                label: Text(
                  _sendingTest
                      ? 'GENERANDO ALERTA...'
                      : 'PROBAR NOTIFICACIÓN AHORA',
                ),
              ),
              if (_lastDispatched != null ||
                  settings.lastRecommendedId != null) ...[
                const SizedBox(height: 12),
                _LastDispatchBanner(
                  pokemonId:
                      _lastDispatched?.id ?? settings.lastRecommendedId!,
                  pokemonName:
                      _lastDispatched?.name ?? settings.lastRecommendedName ?? '',
                  statsLine: _lastDispatched != null
                      ? _lastDispatched!.notificationBody
                      : 'Última recomendación generada. Toca para inspeccionar su ficha.',
                  onInspect: () => Navigator.of(context).pushNamed(
                    AppRoutes.pokemonDetail(
                      _lastDispatched?.id ?? settings.lastRecommendedId!,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _LastDispatchBanner extends StatelessWidget {
  const _LastDispatchBanner({
    required this.pokemonId,
    required this.pokemonName,
    required this.statsLine,
    required this.onInspect,
  });

  final int pokemonId;
  final String pokemonName;
  final String statsLine;
  final VoidCallback onInspect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: CyberShapes.chamferedDecoration(
        backgroundColor: CyberColors.deepSpace,
        borderColor: CyberColors.acidGreen.withValues(alpha: 0.7),
        cut: 8,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.bolt_rounded,
            color: CyberColors.acidGreen,
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${PokemonFormatters.formatDexNumber(pokemonId)} ${PokemonFormatters.formatDisplayName(pokemonName).toUpperCase()}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CyberTextStyles.hudLabel.copyWith(
                    color: CyberColors.acidGreen,
                  ),
                ),
                Text(
                  statsLine,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: CyberTextStyles.bodyMedium.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onInspect,
            child: const Text('ABRIR'),
          ),
        ],
      ),
    );
  }
}
