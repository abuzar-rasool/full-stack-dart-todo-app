// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:backend/todo_service.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context, String id) async {
  final todoService = context.read<TodoService>();
  final todo = await todoService.getTodoById(int.parse(id));
  return Response.json(body: todo.toMap());
}
