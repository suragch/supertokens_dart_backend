import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../helper_functions.dart';
import '../secrets.dart';
import 'verification.dart';

Future<Response> signoutHandler(Request req) async {
  final authHeader = req.headers['authorization'];
  final accessToken = authHeader!.substring(7); // remove 'Bearer '

  // Verify user's access token
  final verifyResponse = await tokenVerificationHandler(req);
  if (verifyResponse.statusCode != 200) {
    return verifyResponse;
  }

  final userId = extractUserIdFromToken(accessToken);
  var url = Uri.parse('$superTokensBase/recipe/session/remove');
  final headers = {
    'rid': 'session',
    'api-key': apiKey,
    'cdi-version': '4.0',
    'Content-Type': 'application/json'
  };
  var body = jsonEncode({'userId': userId});
  var response = await http.post(url, headers: headers, body: body);

  return Response(
    response.statusCode,
    body: response.body,
    headers: response.headers,
  );
}
