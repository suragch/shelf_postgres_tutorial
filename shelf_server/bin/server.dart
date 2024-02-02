import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_server/database/postgres.dart';
import 'package:shelf_server/request_handlers.dart';
import 'package:shelf_server/service_locator.dart';

final _router = Router()
  ..post('/create', createHandler)
  ..get('/read', readHandler)
  ..put('/update', updateHandler)
  ..delete('/delete/<id>', deleteHandler);

void main(List<String> args) async {
  // Initialize database
  setupServiceLocator();
  await getIt<Database>().init();

  // Start server
  final ip = InternetAddress.anyIPv4;
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
