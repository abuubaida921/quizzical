import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'network_config.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}

class ApiClient {
  http.Client _http;
  final Duration timeout;
  final bool _isMock;
  static const int _maxRetries = 3;
  static const int _maxRetriesForConnectionClosed = 6;
  static const Duration _baseDelay = Duration(milliseconds: 400);

  ApiClient({http.Client? httpClient, this.timeout = const Duration(seconds: 20)})
      : _http = httpClient ?? http.Client(),
        _isMock = httpClient != null;

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
    return _executeWithRetry(() async {
      final response = await _http.get(uri, headers: _defaultHeaders()).timeout(timeout);
      if (kDebugMode) {
        print('API GET Response: Status ${response.statusCode}, Body: ${response.body}');
      }
      return _processResponse(response);
    });
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body, Map<String, String>? queryParameters}) async {
    final uri = _buildUri(path, queryParameters);
    if (kDebugMode) {
      print('API POST Request: $uri, Body: $body');
    }
    return _executeWithRetry(() async {
      final response = await _http.post(uri, headers: _defaultHeaders(), body: jsonEncode(body)).timeout(timeout);
      if (kDebugMode) {
        print('API POST Response: Status ${response.statusCode}, Body: ${response.body}');
      }
      return _processResponse(response);
    });
  }

  Future<dynamic> put(String path, {Map<String, dynamic>? body, Map<String, String>? queryParameters}) async {
    final uri = _buildUri(path, queryParameters);
    if (kDebugMode) {
      print('API PUT Request: $uri, Body: $body');
    }
    return _executeWithRetry(() async {
      final response = await _http.put(uri, headers: _defaultHeaders(), body: jsonEncode(body)).timeout(timeout);
      if (kDebugMode) {
        print('API PUT Response: Status ${response.statusCode}, Body: ${response.body}');
      }
      return _processResponse(response);
    });
  }

  Future<dynamic> delete(String path, {Map<String, String>? queryParameters}) async {
    final uri = _buildUri(path, queryParameters);
    if (kDebugMode) {
      print('API DELETE Request: $uri');
    }
    return _executeWithRetry(() async {
      final response = await _http.delete(uri, headers: _defaultHeaders()).timeout(timeout);
      if (kDebugMode) {
        print('API DELETE Response: Status ${response.statusCode}, Body: ${response.body}');
      }
      return _processResponse(response);
    });
  }


  Future<dynamic> _executeWithRetry(FutureOr<dynamic> Function() fn) async {
    int attempt = 0;
    final rand = Random();

    while (true) {
      attempt++;
      try {
        final res = await fn();
        return res;
      } catch (e, st) {
        final eMessage = e is ApiException ? e.message.toLowerCase() : e.toString().toLowerCase();
        final isClientConnectionClosed = e is http.ClientException && e.toString().toLowerCase().contains('connection closed');
        final isTransient = e is SocketException || e is http.ClientException || e is HttpException || e is TimeoutException || (e is ApiException && eMessage.contains('connection')) || isClientConnectionClosed;


        final allowedAttempts = isClientConnectionClosed ? _maxRetriesForConnectionClosed : _maxRetries;
        if (!isTransient || attempt >= allowedAttempts) {

          if (e is ApiException) rethrow;
          String msg;
          if (isClientConnectionClosed) {
            msg = 'Network error: server closed the connection prematurely. This often indicates an unstable network or server issue — please try again.';
          } else if (e is SocketException || e is http.ClientException || (e is ApiException && e.message.toLowerCase().contains('connection'))) {
            msg = 'Network error: connection problem. Please check your internet connection and try again.';
          } else if (e is TimeoutException) {
            msg = 'Request timed out. Please try again.';
          } else if (e is HttpException) {
            msg = 'Network error: ${e.message}';
          } else {
            msg = e.toString();
          }

          if (kDebugMode) {
            print('API call failed after $attempt attempts: $e\n$st');
          }

          throw ApiException(msg);
        }


        if (isClientConnectionClosed && !_isMock) {
          try {
            _http.close();
          } catch (_) {}
          _http = http.Client();
        }


        final delayMs = _baseDelay.inMilliseconds * pow(2, attempt - 1) as int;
        final jitter = rand.nextInt(150);
        final wait = Duration(milliseconds: delayMs + jitter);
        if (kDebugMode) {
          print('Transient error on attempt $attempt: $e — retrying after ${wait.inMilliseconds}ms');
        }
        await Future.delayed(wait);
      }
    }
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