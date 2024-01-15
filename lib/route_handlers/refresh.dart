import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';

import '../constants.dart';
import '../secrets.dart';

Future<Response> tokenRefreshHandler(Request req) async {
  final authHeader = req.headers['authorization'];
  final refreshToken = authHeader?.substring(7); // remove 'Bearer '

  var url = Uri.parse('$superTokensBase/recipe/session/refresh');
  final headers = {
    'rid': 'session',
    'api-key': apiKey,
    'cdi-version': '4.0',
    'Content-Type': 'application/json'
  };
  var body = jsonEncode({
    'refreshToken': refreshToken,
    'enableAntiCsrf': false,
    'antiCsrfToken': refreshToken,
  });
  var response = await http.post(url, headers: headers, body: body);

  return Response(
    response.statusCode,
    body: response.body,
    headers: response.headers,
  );
}
