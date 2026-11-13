import 'package:equatable/equatable.dart';

import '../../../../core/constants/api_constants.dart';

class PokemonSummary extends Equatable {
  const PokemonSummary({
    required this.id,
    required this.name,
    this.imageUrl,
    this.fallbackImageUrl,
    this.types = const [],
  });

  final int id;
  final String name;
  final String? imageUrl;
  final String? fallbackImageUrl;
  final List<String> types;

  String get resolvedImageUrl =>
      imageUrl ?? ApiConstants.officialArtworkUrl(id);

  String get resolvedFallbackImageUrl =>
      fallbackImageUrl ?? ApiConstants.fallbackSpriteUrl(id);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'fallbackImageUrl': fallbackImageUrl,
        'types': types,
      };

  factory PokemonSummary.fromJson(Map<String, dynamic> json) {
    return PokemonSummary(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      fallbackImageUrl: json['fallbackImageUrl'] as String?,
      types: (json['types'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  @override
  List<Object?> get props => [id, name, imageUrl, fallbackImageUrl, types];
}
