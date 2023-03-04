
import 'package:backend/postgresql_client.dart';
import 'package:models/models.dart';

class TodoService {
  Future<List<TodoModel>> getAllTodos() async {
    final querResult = await (await PostgreSQLClient.getConnection).mappedResultsQuery(
      'SELECT * FROM todo',
    );
    return querResult.map((e) => TodoModel.fromMap(e['todo']!)).toList();
  }

  Future<TodoModel> getTodoById(int id) async {
    final querResult = await (await PostgreSQLClient.getConnection).mappedResultsQuery(
      'SELECT * FROM todo WHERE id = @id',
      substitutionValues: {
        'id': id,
      },
    );
    return TodoModel.fromMap(querResult.first['todo']!);
  }

  Future<TodoModel> addTodo({
    required TodoModel todo,
  }) async {
    final querResult = await (await PostgreSQLClient.getConnection).mappedResultsQuery(
      'INSERT INTO todo (task, description, status) VALUES (@task, @description, @status) RETURNING *',
      substitutionValues: {
        'task': todo.task,
        'description': todo.description,
        'status': todo.status ?? false,
      },
    );
    return TodoModel.fromMap(querResult.first['todo']!);
  }

  Future<TodoModel> updateTodo({
    required TodoModel todo,
  }) async {
    final querResult = await (await PostgreSQLClient.getConnection).mappedResultsQuery(
      'UPDATE todo SET task = @task, description = @description, status = @status WHERE id = @id RETURNING *',
      substitutionValues: {
        'id': todo.id,
        'task': todo.task,
        'description': todo.description,
        'status': todo.status,
      },
    );
    return TodoModel.fromMap(querResult.first['todo']!);
  }

  Future<void> deleteTodoById(int id) async {
    await (await PostgreSQLClient.getConnection).execute(
      'DELETE FROM todo WHERE id = @id',
      substitutionValues: {
        'id': id,
      },
    );
  }
}
