class Todo {
  String task;
  bool isDone;

  Todo({
    required this.task,
    this.isDone = false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      task: json['task'],
      isDone: json['isDone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task': task,
      'isDone': isDone,
    };
  }
}
