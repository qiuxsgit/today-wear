import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:today_wear/api/api_client.dart';
import 'package:today_wear/api/api_exception.dart';
import 'package:today_wear/api/user_api.dart';

void main() {
  group('UserApi.deleteAccount', () {
    test('发送 DELETE /users/me 携带 password body，204 视为成功', () async {
      late http.Request captured;
      final client = ApiClient.forTesting(MockClient((req) async {
        captured = req;
        return http.Response('', 204);
      }));
      await UserApi(client).deleteAccount('secret-pw');

      expect(captured.method, 'DELETE');
      expect(captured.url.path, endsWith('/users/me'));
      expect(jsonDecode(captured.body), {'password': 'secret-pw'});
      expect(captured.headers['Content-Type'], startsWith('application/json'));
    });

    test('401 invalid_credentials 抛 UnauthorizedException 且不触发 onUnauthorized', () async {
      var unauthorizedCalls = 0;
      final client = ApiClient.forTesting(MockClient((req) async {
        return http.Response(
          jsonEncode({
            'data': null,
            'error': {'code': 'invalid_credentials', 'message': 'bad'},
          }),
          401,
          headers: {'content-type': 'application/json'},
        );
      }))
        ..onUnauthorized = () => unauthorizedCalls++;

      await expectLater(
        UserApi(client).deleteAccount('wrong'),
        throwsA(isA<UnauthorizedException>()),
      );
      expect(unauthorizedCalls, 0, reason: '密码错误不得清会话');
    });

    test('401 unauthorized（会话失效）仍触发 onUnauthorized', () async {
      var unauthorizedCalls = 0;
      final client = ApiClient.forTesting(MockClient((req) async {
        return http.Response(
          jsonEncode({
            'data': null,
            'error': {'code': 'unauthorized', 'message': 'expired'},
          }),
          401,
          headers: {'content-type': 'application/json'},
        );
      }))
        ..onUnauthorized = () => unauthorizedCalls++;

      await expectLater(
        UserApi(client).deleteAccount('any'),
        throwsA(isA<UnauthorizedException>()),
      );
      expect(unauthorizedCalls, 1);
    });
  });
}
