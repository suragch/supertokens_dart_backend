import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:supertokens_dart_backend/secrets.dart';
import 'package:test/test.dart';

// The SuperTokens Core Docker container needs to be
// restarted before tests are run each time to clear
// the in-memory database. These tests should be considered
// as integration tests rather than unit tests since
// they modify the internal state of the SuperTokens Core
// in-memory database.
void main() {
  final port = '8080';
  final host = 'http://0.0.0.0:$port';
  late Process p;

  setUp(() async {
    p = await Process.start(
      'dart',
      ['run', 'bin/server.dart'],
      environment: {'PORT': port},
    );
    await p.stdout.first;
  });

  tearDown(() => p.kill());

  group('signup:', () {
    test('signup works', () async {
      final credentials = 'johndoe@gmail.com:password123';
      final encoded = base64Url.encode(utf8.encode(credentials));
      final response = await post(
        Uri.parse('$host/auth/signup'),
        headers: {
          'Authorization': 'Basic $encoded',
        },
      );
      final body = json.decode(response.body);
      expect(response.statusCode, 200);
      expect(body['status'], 'OK');
      final id = body['user']['id'] as String;
      expect(id.length, 36);
      final emails = body['user']['emails'] as List;
      expect(emails, ['johndoe@gmail.com']);
    });

    // this test follows the one above it
    test('signup second time with same credentials', () async {
      // same as before
      final credentials = 'johndoe@gmail.com:password123';
      final encoded = base64Url.encode(utf8.encode(credentials));
      final response = await post(
        Uri.parse('$host/auth/signup'),
        headers: {
          'Authorization': 'Basic $encoded',
        },
      );
      expect(response.statusCode, HttpStatus.conflict);
    });
  });

  test('404', () async {
    final response = await get(
      Uri.parse('$host/foobar'),
    );
    expect(response.statusCode, 404);
  });
}
