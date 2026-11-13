import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/entities/android_permission_item.dart';

abstract class AndroidPermissionDataSource {
  Future<List<AndroidPermissionItem>> checkAll();
  Future<void> request(AndroidPermissionKind kind);
  Future<void> openSettings(AndroidPermissionKind kind);
}

class AndroidPermissionDataSourceImpl implements AndroidPermissionDataSource {
  const AndroidPermissionDataSourceImpl();

  @override
  Future<List<AndroidPermissionItem>> checkAll() async {
    final locationStatus = await _checkHandlerPermission(
      Permission.locationWhenInUse,
    );
    final notificationStatus = await _checkHandlerPermission(
      Permission.notification,
    );
    final gpsServiceStatus = await _checkLocationService();
    final networkStatus = await _checkNetworkAccess();

    return [
      AndroidPermissionItem(
        kind: AndroidPermissionKind.locationWhenInUse,
        title: 'Ubicación GPS (En uso)',
        manifestPermission: 'ACCESS_FINE_LOCATION / COARSE',
        description:
            'Necesario para obtener coordenadas reales y consultar Open-Meteo.',
        status: locationStatus,
        canRequestInApp: true,
      ),
      AndroidPermissionItem(
        kind: AndroidPermissionKind.notification,
        title: 'Notificaciones Locales',
        manifestPermission: 'POST_NOTIFICATIONS (Android 13+)',
        description:
            'Permite alertas programadas y pruebas interactivas con Deep Link.',
        status: notificationStatus,
        canRequestInApp: true,
      ),
      AndroidPermissionItem(
        kind: AndroidPermissionKind.locationService,
        title: 'Servicio GPS del Sistema',
        manifestPermission: 'LOCATION_SERVICE_HARDWARE',
        description:
            'Sensor de ubicación del dispositivo debe estar encendido.',
        status: gpsServiceStatus,
        canRequestInApp: false,
      ),
      AndroidPermissionItem(
        kind: AndroidPermissionKind.networkAccess,
        title: 'Acceso a Red / Internet',
        manifestPermission: 'android.permission.INTERNET',
        description:
            'Conexión en vivo a PokeAPI v2 y Open-Meteo Forecast API.',
        status: networkStatus,
        canRequestInApp: false,
      ),
    ];
  }

  Future<DiagnosticPermissionStatus> _checkHandlerPermission(
    Permission permission,
  ) async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      return DiagnosticPermissionStatus.granted;
    }
    try {
      final status = await permission.status;
      return _mapStatus(status);
    } catch (_) {
      return DiagnosticPermissionStatus.denied;
    }
  }

  Future<DiagnosticPermissionStatus> _checkLocationService() async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      return DiagnosticPermissionStatus.granted;
    }
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      return enabled
          ? DiagnosticPermissionStatus.granted
          : DiagnosticPermissionStatus.disabled;
    } catch (_) {
      return DiagnosticPermissionStatus.disabled;
    }
  }

  Future<DiagnosticPermissionStatus> _checkNetworkAccess() async {
    try {
      final result = await InternetAddress.lookup('pokeapi.co')
          .timeout(const Duration(seconds: 2));
      if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
        return DiagnosticPermissionStatus.granted;
      }
      return DiagnosticPermissionStatus.disabled;
    } catch (_) {
      return DiagnosticPermissionStatus.disabled;
    }
  }

  DiagnosticPermissionStatus _mapStatus(PermissionStatus status) {
    if (status.isGranted || status.isProvisional || status.isLimited) {
      return DiagnosticPermissionStatus.granted;
    }
    if (status.isPermanentlyDenied) {
      return DiagnosticPermissionStatus.permanentlyDenied;
    }
    if (status.isRestricted) {
      return DiagnosticPermissionStatus.restricted;
    }
    return DiagnosticPermissionStatus.denied;
  }

  @override
  Future<void> request(AndroidPermissionKind kind) async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) return;

    switch (kind) {
      case AndroidPermissionKind.locationWhenInUse:
        final status = await Permission.locationWhenInUse.request();
        if (status.isPermanentlyDenied) {
          await openAppSettings();
        }
        break;
      case AndroidPermissionKind.notification:
        final status = await Permission.notification.request();
        if (status.isPermanentlyDenied) {
          await openAppSettings();
        }
        break;
      case AndroidPermissionKind.locationService:
        await Geolocator.openLocationSettings();
        break;
      case AndroidPermissionKind.networkAccess:
        await openAppSettings();
        break;
    }
  }

  @override
  Future<void> openSettings(AndroidPermissionKind kind) async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) return;
    if (kind == AndroidPermissionKind.locationService) {
      await Geolocator.openLocationSettings();
    } else {
      await openAppSettings();
    }
  }
}
