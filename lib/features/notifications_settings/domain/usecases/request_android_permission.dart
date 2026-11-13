import '../entities/android_permission_item.dart';
import '../repositories/permission_diagnostics_repository.dart';

class RequestAndroidPermission {
  const RequestAndroidPermission(this._repository);

  final PermissionDiagnosticsRepository _repository;

  Future<List<AndroidPermissionItem>> call(AndroidPermissionKind kind) =>
      _repository.requestPermission(kind);
}
