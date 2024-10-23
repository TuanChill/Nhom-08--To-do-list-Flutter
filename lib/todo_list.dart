import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class Task {
  final int id;
  final String name;
  final String description;
  DateTime? dateOfTask;
  String? startTime;
  String? endTime;

  Task(
      {required this.id,
      this.dateOfTask,
      this.startTime,
      this.endTime,
      required this.name,
      required this.description});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      dateOfTask: DateTime.parse(json['dateOfTask']),
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
}

class _TodoListPageState extends State<TodoListPage> {
  List<Task> todoList = [];
  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    final response = await http.get(
        Uri.parse('https://healing-beef-dd171c4892.strapiapp.com/api/tasks'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      setState(() {
        todoList = (jsonResponse['data'] as List)
            .map((todo) => Task.fromJson(todo))
            .toList();
      });
    } else {
      throw Exception('Failed to load todos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(
                  context, '/add-todo'); // Navigate to CreateTaskScreen
            },
            icon: Icon(Icons.add),
            label: Text('Add Todo'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(todoList[index].name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(todoList[index].description),
                      Text(
                          'Date: ${todoList[index].dateOfTask?.toLocal().toString().split(' ')[0]}'),
                      Text('Start Time: ${todoList[index].startTime}'),
                      Text('End Time: ${todoList[index].endTime}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => {
                          Navigator.pushNamed(context, '/edit-todo',
                              arguments: todoList[index])
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => {},
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
