import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'database.dart';
import 'service_locator.dart';

Future<Response> createHandler(Request request) async {
  final body = await request.readAsString();
  final map = jsonDecode(body);
  final userId = map['user_id'];
  final score = map['score'];

  try {
    final db = getIt<Database>();
    final result = await db.create(userId, score);
    return Response.ok(jsonEncode(result));
  } catch (e) {
    print(e);
    return Response.internalServerError(body: 'Database error');
  }
}

Future<Response> readHandler(Request req) async {
  try {
    final db = getIt<Database>();
    final result = await db.read();
    return Response.ok(jsonEncode(result, toEncodable: _dateTimeEncoder));
  } catch (e) {
    print(e);
    return Response.internalServerError(body: 'Database error');
  }
}

String _dateTimeEncoder(dynamic object) {
  if (object is DateTime) {
    return object.toUtc().toIso8601String();
  }
  return object;
}

Future<Response> updateHandler(Request request) async {
  final body = await request.readAsString();
  final map = jsonDecode(body);
  final id = map['id'];
  final score = map['score'];

  try {
    final db = getIt<Database>();
    final result = await db.update(id, score);
    return Response.ok(jsonEncode(result, toEncodable: _dateTimeEncoder));
  } catch (e) {
    print(e);
    return Response.internalServerError(body: 'Database error');
  }
}

Future<Response> deleteHandler(Request request) async {
  final id = request.params['id'];
  if (id == null) {
    return Response.badRequest(body: 'id is required');
  }

  try {
    final db = getIt<Database>();
    await db.delete(id);
    return Response.ok('deleted');
  } catch (e) {
    print(e);
    return Response.internalServerError(body: 'Database error');
  }
}
