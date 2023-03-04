// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class TodoModel extends Equatable {
  const TodoModel({
    required this.task,
    required this.description,
    this.status,
    this.id,
  });

  factory TodoModel.fromMap(Map<String, dynamic> json) => TodoModel(
        id: json['id'] as int?,
        task: json['task'] as String,
        description: json['description'] as String,
        status: json['status'] as bool?,
      );

  final int? id;
  final String task;
  final String description;
  final bool? status;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    if (status != null) {
      map['status'] = status;
    }
    map['task'] = task;
    map['description'] = description;
    return map;
  }

  @override
  List<Object?> get props => [
        id,
        task,
        status,
        description,
      ];

  TodoModel copyWith({
    int? id,
    String? task,
    String? description,
    bool? status,
  }) {
    return TodoModel(
      id: id ?? this.id,
      task: task ?? this.task,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }
}
