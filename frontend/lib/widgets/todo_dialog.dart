// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/helpers/http_helper.dart';
import 'package:models/models.dart';

class TodoDialog extends StatefulWidget {
  final void Function(TodoModel todo) onUpdate;
  final TodoModel? todoModel;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TodoDialog({super.key, this.todoModel, required this.onUpdate});

  @override
  State<TodoDialog> createState() => _TodoDialogState();
}

class _TodoDialogState extends State<TodoDialog> {
  late TodoModel _todoModel;
  late bool _isSaving;

  @override
  void initState() {
    _isSaving = false;
    _todoModel = widget.todoModel ?? const TodoModel(task: '', description: '', status: false);
    super.initState();
  }

  _updateIsSaving(bool isSaving) {
    setState(() {
      _isSaving = isSaving;
    });
  }

  Future<TodoModel> _addTodo() async {
    final response = await HttpHelper.instance.post<Map<String, dynamic>?>('/todos', _todoModel.toMap());
    return TodoModel.fromMap(response.data!);
  }

  Future<TodoModel> _updateTodo() async {
    final response = await HttpHelper.instance.put<Map<String, dynamic>?>('/todos', _todoModel.toMap());
    return TodoModel.fromMap(response.data!);
  }

  Future<void> _saveTodo() async {
    _updateIsSaving(true);
    if (widget.todoModel != null) {
      _todoModel = await _updateTodo();
    } else {
      _todoModel = await _addTodo();
    }
    widget.onUpdate(_todoModel);
    Navigator.of(context).pop();
    _updateIsSaving(false);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: AbsorbPointer(
        absorbing: _isSaving,
        child: AlertDialog(
          title: Text(widget.todoModel == null ? 'Add Todo' : 'Edit Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isSaving) ...[
                TextFormField(
                  validator: textFormFieldValidate,
                  initialValue: _todoModel.task,
                  onChanged: (value) {
                    _todoModel = _todoModel.copyWith(task: value);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                TextFormField(
                  validator: textFormFieldValidate,
                  onChanged: (value) {
                    _todoModel = _todoModel.copyWith(description: value);
                  },
                  initialValue: _todoModel.description,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
              ] else
                const SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(widget.todoModel == null ? 'Add' : 'Save'),
              onPressed: () {
                if (widget.formKey.currentState!.validate()) {
                  _saveTodo();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String? textFormFieldValidate(value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }
}
