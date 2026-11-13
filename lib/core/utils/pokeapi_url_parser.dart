class PokeApiUrlParser {
  const PokeApiUrlParser._();

  static int? extractIdFromUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    final trimmed = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
    final lastSlash = trimmed.lastIndexOf('/');
    if (lastSlash == -1 || lastSlash == trimmed.length - 1) return null;
    return int.tryParse(trimmed.substring(lastSlash + 1));
  }
}
