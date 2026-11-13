import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class DeepLinkCoordinator {
  DeepLinkCoordinator();

  static const MethodChannel _methodChannel =
      MethodChannel('com.maucastillo.neondex/deeplink');
  static const EventChannel _eventChannel =
      EventChannel('com.maucastillo.neondex/deeplink_events');

  final StreamController<int> _pokemonIdController =
      StreamController<int>.broadcast();

  int? _pendingPokemonId;
  StreamSubscription<dynamic>? _nativeSub;
  bool _initialized = false;

  Stream<int> get pokemonRouteStream => _pokemonIdController.stream;

  int? consumePendingPokemonId() {
    final value = _pendingPokemonId;
    _pendingPokemonId = null;
    return value;
  }

  Future<void> initPlatformLinks() async {
    if (_initialized) return;
    _initialized = true;

    try {
      final initialLink =
          await _methodChannel.invokeMethod<String>('getInitialLink');
      if (initialLink != null && initialLink.isNotEmpty) {
        handlePayload(initialLink);
      }
    } catch (_) {
      // Ignored on non-Android platforms or unit tests.
    }

    try {
      _nativeSub = _eventChannel.receiveBroadcastStream().listen(
        (dynamic link) {
          if (link is String && link.isNotEmpty) {
            handlePayload(link);
          }
        },
        onError: (_) {},
      );
    } catch (_) {
      // Ignored when no native event channel is bound.
    }
  }

  void handlePayload(String? payload) {
    final id = parsePokemonId(payload);
    if (id == null || id <= 0) return;
    _pendingPokemonId = id;
    _pokemonIdController.add(id);
  }

  static int? parsePokemonId(String? payload) {
    if (payload == null) return null;
    final trimmed = payload.trim();
    if (trimmed.isEmpty) return null;

    final directInt = int.tryParse(trimmed);
    if (directInt != null && directInt > 0) return directInt;

    if (trimmed.startsWith('{')) {
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is Map<String, dynamic>) {
          final id = decoded['pokemonId'];
          if (id is int && id > 0) return id;
          if (id is String) return int.tryParse(id);
        }
      } catch (_) {}
    }

    final uri = Uri.tryParse(trimmed);
    if (uri != null) {
      if (uri.scheme == 'neondex' && uri.host == 'pokemon') {
        if (uri.pathSegments.isNotEmpty) {
          return int.tryParse(uri.pathSegments.first);
        }
      }
      final idx = uri.pathSegments.indexOf('pokemon');
      if (idx != -1 && idx + 1 < uri.pathSegments.length) {
        return int.tryParse(uri.pathSegments[idx + 1]);
      }
      final idParam = uri.queryParameters['id'];
      if (idParam != null) {
        return int.tryParse(idParam);
      }
    }

    final regex = RegExp(r'pokemon[:/](\d+)');
    final match = regex.firstMatch(trimmed);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    return null;
  }

  static String buildPokemonUri(int pokemonId) => 'neondex://pokemon/$pokemonId';

  void dispose() {
    _nativeSub?.cancel();
    _pokemonIdController.close();
  }
}
