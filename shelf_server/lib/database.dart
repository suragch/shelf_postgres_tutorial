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
            'VALUES (@id, @created, @updated, @user_id, @score)');

    final now = DateTime.now().toUtc().toIso8601String();
    final values = {
      'id': nanoid(length: 15),
      'created': now,
      'updated': now,
      'user_id': userId,
      'score': score,
    };

    await _db.execute(
      query,
      parameters: values,
    );
    return values;
  }

  Future<List<Map<String, dynamic>>> read() async {
    final rows = <Map<String, dynamic>>[];
    final result = await _db.execute('SELECT * FROM scores');
    for (final row in result) {
      rows.add(row.toColumnMap());
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

    await _db.execute(
      query,
      parameters: values,
    );
    return values;
  }

  Future<void> delete(String id) async {
    final query = Sql.named('DELETE FROM scores '
        'WHERE id = @id');

    await _db.execute(
      query,
      parameters: {'id': id},
    );
  }
}
