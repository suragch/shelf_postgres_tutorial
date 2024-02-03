import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_server/database.dart';
import 'package:shelf_server/router.dart';
import 'package:shelf_server/service_locator.dart';

Future<void> main(List<String> args) async {
  await _initializeDatabase();
  await _startServer();
}

Future<void> _initializeDatabase() async {
  setupServiceLocator();
  await getIt<Database>().init();
}

Future<void> _startServer() async {
  final ip = InternetAddress.anyIPv4;
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
