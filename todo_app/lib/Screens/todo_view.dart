import 'package:flutter/material.dart';
import '../Controller/todo_controller.dart';

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

  void selectAll(){
    for(int i=0; i<controller.todos.length;i++){
      controller.toggleDone(i);
    }
    selectA = !selectA;
    setState(() {});
  }

  void deleteAll(){
    for(int i=0; i<controller.todos.length;i++){
      controller.removeTodo(i);
    }
    setState(() {});
  }

  void showEditDialog(int index) {
    inputController.text = controller.todos[index].task;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Task"),
        content: TextField(controller: inputController),
        actions: [
          TextButton(
            onPressed: () {
              controller.updateTodo(index, inputController.text);
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
        actions: [
          selectA && controller.todos.isNotEmpty ? 
          IconButton(
            onPressed: deleteAll, 
            icon: Icon(Icons.delete)
          ) : Container(),
          controller.todos.isNotEmpty ?
          IconButton(
            onPressed: selectAll,
            icon: Icon(Icons.checklist_rounded)
          ) : Container()

        ],
      ),
      body: ListView.builder(
        itemCount: controller.todos.length,
        itemBuilder: (_, index) {
          final todo = controller.todos[index];
          return ListTile(
            title: Text(
              todo.task,
              style: TextStyle(
                decoration:
                    todo.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            leading: Checkbox(
              value: todo.isDone,
              onChanged: (_) {
                controller.toggleDone(index);
                setState(() {});
              },
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => showEditDialog(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    controller.removeTodo(index);
                    setState(() {});
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          inputController.clear();
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Add Task"),
              content: TextField(controller: inputController),
              actions: [
                TextButton(
                  onPressed: () {
                    controller.addTodo(inputController.text);
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text("Add"),
                )
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
