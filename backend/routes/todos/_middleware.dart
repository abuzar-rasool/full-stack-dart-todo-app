import 'package:backend/todo_service.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return handler
      .use(
        provider<TodoService>((context) => TodoService()),
      )
      .use(
        requestLogger(),
      );
}
