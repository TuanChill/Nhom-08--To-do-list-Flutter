import 'package:flutter/material.dart';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<String> todoList = [];

  final TextEditingController _controller = TextEditingController();

  void _addTodo() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        todoList.add(_controller.text);
        _controller.clear();
      });
    }
  }

  void _editTodo(int index) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController editController = TextEditingController();
        editController.text = todoList[index];
        return AlertDialog(
          title: Text('Edit Todo'),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(hintText: 'Edit your todo'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  todoList[index] = editController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTodo(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Add new todo',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _addTodo,
            icon: Icon(Icons.add),  // Thêm icon dấu cộng
            label: Text('Add Todo'),  // Văn bản "Add Todo"
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(todoList[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editTodo(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteTodo(index),
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
