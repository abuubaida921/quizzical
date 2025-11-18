import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
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
    if (kDebugMode) {
      print('API GET Request: $uri');
    }
    final response = await _http.get(uri, headers: _defaultHeaders()).timeout(timeout);
    if (kDebugMode) {
      print('API GET Response: Status ${response.statusCode}, Body: ${response.body}');
    }
    return _processResponse(response);
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body, Map<String, String>? queryParameters}) async {
    final uri = _buildUri(path, queryParameters);
    if (kDebugMode) {
      print('API POST Request: $uri, Body: $body');
    }
    final response = await _http.post(uri, headers: _defaultHeaders(), body: jsonEncode(body)).timeout(timeout);
    if (kDebugMode) {
      print('API POST Response: Status ${response.statusCode}, Body: ${response.body}');
    }
    return _processResponse(response);
  }

  Future<dynamic> put(String path, {Map<String, dynamic>? body, Map<String, String>? queryParameters}) async {
    final uri = _buildUri(path, queryParameters);
    if (kDebugMode) {
      print('API PUT Request: $uri, Body: $body');
    }
    final response = await _http.put(uri, headers: _defaultHeaders(), body: jsonEncode(body)).timeout(timeout);
    if (kDebugMode) {
      print('API PUT Response: Status ${response.statusCode}, Body: ${response.body}');
    }
    return _processResponse(response);
  }

  Future<dynamic> delete(String path, {Map<String, String>? queryParameters}) async {
    final uri = _buildUri(path, queryParameters);
    if (kDebugMode) {
      print('API DELETE Request: $uri');
    }
    final response = await _http.delete(uri, headers: _defaultHeaders()).timeout(timeout);
    if (kDebugMode) {
      print('API DELETE Response: Status ${response.statusCode}, Body: ${response.body}');
    }
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