// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var email = "";
  var password = "";

  void login() async {
    final User? user = (await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    if (user != null) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        context.go('/dashboard');
      }
    });
    return Card(
      child: Column(
        children: [
          const Text("Email"),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              autofocus: true,
              onChanged: (value) => {
                setState(() {
                  email = value;
                })
              },
            ),
          ),
          const Text("Password"),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              autofocus: true,
              onChanged: (value) => {
                setState(() {
                  password = value;
                })
              },
            ),
          ),
          ElevatedButton(
              onPressed: () => {login()}, child: const Text("Login!"))
        ],
      ),
    );
  }
}
