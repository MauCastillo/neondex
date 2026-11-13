import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/cyber_colors.dart';
import '../../../../core/theme/cyber_text_styles.dart';
import '../../../../core/widgets/cyber_error_panel.dart';
import '../../../../core/widgets/cyber_hud_card.dart';
import '../../../../core/widgets/cyber_loading_indicator.dart';
import '../../../../core/widgets/cyber_section_header.dart';
import '../../domain/entities/android_permission_item.dart';
import '../providers/permissions_diagnostics_provider.dart';

class PermissionDiagnosticsPanel extends ConsumerWidget {
  const PermissionDiagnosticsPanel({super.key});

  (String, Color, IconData) _statusStyle(DiagnosticPermissionStatus status) {
    switch (status) {
      case DiagnosticPermissionStatus.granted:
        return ('CONCEDIDO', CyberColors.acidGreen, Icons.verified_user_rounded);
      case DiagnosticPermissionStatus.denied:
        return ('DENEGADO', CyberColors.alertRed, Icons.gpp_bad_rounded);
      case DiagnosticPermissionStatus.permanentlyDenied:
        return ('BLOQUEADO', CyberColors.neonMagenta, Icons.lock_rounded);
      case DiagnosticPermissionStatus.disabled:
        return ('DESACTIVADO', CyberColors.warningAmber, Icons.power_off_rounded);
      case DiagnosticPermissionStatus.restricted:
        return ('RESTRINGIDO', CyberColors.warningAmber, Icons.shield_outlined);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diagAsync = ref.watch(permissionsDiagnosticsProvider);

    return CyberHudCard(
      accentColor: CyberColors.neonCyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CyberSectionHeader(
            title: 'DIAGNÓSTICO DE PERMISOS ANDROID',
            codeTag: 'MONITOR EN TIEMPO REAL',
            accentColor: CyberColors.neonCyan,
            trailing: IconButton(
              onPressed: () =>
                  ref.read(permissionsDiagnosticsProvider.notifier).refresh(),
              icon: const Icon(Icons.sync_rounded, color: CyberColors.neonCyan),
              tooltip: 'Reverificar permisos',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Estado actual de los permisos requeridos por el sistema operativo para GPS, clima y notificaciones locales.',
            style: CyberTextStyles.bodyMedium.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 14),
          diagAsync.when(
            loading: () => const CyberLoadingIndicator(
              label: 'AUDITANDO PERMISOS DEL SISTEMA...',
            ),
            error: (err, _) => CyberErrorPanel(
              message: err.toString(),
              onRetry: () =>
                  ref.read(permissionsDiagnosticsProvider.notifier).refresh(),
            ),
            data: (items) {
              final grantedCount = items.where((i) => i.isOk).length;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: CyberColors.deepSpace,
                      border: Border.all(
                        color: grantedCount == items.length
                            ? CyberColors.acidGreen
                            : CyberColors.warningAmber,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'ESTADO GLOBAL: $grantedCount / ${items.length} MÓDULOS OPERATIVOS',
                      style: CyberTextStyles.monoTag.copyWith(
                        color: grantedCount == items.length
                            ? CyberColors.acidGreen
                            : CyberColors.warningAmber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...items.map((item) {
                    final (label, color, icon) = _statusStyle(item.status);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: CyberColors.deepSpace,
                        border: Border.all(
                          color: color.withValues(alpha: 0.45),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(icon, color: color, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: CyberTextStyles.hudHeadline.copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.16),
                                  border: Border.all(color: color),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  label,
                                  style: CyberTextStyles.monoTag.copyWith(
                                    fontSize: 10,
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.manifestPermission,
                            style: CyberTextStyles.monoTag.copyWith(
                              fontSize: 10,
                              color: CyberColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.description,
                            style: CyberTextStyles.bodyMedium.copyWith(
                              fontSize: 13,
                            ),
                          ),
                          if (!item.isOk) ...[
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  if (item.status ==
                                      DiagnosticPermissionStatus
                                          .permanentlyDenied) {
                                    ref
                                        .read(permissionsDiagnosticsProvider
                                            .notifier)
                                        .openSystemSettings(item.kind);
                                  } else {
                                    ref
                                        .read(permissionsDiagnosticsProvider
                                            .notifier)
                                        .request(item.kind);
                                  }
                                },
                                icon: Icon(
                                  item.canRequestInApp &&
                                          item.status !=
                                              DiagnosticPermissionStatus
                                                  .permanentlyDenied
                                      ? Icons.security_update_good
                                      : Icons.settings_outlined,
                                  size: 16,
                                ),
                                label: Text(
                                  item.status ==
                                          DiagnosticPermissionStatus
                                              .permanentlyDenied
                                      ? 'ABRIR AJUSTES'
                                      : item.canRequestInApp
                                          ? 'CONCEDER PERMISO'
                                          : 'CONFIGURAR',
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
