import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:supertokens_dart_backend/route_handlers/delete.dart';
import 'package:supertokens_dart_backend/route_handlers/refresh.dart';
import 'package:supertokens_dart_backend/route_handlers/signin.dart';
import 'package:supertokens_dart_backend/route_handlers/signout.dart';
import 'package:supertokens_dart_backend/route_handlers/verification.dart';
import 'package:supertokens_dart_backend/route_handlers/signup.dart';

final _router = Router()
  ..post('/auth/signup', signupHandler)
  ..post('/auth/signin', signinHandler)
  ..post('/auth/verify', tokenVerificationHandler)
  ..post('/auth/refresh', tokenRefreshHandler)
  ..post('/auth/signout', signoutHandler)
  ..post('/auth/delete', deleteUserHandler);

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
