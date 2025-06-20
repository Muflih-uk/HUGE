import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:todo_app/Controller/todo_controller.dart';
import 'package:todo_app/Model/todo_model.dart';
import 'dart:convert';

class TodoProvider extends ChangeNotifier {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8000',
  ));

  final TodoController _controller = TodoController();
  List<TodoModel> todos = [];
  final String apiKey = 'mufi9605';

  TodoProvider() {
    loadTodos();
  }

  Future<void> loadTodos() async {
    try {
      final response = await dio.get('/tasks?api_key=$apiKey');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        todos = data.map((item) {
          return TodoModel(
            id: item[0],
            todo: item[1],
            isDone: item[2],
          );
        }).toList();
        _controller.saveTodos(todos);
      }
    } catch (e) {
      print("API fetch failed, loading from local: $e");
      todos = await _controller.loadTodos();
    }
    notifyListeners();
  }

  Future<void> postTodo(BuildContext context, TodoModel todo) async {
    try {
      final requestBody = {
        'task': todo.todo,
        'done': todo.isDone,
      };

      final response = await dio.post(
        '/tasks?api_key=$apiKey',
        data: json.encode(requestBody),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await loadTodos();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding todo: $e")),
      );
    }
  }

  Future<void> updateTodoById(BuildContext context, TodoModel todo, int index) async {
    try {
      final todoToUpdate = todos[index];

      final response = await dio.put(
        '/tasks/${todoToUpdate.id}?api_key=$apiKey',
        data: json.encode({
          'task': todo.todo,
          'done': todo.isDone,
        }),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        todos[index] = TodoModel(
          id: todoToUpdate.id,
          todo: todo.todo,
          isDone: todo.isDone,
        );
        _controller.saveTodos(todos);
        notifyListeners();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating todo: $e")),
      );
    }
  }

  Future<void> deleteTodo(BuildContext context, int index) async {
    try {
      final todoToDelete = todos[index];

      final response = await dio.delete(
        '/tasks/${todoToDelete.id}?api_key=$apiKey',
      );

      if (response.statusCode == 200) {
        todos.removeAt(index);
        _controller.saveTodos(todos);
        notifyListeners();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting todo: $e")),
      );
    }
  }

  /// ✅ Toggle single todo's `done` status
  Future<void> toggleDone(BuildContext context, int index) async {
    final todo = todos[index];
    final originalState = todo.isDone;

    // Update local state for instant UI feedback
    todo.isDone = !originalState;
    notifyListeners();

    try {
      final response = await dio.put(
        '/tasks/${todo.id}?api_key=$apiKey',
        data: json.encode({
          'task': todo.todo,
          'done': todo.isDone,
        }),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        _controller.saveTodos(todos);
      } else {
        // Revert on failure
        todo.isDone = originalState;
        notifyListeners();
      }
    } catch (e) {
      todo.isDone = originalState;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error toggling task: $e")),
      );
    }
  }

  /// ✅ Clear all todos
  Future<void> clearAll(BuildContext context) async {
    final originalTodos = List<TodoModel>.from(todos);
    List<TodoModel> failedDeletes = [];

    todos.clear();
    notifyListeners();

    for (var todo in originalTodos) {
      try {
        final response = await dio.delete('/tasks/${todo.id}?api_key=$apiKey');
        if (response.statusCode != 200) {
          failedDeletes.add(todo);
        }
      } catch (e) {
        failedDeletes.add(todo);
      }
    }

    if (failedDeletes.isNotEmpty) {
      todos = failedDeletes;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete ${failedDeletes.length} tasks")),
      );
    }

    _controller.saveTodos(todos);
  }

  /// ✅ Toggle all todos as done or not done
  Future<void> toggleAllDone(BuildContext context) async {
    final allDone = todos.every((todo) => todo.isDone);
    final originalStates = todos.map((t) => t.isDone).toList();
    List<int> failed = [];

    for (var t in todos) {
      t.isDone = !allDone;
    }
    notifyListeners();

    for (int i = 0; i < todos.length; i++) {
      try {
        final todo = todos[i];
        final response = await dio.put(
          '/tasks/${todo.id}?api_key=$apiKey',
          data: json.encode({
            'task': todo.todo,
            'done': todo.isDone,
          }),
          options: Options(headers: {'Content-Type': 'application/json'}),
        );
        if (response.statusCode != 200) {
          failed.add(i);
        }
      } catch (_) {
        failed.add(i);
      }
    }

    for (int i in failed) {
      todos[i].isDone = originalStates[i];
    }

    if (failed.isNotEmpty) {
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update ${failed.length} tasks")),
      );
    }

    _controller.saveTodos(todos);
  }
  bool deleteEveryTodo() {
    return todos.every((todo) => todo.isDone);
  }

}

