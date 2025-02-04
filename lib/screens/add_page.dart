import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  // controller is used to change or add value
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isEdit = false;

  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(!isEdit ? "Add Todo" : "Edit Todo"),
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
            onPressed: isEdit ? updateTodo : submitTodo,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(!isEdit ? "Submit" : "Edit"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateTodo() async {
    // Get the data from form
    final todo = widget.todo;
    if (todo == null) {
      print('You can not call updated without todo data');
      return;
    }
    final id = todo["_id"];
    final isCompleted = todo['is_completed'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": isCompleted,
    };
    // submit data to the server
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': "application/json"});

    // show success or fail message
    if (response.statusCode == 200) {
      titleController.text = "";
      descriptionController.text = "";
      showSuccessMessage("Update Success");
    } else {
      showSuccessMessage("Creation Failed");
      print(response.body);
    }
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
