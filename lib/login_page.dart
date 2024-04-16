import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'tasks_screen.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _login(context);
              },
              child: Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }

  void _login(BuildContext context) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )
        .then((userCredential) {
      // User logged in successfully
      print('User logged in: ${userCredential.user}');
      // Navigate to the TasksScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TasksScreen()),
      );
    }).catchError((e) {
      // An error occurred while logging in
      print('Error logging in: $e');
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to log in. Please try again.'),
        ),
      );
    });
  }
}
