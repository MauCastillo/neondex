import 'package:equatable/equatable.dart';

class GeoLocation extends Equatable {
  const GeoLocation({
    required this.latitude,
    required this.longitude,
    this.accuracyMeters,
  });

  final double latitude;
  final double longitude;
  final double? accuracyMeters;

  @override
  List<Object?> get props => [latitude, longitude, accuracyMeters];
}
