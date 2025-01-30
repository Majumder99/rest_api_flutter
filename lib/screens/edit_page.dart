import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditTodoPage extends StatefulWidget {
  final Map? todo;
  

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  // controller is used to change or add value
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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
            controller: titleController,
            decoration: InputDecoration(labelText: "Title"),
          ),
          TextField(
            controller: descriptionController,
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

  Future<void> submitTodo() async {
    // Get the data from form
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    // submit data to the server
    final url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': "application/json"});

    // show success or fail message
    if (response.statusCode == 201) {
      titleController.text = "";
      descriptionController.text = "";
      showSuccessMessage("Creation Success");
    } else {
      showSuccessMessage("Creation Failed");
      print(response.body);
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
            color: message == "Creation Success" ? Colors.white : Colors.red),
      ),
      backgroundColor:
          message == "Creation Success" ? Colors.green : Colors.white,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
