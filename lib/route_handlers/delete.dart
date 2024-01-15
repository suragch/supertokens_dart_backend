import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';
import 'package:supertokens_dart_backend/route_handlers/verification.dart';

import '../constants.dart';
import '../helper_functions.dart';
import '../secrets.dart';

Future<Response> deleteUserHandler(Request req) async {
  final authHeader = req.headers['authorization'];
  final accessToken = authHeader!.substring(7); // remove 'Bearer '

  final verifyResponse = await tokenVerificationHandler(req);
  if (verifyResponse.statusCode != 200) {
    return verifyResponse;
  }

  final userId = extractUserIdFromToken(accessToken);
  var url = Uri.parse('$superTokensBase/user/remove');
  final headers = {
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
