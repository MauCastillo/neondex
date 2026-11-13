import '../entities/android_permission_item.dart';
import '../repositories/permission_diagnostics_repository.dart';

class CheckAndroidPermissions {
  const CheckAndroidPermissions(this._repository);

  final PermissionDiagnosticsRepository _repository;

  Future<List<AndroidPermissionItem>> call() =>
      _repository.checkAllPermissions();
}
