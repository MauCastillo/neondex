import 'package:equatable/equatable.dart';

enum AndroidPermissionKind {
  locationWhenInUse,
  notification,
  locationService,
  networkAccess,
}

enum DiagnosticPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  disabled,
  restricted,
}

class AndroidPermissionItem extends Equatable {
  const AndroidPermissionItem({
    required this.kind,
    required this.title,
    required this.manifestPermission,
    required this.description,
    required this.status,
    required this.canRequestInApp,
  });

  final AndroidPermissionKind kind;
  final String title;
  final String manifestPermission;
  final String description;
  final DiagnosticPermissionStatus status;
  final bool canRequestInApp;

  bool get isOk => status == DiagnosticPermissionStatus.granted;

  @override
  List<Object?> get props => [
        kind,
        title,
        manifestPermission,
        description,
        status,
        canRequestInApp,
      ];
}
