import 'dart:convert';

(String email, String password) extractCredentials(String authHeader) {
  final credentials = utf8.decode(base64.decode(authHeader.substring(6)));
  final parts = credentials.split(':');
  return (parts[0], parts[1]);
}

String extractUserIdFromToken(String jwt) {
  final parts = jwt.split('.');
  final payload = parts[1];
  final normalized = base64Url.normalize(payload); // pad with '=' if needed
  final decodedPayload = utf8.decode(base64Url.decode(normalized));
  final payloadMap = json.decode(decodedPayload);
  return payloadMap['sub'];
}
