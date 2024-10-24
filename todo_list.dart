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
  bool completed;

  Task({
    required this.id,
    required this.name,
    required this.description,
    this.completed = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['title'], // JSONPlaceholder uses 'title' for the task name
      description: json['description'] ?? '', // Placeholder if 'description' isn't available
      completed: json['completed'] ?? false,
    );
  }
}

class _TodoListPageState extends State<TodoListPage> {
  List<Task> todoList = [];

  @override
  void initState() {
    super.initState();
    _fetchTodos(); // Fetch todos when page loads
  }

  // Fetch todos from JSONPlaceholder API
  Future<void> _fetchTodos() async {
    final response =
    await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      setState(() {
        todoList = (jsonResponse as List)
            .map((todo) => Task.fromJson(todo))
            .toList();
      });
    } else {
      throw Exception('Failed to load todos');
    }
  }

  // Function to update a task (PUT request)
  Future<void> _updateTask(Task updatedTask) async {
    final response = await http.put(
      Uri.parse('https://jsonplaceholder.typicode.com/todos/${updatedTask.id}'),
      body: jsonEncode({
        'title': updatedTask.name,
        'description': updatedTask.description,
        'completed': updatedTask.completed,
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      setState(() {
        final index = todoList.indexWhere((task) => task.id == updatedTask.id);
        todoList[index] = updatedTask;
      });
    } else {
      throw Exception('Failed to update task');
    }
  }

  // Function to delete a task (DELETE request)
  Future<void> _deleteTask(int taskId) async {
    final response = await http.delete(
      Uri.parse('https://jsonplaceholder.typicode.com/todos/$taskId'),
    );

    if (response.statusCode == 200) {
      setState(() {
        todoList.removeWhere((task) => task.id == taskId);
      });
    } else {
      throw Exception('Failed to delete task');
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
              Navigator.pushNamed(context, '/add-todo'); // Navigate to CreateTaskScreen
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
                      Text('Completed: ${todoList[index].completed ? "Yes" : "No"}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit button
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final updatedTask = await Navigator.pushNamed(
                            context,
                            '/edit-todo',
                            arguments: todoList[index],
                          );

                          if (updatedTask != null && updatedTask is Task) {
                            await _updateTask(updatedTask); // Call the update function
                          }
                        },
                      ),
                      // Delete button
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          bool? confirmDelete = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirm Delete'),
                              content: Text('Are you sure you want to delete this task?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirmDelete == true) {
                            await _deleteTask(todoList[index].id); // Call delete function
                          }
                        },
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
