import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/cyber_colors.dart';

class CyberNetworkImage extends StatelessWidget {
  const CyberNetworkImage({
    super.key,
    required this.imageUrl,
    this.fallbackUrl,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.accentColor = CyberColors.neonCyan,
  });

  final String imageUrl;
  final String? fallbackUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorListener: (_) {},
      placeholder: (context, url) => _CyberPlaceholder(
        accentColor: accentColor,
        width: width,
        height: height,
      ),
      errorWidget: (context, url, error) {
        if (fallbackUrl != null && fallbackUrl!.isNotEmpty && fallbackUrl != imageUrl) {
          return CachedNetworkImage(
            imageUrl: fallbackUrl!,
            width: width,
            height: height,
            fit: fit,
            errorListener: (_) {},
            placeholder: (context, url) => _CyberPlaceholder(
              accentColor: accentColor,
              width: width,
              height: height,
            ),
            errorWidget: (context, url, error) => _CyberPlaceholder(
              accentColor: accentColor,
              width: width,
              height: height,
              isError: true,
            ),
          );
        }
        return _CyberPlaceholder(
          accentColor: accentColor,
          width: width,
          height: height,
          isError: true,
        );
      },
    );
  }
}

class _CyberPlaceholder extends StatelessWidget {
  const _CyberPlaceholder({
    required this.accentColor,
    this.width,
    this.height,
    this.isError = false,
  });

  final Color accentColor;
  final double? width;
  final double? height;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: Icon(
          isError ? Icons.catching_pokemon : Icons.radar,
          size: 36,
          color: accentColor.withValues(alpha: isError ? 0.5 : 0.35),
        ),
      ),
    );
  }
}
