import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:backend/todo_service.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  final todoService = context.read<TodoService>();

  switch (context.request.method) {
    case HttpMethod.get:
      final todos = await todoService.getAllTodos();
      return Response.json(body: todos.map((e) => e.toMap()).toList());
    case HttpMethod.post:
      final bodyMap = await jsonDecode(await context.request.body()) as Map<String, dynamic>;
      final todo = TodoModel.fromMap(bodyMap);
      final newTodo = await todoService.addTodo(todo: todo);
      return Response.json(statusCode: HttpStatus.created, body: newTodo.toMap());
    case HttpMethod.put:
      final bodyMap = await jsonDecode(await context.request.body()) as Map<String, dynamic>;
      final todo = TodoModel.fromMap(bodyMap);
      final newTodo = await todoService.updateTodo(todo: todo);
      return Response.json(body: newTodo.toMap());
    case HttpMethod.delete:
      final bodyMap = await jsonDecode(await context.request.body()) as Map<String, dynamic>;
      await todoService.deleteTodoById(bodyMap['id'] as int);
      return Response.json(
        statusCode: HttpStatus.noContent,
        body: {'message': 'Todo deleted successfully'},
      );
    case HttpMethod.patch:
    case HttpMethod.head:
    case HttpMethod.options:
      return Response.json(statusCode: HttpStatus.methodNotAllowed, body: {'message': 'Method not allowed'});
  }
}
