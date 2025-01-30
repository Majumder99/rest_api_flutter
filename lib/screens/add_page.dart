import 'package:flutter/material.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todo"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(
            decoration: InputDecoration(labelText: "Title"),
          ),
          TextField(
            decoration: InputDecoration(labelText: "Description"),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 10,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: submitTodo,
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }

  void submitTodo() {
    // Get the data from form
    // submit data to the server 
    // show success or fail message
  }
}
