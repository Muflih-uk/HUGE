import 'package:flutter/material.dart';
import 'package:todo_app/Controller/todo_controller.dart';
import 'package:todo_app/Model/tasks.dart';

class TodoProvider extends ChangeNotifier {
  final TodoController _controller = TodoController();
  List<Todo> todos = [];

  TodoProvider(){
    loadTodos();
  }

  // Load the Todos
  Future<void> loadTodos() async{
    todos = await _controller.loadTodos();
    notifyListeners();
  }

  // Add todos in List
  void addTodo(String task){
    todos.add(Todo(task: task));
    _controller.saveTodos(todos);
    notifyListeners();
  }

  // Toggle the is Compelted or not
  void toggleDone(int index){
    todos[index].isDone = !todos[index].isDone;
    _controller.saveTodos(todos);
    notifyListeners();
  }

  // Update the Todo
  void updateTodo(int index, String newTask){
    todos[index].task = newTask;
    _controller.saveTodos(todos);
    notifyListeners();
  }

  // Remove Todo
  void removeTask(int index){
    todos.removeAt(index);
    _controller.saveTodos(todos);
    notifyListeners();
  }

  // Remove the All Todos
  void clearAll(){
    todos.clear();
    _controller.saveTodos(todos);
    notifyListeners();
  }

  void toggleAllDone(){
    bool allDone = todos.every((todo) => todo.isDone);
    for(var todo in todos){
      todo.isDone = !allDone;
    }
    _controller.saveTodos(todos);
    notifyListeners();
  }



}