import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'network_config.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}

class ApiClient {
  final http.Client _http;
  final Duration timeout;

  ApiClient({http.Client? httpClient, this.timeout = const Duration(seconds: 20)})
      : _http = httpClient ?? http.Client();

  Uri _buildUri(String path, [Map<String, String>? queryParameters]) {
    final base = NetworkConfig.instance.baseUrl;
    final uri = Uri.parse(base + path);
    if (queryParameters != null) {
      return uri.replace(queryParameters: queryParameters);
    }
    return uri;
  }

  Map<String, String> _defaultHeaders() {
    return {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<dynamic> get(String path, {Map<String, String>? queryParameters}) async {
    final uri = _buildUri(path, queryParameters);
    final response = await _http.get(uri, headers: _defaultHeaders()).timeout(timeout);
    return _processResponse(response);
  }

  dynamic _processResponse(http.Response response) {
    final status = response.statusCode;
    if (status >= 200 && status < 300) {
      if (response.body.isEmpty) return null;
      final jsonBody = jsonDecode(response.body);
      return jsonBody;
    } else {
      throw ApiException('Request failed with status: $status');
    }
  }
}