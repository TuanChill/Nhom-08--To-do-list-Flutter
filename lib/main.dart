import 'package:flutter/material.dart';
import 'update.dart';
import 'create.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edit Task',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
  //   home: const EditTaskScreen(),
     home: const CreateTaskScreen(),
    );
  }
}
