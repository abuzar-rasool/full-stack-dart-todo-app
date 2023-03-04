import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class Todo {
  final String title;
  final String description;
  bool isCompleted;

  Todo({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final List<Todo> _todos = [];

  final TextEditingController _titleTextEditingController = TextEditingController();
  final TextEditingController _descriptionTextEditingController = TextEditingController();

  void _addTodo() {
    final title = _titleTextEditingController.text.trim();
    final description = _descriptionTextEditingController.text.trim();
    if (title.isNotEmpty && description.isNotEmpty) {
      setState(() {
        _todos.add(Todo(title: title, description: description));
      });
      _titleTextEditingController.clear();
      _descriptionTextEditingController.clear();
    }
  }

  void _updateTodoAtIndex(int index, Todo updatedTodo) {
    setState(() {
      _todos[index] = updatedTodo;
    });
  }

  void _deleteTodoAtIndex(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _toggleTodoAtIndex(int index) {
    setState(() {
      _todos[index].isCompleted = !_todos[index].isCompleted;
    });
  }

  void _showEditTodoDialog(BuildContext context, Todo todo) {
    final titleController = TextEditingController(text: todo.title);
    final descriptionController = TextEditingController(text: todo.description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                final updatedTodo = Todo(
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  isCompleted: todo.isCompleted,
                );
                _updateTodoAtIndex(_todos.indexOf(todo), updatedTodo);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Todo List'),
        ),
        body: _todos.isEmpty
            ? const Center(
                child: Text('No Todos'),
              )
            : ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (BuildContext context, int index) {
                  final todo = _todos[index];
                  return ListTile(
                    leading: Checkbox(
                      value: todo.isCompleted,
                      onChanged: (_) => _toggleTodoAtIndex(index),
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(todo.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showEditTodoDialog(context, todo),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            print("Add Todo");
            _showAddTodoDialog(context);
          },
        ),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleTextEditingController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: _descriptionTextEditingController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                _addTodo();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
