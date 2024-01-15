import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../secrets.dart';

Future<Response> tokenVerificationHandler(Request req) async {
  final authHeader = req.headers['authorization'];
  final accessToken = authHeader?.substring(7); // remove 'Bearer '

  var url = Uri.parse('$superTokensBase/recipe/session/verify');
  final headers = {
    'rid': 'session',
    'api-key': apiKey,
    'cdi-version': '4.0',
    'Content-Type': 'application/json'
  };
  var body = jsonEncode({
    'accessToken': accessToken,
    'enableAntiCsrf': false,
    'doAntiCsrfCheck': false,
    'checkDatabase': false,
    'antiCsrfToken': accessToken,
  });
  var response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200 &&
      jsonDecode(response.body)['status'] == 'OK') {
    return Response.ok('Valid token');
  }

  return Response.unauthorized('Invalid token');
}
