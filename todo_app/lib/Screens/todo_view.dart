import 'package:flutter/material.dart';
import 'package:todo_app/Controller/todo_controller.dart';
import 'package:todo_app/Screens/Widgets/add_task_dialog.dart';
import 'package:todo_app/Screens/Widgets/todo_tile.dart';

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final TodoController controller = TodoController();
  final TextEditingController inputController = TextEditingController();
  bool selectA = false;

  @override
  void initState() {
    super.initState();
    controller.loadTodos().then((_) => setState(() {}));
  }

  void selectAll() {
    for (int i = 0; i < controller.todos.length; i++) {
      controller.toggleDone(i);
    }
    selectA = !selectA;
    setState(() {});
  }

  void addTask() {
    inputController.clear();
    showAddOrEditDialog(
      context: context,
      controller: inputController,
      title: 'Add Task',
      onConfirm: () {
        controller.addTodo(inputController.text);
        setState(() {});
      },
    );
  }

  void editTask(int index) {
    inputController.text = controller.todos[index].task;
    showAddOrEditDialog(
      context: context,
      controller: inputController,
      title: 'Edit Task',
      onConfirm: () {
        controller.updateTodo(index, inputController.text);
        setState(() {});
      },
    );
  }

  void deleteAll() {
    controller.clearAll();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
        actions: [
          if (selectA && controller.todos.isNotEmpty)
            IconButton(icon: const Icon(Icons.delete), onPressed: deleteAll),
          if (controller.todos.isNotEmpty)
            IconButton(icon: const Icon(Icons.checklist_rounded), onPressed: selectAll),
        ],
      ),
      body: ListView.builder(
        itemCount: controller.todos.length,
        itemBuilder: (_, index) {
          return TodoTile(
            index: index,
            controller: controller,
            onChanged: () {
              controller.toggleDone(index);
              selectA = !selectA;
              setState(() {});
            },
            onEdit: () => editTask(index),
            onDelete: () {
              controller.removeTodo(index);
              setState(() {});
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
