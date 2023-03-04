import 'package:flutter/material.dart';
import 'package:frontend/helpers/http_helper.dart';
import 'package:frontend/widgets/todo_dialog.dart';
import 'package:models/models.dart';

void main() {
  runApp(const MaterialApp(home: TodoApp()));
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});
  @override
  TodoAppState createState() => TodoAppState();
}

class TodoAppState extends State<TodoApp> {
  bool loading = true;
  List<TodoModel> _todos = [];

  @override
  void initState() {
    _getTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : _todos.isEmpty
              ? const Center(
                  child: Text('No Todos'),
                )
              : ListView.builder(
                  itemCount: _todos.length,
                  itemBuilder: (BuildContext context, int index) {
                    final todo = _todos[index];
                    return Dismissible(
                      key: Key(todo.id.toString()),
                      onDismissed: (_) => _deleteTodoAtIndex(index),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ListTile(
                        leading: Checkbox(
                          value: todo.status ?? false,
                          onChanged: (_) => _toggleTodoAtIndex(index),
                        ),
                        title: Text(
                          todo.task,
                          style: TextStyle(
                            decoration: (todo.status ?? false) ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Text(todo.description),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEditTodoDialog(context, todo, index),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await _showAddTodoDialog(context);
        },
      ),
    );
  }

  Future<void> _getTodos() async {
    _todos = [];
    try {
      final respose = await HttpHelper.instance.get<List<dynamic>?>('/todos');
      final todos = respose.data!.map((e) => TodoModel.fromMap(e as Map<String, dynamic>)).toList();
      setState(() {
        _todos.addAll(todos);
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _showAddTodoDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return TodoDialog(
          onUpdate: (todo) {
            setState(() {
              _todos.add(todo);
            });
          },
        );
      },
    );
  }

  void _deleteTodoAtIndex(int index) {
    HttpHelper.instance.delete('/todos', {'id': _todos[index].id});
    setState(() {
      _todos.removeAt(index);
    });
  }

  Future<TodoModel> _updateTodo(TodoModel todoModel) async {
    final response = await HttpHelper.instance.put<Map<String, dynamic>?>('/todos', todoModel.toMap());
    return TodoModel.fromMap(response.data!);
  }

  void _toggleTodoAtIndex(int index) {
    setState(() {
      bool status = _todos[index].status ?? false;
      _todos[index] = _todos[index].copyWith(status: !status);
      _updateTodo(_todos[index]);
    });
  }

  void _showEditTodoDialog(BuildContext context, TodoModel todo, int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return TodoDialog(
          onUpdate: (todo) {
            setState(() {
              _todos[index] = todo;
            });
          },
          todoModel: todo,
        );
      },
    );
  }
}
