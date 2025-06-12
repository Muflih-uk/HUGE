import 'package:flutter/material.dart';
import 'package:todo_app/Controller/todo_controller.dart';

class TodoTile extends StatelessWidget {
  final int index;
  final TodoController controller;
  final VoidCallback onChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TodoTile({
    super.key,
    required this.index,
    required this.controller,
    required this.onChanged,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final todo = controller.todos[index];
    return ListTile(
      title: Text(
        todo.task,
        style: TextStyle(
          decoration: todo.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      leading: Checkbox(
        value: todo.isDone,
        onChanged: (_) => onChanged(),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
          IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
        ],
      ),
    );
  }
}
