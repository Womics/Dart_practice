import 'dart:io';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/say_hello/<name>', _nameHandler);

Response _rootHandler(Request req) {
  print(req.method);
  return Response.ok('Hello_Dart\n');
}

Response _nameHandler(Request request) {
  final name = request.params['name'];
  return Response.ok("こんにちは　$name さん\n"
      , headers: {'Content-Type': 'text/plain; charset=utf-8'});
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
