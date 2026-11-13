import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/geo_location.dart';

abstract class LocationDataSource {
  Future<GeoLocation> getCurrentLocation();
}

class GeolocatorDataSourceImpl implements LocationDataSource {
  const GeolocatorDataSourceImpl();

  @override
  Future<GeoLocation> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceException(
        'El servicio GPS del dispositivo está desactivado. Actívalo para escanear el clima local.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const LocationServiceException(
        'Permiso de ubicación denegado. Concédelo para detectar tu sector GPS.',
        isPermissionIssue: true,
      );
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationServiceException(
        'Permiso de ubicación denegado permanentemente. Habilítalo desde Diagnóstico o Ajustes de Android.',
        isPermissionIssue: true,
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 12),
        ),
      );
      return GeoLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracyMeters: position.accuracy,
      );
    } on TimeoutException {
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        return GeoLocation(
          latitude: lastKnown.latitude,
          longitude: lastKnown.longitude,
          accuracyMeters: lastKnown.accuracy,
        );
      }
      throw const LocationServiceException(
        'Tiempo de espera agotado al obtener señal GPS.',
      );
    } catch (e) {
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        return GeoLocation(
          latitude: lastKnown.latitude,
          longitude: lastKnown.longitude,
          accuracyMeters: lastKnown.accuracy,
        );
      }
      throw LocationServiceException('No se pudo obtener ubicación GPS: $e');
    }
  }
}
