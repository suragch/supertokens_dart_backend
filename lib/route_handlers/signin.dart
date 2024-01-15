import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../helper_functions.dart';
import '../secrets.dart';

Future<Response> signinHandler(Request req) async {
  final authHeader = req.headers['authorization'];
  final (email, password) = extractCredentials(authHeader!);

  final headers = {
    'rid': 'emailpassword',
    'api-key': apiKey,
    'cdi-version': '4.0',
    'Content-Type': 'application/json'
  };
  var url = Uri.parse('$superTokensBase/recipe/signin');
  var body = jsonEncode({'email': email, 'password': password});
  var response = await http.post(url, headers: headers, body: body);
  final userId = jsonDecode(response.body)['user']['id'];

  headers['rid'] = 'session';
  url = Uri.parse('$superTokensBase/recipe/session');
  body = jsonEncode({
    "userId": userId,
    "userDataInJWT": {"test": 123},
    "userDataInDatabase": {"test": 123},
    "enableAntiCsrf": false,
  });
  response = await http.post(url, headers: headers, body: body);

  return Response(
    response.statusCode,
    body: response.body,
    headers: response.headers,
  );
}
