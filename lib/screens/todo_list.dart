// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api_flutter/screens/add_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print('initState called'); // Debug print
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    print('build called with ${items.length} items'); // Debug print
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchTodo,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(item['title'] ?? ''),
                    subtitle: Text(item['description'] ?? ''),
                    trailing: PopupMenuButton(onSelected: (value) {
                      if (value == 'edit') {
                        // perform edit
                        navigateToEditPage(item);
                      } else if (value == 'delete') {
                        // perform delete
                        deleteById(id);
                      }
                    }, itemBuilder: (context) {
                      return [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ];
                    }),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await navigateToAddPage();
          fetchTodo(); // Refresh list after adding
        },
        label: const Text('Add Todo'),
      ),
    );
  }

  Future<void> deleteById(String id) async {
    // delete the item
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final respnose = await http.delete(uri);
    // remote item from the list
    if (respnose.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      // show error
    }
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => const AddTodoPage());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route =
        MaterialPageRoute(builder: (context) => AddTodoPage(todo: item));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> fetchTodo() async {
    print('fetchTodo started'); // Debug print
    try {
      setState(() {
        isLoading = true;
      });

      final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
      final uri = Uri.parse(url);
      print('Making HTTP request to: $url'); // Debug print

      final response = await http.get(uri);
      print('Response status: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map;
        final result = json['items'] as List;
        setState(() {
          items = result;
        });
        print('Successfully parsed ${items.length} items'); // Debug print
      } else {
        print('Error: Status code ${response.statusCode}'); // Debug print
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Failed to fetch todos (Status: ${response.statusCode})'),
            ),
          );
        }
      }
    } catch (e) {
      print('Error in fetchTodo: $e'); // Debug print
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
          ),
        );
      }
    } finally {
      if (mounted) {
        // Check if widget is still mounted
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
