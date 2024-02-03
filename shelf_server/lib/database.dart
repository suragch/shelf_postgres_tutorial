import 'package:nanoid2/nanoid2.dart';
import 'package:postgres/postgres.dart';

class Database {
  late Connection _db;

  Future<void> init() async {
    _db = await Connection.open(
      Endpoint(
        host: 'localhost',
        database: 'mydb',
        username: 'app_user',
        password: 'hKbeMj7g98BGs7b2',
      ),
      settings: ConnectionSettings(sslMode: SslMode.disable),
    );
  }

  Future<Map<String, dynamic>> create(String userId, int score) async {
    final query =
        Sql.named('INSERT INTO scores (id, created, updated, user_id, score) '
            'VALUES (@id, @created, @updated, @userId, @score)');

    final now = DateTime.now().toUtc().toIso8601String();
    final values = {
      'id': nanoid(length: 15),
      'created': now,
      'updated': now,
      'userId': userId,
      'score': score,
    };

    try {
      await _db.execute(
        query,
        parameters: values,
      );
      return values;
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<List<Map<String, dynamic>>> read() async {
    final rows = <Map<String, dynamic>>[];
    try {
      final result = await _db.execute('SELECT * FROM scores');
      for (final row in result) {
        rows.add(row.toColumnMap());
      }
    } catch (e) {
      print('error: $e');
    }
    return rows;
  }

  Future<Map<String, dynamic>> update(String id, int score) async {
    final query = Sql.named('UPDATE scores '
        'SET score = @score, updated = @updated '
        'WHERE id = @id');

    final values = {
      'id': id,
      'updated': DateTime.now().toUtc().toIso8601String(),
      'score': score,
    };

    try {
      await _db.execute(
        query,
        parameters: values,
      );
      return values;
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> delete(String id) async {
    final query = Sql.named('DELETE FROM scores '
        'WHERE id = @id');

    try {
      await _db.execute(
        query,
        parameters: {'id': id},
      );
      return {'message': 'successfully deleted $id'};
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
