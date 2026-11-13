import '../entities/android_permission_item.dart';

abstract class PermissionDiagnosticsRepository {
  Future<List<AndroidPermissionItem>> checkAllPermissions();

  Future<List<AndroidPermissionItem>> requestPermission(
    AndroidPermissionKind kind,
  );

  Future<void> openSystemSettings(AndroidPermissionKind kind);
}
