import 'package:flutter/material.dart';
import 'package:todo_app/Screens/Widgets/add_task_dialog.dart';
import 'package:todo_app/Screens/Widgets/todo_tile.dart';
import 'package:provider/provider.dart';
import '../Providers/todo_provider.dart';

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final TextEditingController inputController = TextEditingController();

  void addTask(BuildContext context) {
    inputController.clear();
    showAddOrEditDialog(
      context: context,
      controller: inputController,
      title: 'Add Task',
      onConfirm: () {
        Provider.of<TodoProvider>(context, listen: false).addTodo(inputController.text);
      },
    );
  }

  void editTask(BuildContext context ,int index) {
    final provider = Provider.of<TodoProvider>(context, listen: false);
    inputController.text = provider.todos[index].task;
    showAddOrEditDialog(
      context: context,
      controller: inputController,
      title: 'Edit Task',
      onConfirm: () {
        provider.updateTodo(index, inputController.text);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
        actions: [
          if (provider.todos.isNotEmpty)
            IconButton(icon: const Icon(Icons.delete), onPressed: provider.clearAll),
          if (provider.todos.isNotEmpty)
            IconButton(icon: const Icon(Icons.checklist_rounded), onPressed: provider.toggleAllDone),
        ],
      ),
      body: ListView.builder(
        itemCount: provider.todos.length,
        itemBuilder: (_, index) {
          return TodoTile(
            index: index,
            onEdit: () => editTask(context,index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addTask(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
