
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:quizzical/core/network/api_client.dart';

import 'api_client_test.mocks.dart';

// Generate a mock using mockito (run `flutter pub run build_runner build` to generate)
@GenerateMocks([http.Client])

void main() {
  group('ApiClient retry behavior', () {
    test('succeeds after transient ClientException and retries', () async {
      final mock = MockClient();
      int calls = 0;

      // Configure mock to fail twice then succeed
      when(mock.get(any, headers: anyNamed('headers'))).thenAnswer((_) {
        calls++;
        if (calls < 3) {
          throw http.ClientException('Connection closed before full header was received');
        }
        return Future.value(http.Response('{"ok":true}', 200, headers: {'content-type': 'application/json'}));
      });

      final client = ApiClient(httpClient: mock, timeout: const Duration(seconds: 1));

      final res = await client.get('/api.php', queryParameters: {'amount': '1'});

      expect(res, isA<Map>());
      expect(res['ok'], isTrue);
      expect(calls, greaterThanOrEqualTo(3));
    });

    test('throws ApiException after exhausting retries on persistent connection closed', () async {
      final mock = MockClient();

      // Configure mock to always fail
      when(mock.get(any, headers: anyNamed('headers'))).thenThrow(
        http.ClientException('Connection closed before full header was received'),
      );

      final client = ApiClient(httpClient: mock, timeout: const Duration(seconds: 1));

      try {
        await client.get('/api.php', queryParameters: {'amount': '1'});
        fail('Expected ApiException');
      } catch (e) {
        expect(e, isA<ApiException>());
        final msg = (e as ApiException).message.toLowerCase();
        expect(msg, contains('server closed the connection'));
      }
    });
  });
}

