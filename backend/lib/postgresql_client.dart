import 'package:postgres/postgres.dart';

/// A PostgressSQLClient that maintains a connection in a singelton
class PostgreSQLClient {
  static PostgreSQLConnection? _connection;

  /// Returns a Future that resolves to a PostgreSQLConnection object.
  ///
  /// If the connection has not been established yet, it will open a new connection using the `_openConnection` method.
  static Future<PostgreSQLConnection> get getConnection async {
    if (_connection == null) await _openConnection();
    return _connection!;
  }

  /// Returns a Future that resolves when the connection is closed.
  ///
  /// If the connection has not been established yet, this method does nothing.
  static Future<void> get disconnect async {
    if (_connection != null) await _closeConnection();
  }


  static Future<void> _openConnection() async {
    _connection = PostgreSQLConnection(
      'localhost',
      5432,
      'todo_app',
      username: 'postgres',
      password: '1234567890',
    );
    await _connection?.open();
  }

  static Future<void> _closeConnection() async {
    await _connection?.close();
  }
}
