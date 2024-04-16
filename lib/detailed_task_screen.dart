import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DetailedTaskScreen extends StatefulWidget {
  final String taskName;
  final String taskDescription;
  final String taskKey;

  DetailedTaskScreen({
    required this.taskKey,
    required this.taskName,
    required this.taskDescription
  });

  @override
  _DetailedTaskScreenState createState() => _DetailedTaskScreenState();
}

class _DetailedTaskScreenState extends State<DetailedTaskScreen> {
  late TextEditingController _taskNameController;
  late TextEditingController _taskDescriptionController;

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController(text: widget.taskName);
    _taskDescriptionController = TextEditingController(text: widget.taskDescription);
  }

  void _updateTask() {
    final databaseReference = FirebaseDatabase.instance.ref().child('tasks').child(widget.taskKey);
    databaseReference.update({
      'name': _taskNameController.text,
      'description': _taskDescriptionController.text,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task updated successfully'),
        ),
      );
      // Navigate back to the list view after updating
      Navigator.of(context).pop();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update task: $error'),
        ),
      );
    });
  }

  void _deleteTask() {
    final databaseReference = FirebaseDatabase.instance.ref().child('tasks').child(widget.taskKey);
    databaseReference.remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task deleted successfully'),
        ),
      );
      // Navigate back to the list view after deleting
      Navigator.of(context).pop();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete task: $error'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Name:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _taskNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Task Description:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _taskDescriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _updateTask();
                  },
                  child: Text('Save Task'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _deleteTask();
                  },
                  child: Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}