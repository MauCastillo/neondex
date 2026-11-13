import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/service_locator.dart';
import '../../domain/entities/android_permission_item.dart';
import '../../domain/repositories/permission_diagnostics_repository.dart';
import '../../domain/usecases/check_android_permissions.dart';
import '../../domain/usecases/request_android_permission.dart';

final permissionDiagnosticsRepositoryProvider =
    Provider<PermissionDiagnosticsRepository>(
  (ref) => sl<PermissionDiagnosticsRepository>(),
);

final checkAndroidPermissionsUseCaseProvider =
    Provider<CheckAndroidPermissions>(
  (ref) => sl<CheckAndroidPermissions>(),
);

final requestAndroidPermissionUseCaseProvider =
    Provider<RequestAndroidPermission>(
  (ref) => sl<RequestAndroidPermission>(),
);

final permissionsDiagnosticsProvider = AsyncNotifierProvider<
    PermissionsDiagnosticsNotifier, List<AndroidPermissionItem>>(
  PermissionsDiagnosticsNotifier.new,
);

class PermissionsDiagnosticsNotifier
    extends AsyncNotifier<List<AndroidPermissionItem>> {
  @override
  Future<List<AndroidPermissionItem>> build() {
    return ref.read(checkAndroidPermissionsUseCaseProvider)();
  }

  Future<void> refresh() async {
    final items = await ref.read(checkAndroidPermissionsUseCaseProvider)();
    if (!ref.mounted) return;
    state = AsyncData(items);
  }

  Future<void> request(AndroidPermissionKind kind) async {
    final items = await ref.read(requestAndroidPermissionUseCaseProvider)(kind);
    if (!ref.mounted) return;
    state = AsyncData(items);
  }

  Future<void> openSystemSettings(AndroidPermissionKind kind) async {
    await ref
        .read(permissionDiagnosticsRepositoryProvider)
        .openSystemSettings(kind);
  }
}
