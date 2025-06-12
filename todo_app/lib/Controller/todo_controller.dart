import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/tasks.dart';

class TodoController {
  List<Todo> todos = [];

  // Load the Data in App Starting
  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('todos');
    if (data != null) {
      List decoded = json.decode(data);
      todos = decoded.map((e) => Todo.fromJson(e)).toList();
    }
  }

  // Store the todo in Local Storage
  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(todos.map((e) => e.toJson()).toList());
    await prefs.setString('todos', data);
  }
  // Add task in Todo List
  void addTodo(String task) {
    todos.add(Todo(task: task));
    saveTodos();
  }

  void updateTodo(int index, String newtask) {
    todos[index].task = newtask;
    saveTodos();
  }

  void toggleDone(int index) {
    todos[index].isDone = !todos[index].isDone;
    saveTodos();
  }

  void removeTodo(int index) {
    todos.removeAt(index);
    saveTodos();
  }

  void clearAll() {
  todos.clear();
  saveTodos();
  }
}
