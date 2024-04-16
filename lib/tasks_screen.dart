import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'add_task_screen.dart';
import 'detailed_task_screen.dart'; // Import the DetailedTaskScreen

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Map<dynamic, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  void _fetchTasks() async {
    final databaseReference = FirebaseDatabase.instance.ref().child('/tasks');

    databaseReference.get().then((snapshot) {
      setState(() {
        tasks = [];
        if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
          values.forEach((key, value) {
            tasks.add(value..['key'] = key); // Add key to task map
          });
        }
      });
    }).catchError((error) {
      print('Error fetching tasks: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to the detailed task screen with task details and key
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailedTaskScreen(
                    taskKey: tasks[index]['key'] ?? '',
                    taskName: tasks[index]['name'] ?? '',
                    taskDescription: tasks[index]['description'] ?? '',
                  ),
                ),
              ).then((_) {
                // Callback function to refresh tasks after navigating back
                _fetchTasks();
              });
            },
            child: ListTile(
              title: Text(tasks[index]['name'] ?? ''),
              subtitle: Text(tasks[index]['description'] ?? ''),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          ).then((_) {
            _fetchTasks();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}