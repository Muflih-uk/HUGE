import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/tasks.dart';

class TodoController {

  // Load the Data in App Starting
  Future<List<Todo>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('todos') ?? [];
    return data.map((e) => Todo.fromJson(json.decode(e))).toList();
  }

  // Store the todo in Local Storage
  Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(todos.map((e) => e.toJson()).toList());
    await prefs.setString('todos', data);
  }
  
}
