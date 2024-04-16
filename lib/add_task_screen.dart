import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'tasks_screen.dart';

class AddTaskScreen extends StatelessWidget {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: taskNameController,
              decoration: InputDecoration(
                labelText: 'Task Name',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: taskDescriptionController,
              decoration: InputDecoration(
                labelText: 'Task Description',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addTask(context);
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }

  void _addTask(BuildContext context) {
    final databaseReference = FirebaseDatabase.instance.ref();

    // Get task name and description from text fields
    String taskName = taskNameController.text;
    String taskDescription = taskDescriptionController.text;

    // Write task data to the database
    databaseReference.child('tasks').push().set({
      'name': taskName,
      'description': taskDescription,
    }).then((_) {
      // Task added successfully, navigate back to TasksScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TasksScreen()),
      );
    }).catchError((error) {
      // An error occurred while adding task
      print('Error adding task: $error');
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add task. Please try again.'),
        ),
      );
    });
  }
}