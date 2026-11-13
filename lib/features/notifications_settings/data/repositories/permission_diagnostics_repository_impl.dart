import '../../domain/entities/android_permission_item.dart';
import '../../domain/repositories/permission_diagnostics_repository.dart';
import '../datasources/android_permission_data_source.dart';

class PermissionDiagnosticsRepositoryImpl
    implements PermissionDiagnosticsRepository {
  const PermissionDiagnosticsRepositoryImpl(this._dataSource);

  final AndroidPermissionDataSource _dataSource;

  @override
  Future<List<AndroidPermissionItem>> checkAllPermissions() {
    return _dataSource.checkAll();
  }

  @override
  Future<List<AndroidPermissionItem>> requestPermission(
    AndroidPermissionKind kind,
  ) async {
    await _dataSource.request(kind);
    return _dataSource.checkAll();
  }

  @override
  Future<void> openSystemSettings(AndroidPermissionKind kind) {
    return _dataSource.openSettings(kind);
  }
}
