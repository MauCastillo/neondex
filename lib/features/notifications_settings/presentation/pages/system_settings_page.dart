import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/cyber_colors.dart';
import '../../../../core/widgets/cyber_section_header.dart';
import '../providers/permissions_diagnostics_provider.dart';
import '../widgets/notification_scheduler_panel.dart';
import '../widgets/permission_diagnostics_panel.dart';

class SystemSettingsPage extends ConsumerStatefulWidget {
  const SystemSettingsPage({super.key});

  @override
  ConsumerState<SystemSettingsPage> createState() => _SystemSettingsPageState();
}

class _SystemSettingsPageState extends ConsumerState<SystemSettingsPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(permissionsDiagnosticsProvider.notifier).refresh();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: CyberSectionHeader(
              title: 'SISTEMA Y DIAGNÓSTICO',
              codeTag: 'CONFIGURACIÓN ANDROID + ALERTAS',
              accentColor: CyberColors.neonMagenta,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: CyberColors.neonCyan,
              backgroundColor: CyberColors.panelDark,
              onRefresh: () =>
                  ref.read(permissionsDiagnosticsProvider.notifier).refresh(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 72),
                children: const [
                  NotificationSchedulerPanel(),
                  SizedBox(height: 16),
                  PermissionDiagnosticsPanel(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
