import 'package:flutter/material.dart';
import 'todo_list.dart';
import 'update.dart';
import 'create.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      initialRoute: '/',
      routes: {
        '/': (context) => TodoListPage(),
        '/add-todo': (context) => CreateTaskScreen(),
        '/edit-todo': (context) => EditTaskScreen(),
      },
    );
  }
}
