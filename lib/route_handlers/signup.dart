import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../helper_functions.dart';
import '../secrets.dart';

Future<Response> signupHandler(Request req) async {
  final authHeader = req.headers['authorization'];
  final (email, password) = extractCredentials(authHeader!);

  final headers = {
    'rid': 'emailpassword',
    'api-key': apiKey,
    'cdi-version': '4.0',
    'Content-Type': 'application/json'
  };
  final url = Uri.parse('$superTokensBase/recipe/signup');
  final body = jsonEncode({'email': email, 'password': password});
  final response = await http.post(url, headers: headers, body: body);

  return Response(
    response.statusCode,
    body: response.body,
    headers: response.headers,
  );
}
