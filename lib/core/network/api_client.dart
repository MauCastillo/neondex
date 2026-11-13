import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../error/exceptions.dart';

class ApiClient {
  ApiClient({http.Client? httpClient}) : _client = httpClient ?? http.Client();

  final http.Client _client;
  final Map<String, Map<String, dynamic>> _jsonCache = {};

  Future<Map<String, dynamic>> getJson(
    String url, {
    bool useCache = true,
  }) async {
    if (useCache && _jsonCache.containsKey(url)) {
      return _jsonCache[url]!;
    }

    try {
      final response = await _client
          .get(
            Uri.parse(url),
            headers: const {'Accept': 'application/json'},
          )
          .timeout(ApiConstants.requestTimeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          if (useCache) {
            if (_jsonCache.length > 250) {
              _jsonCache.remove(_jsonCache.keys.first);
            }
            _jsonCache[url] = decoded;
          }
          return decoded;
        }
        throw const ServerException('Unexpected JSON payload format');
      }

      if (response.statusCode == 404) {
        throw const ServerException(
          'Requested resource not found (404)',
          statusCode: 404,
        );
      }

      throw ServerException(
        'Server returned status ${response.statusCode}',
        statusCode: response.statusCode,
      );
    } on ServerException {
      rethrow;
    } on TimeoutException {
      throw const NetworkException('Connection timed out while contacting API.');
    } on SocketException {
      throw const NetworkException('No internet connection available.');
    } on http.ClientException catch (e) {
      throw NetworkException('HTTP transport error: ${e.message}');
    } on FormatException {
      throw const ServerException('Invalid JSON payload received from server.');
    }
  }

  void clearCache() => _jsonCache.clear();
}
