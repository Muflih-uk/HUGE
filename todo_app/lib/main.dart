import 'package:flutter/material.dart';

void main() {
  runApp(ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do App',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: const ToDoHome(),
    );
  }
}

class ToDoHome extends StatefulWidget {
  const ToDoHome({super.key});

  @override
  State<ToDoHome> createState() => _ToDoHomeState();
}

class _ToDoHomeState extends State<ToDoHome> {

  final List<String> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  void _addTask(){
    if(_controller.text.isNotEmpty){
      setState(() {
        _tasks.add(_controller.text);
        _controller.clear();
      });
    }
  }

  void _removeTask(int index){
    setState(() {
      _tasks.removeAt(index);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsetsGeometry.only(top: 30,left: 10,right: 10),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter Task',
                suffixIcon: IconButton(onPressed: _addTask, icon: Icon(Icons.add))
              ),
              onSubmitted: (_) => _addTask(),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder:  (_, index) => Card(
                  child: ListTile(
                    title: Text(_tasks[index]),
                    trailing: IconButton(
                      onPressed: () => _removeTask(index),
                      icon: Icon(Icons.delete, color: Colors.red)
                    ),
                  ),
                )
              ) 
            )
          ],
        ),
      ),
      bottomSheet: BottomAppBar(
        color: Colors.white,
        height: 40,
        child: Text("Designed By Muflih",style: TextStyle(fontSize: 10),),
        ),
    );
  }
}
