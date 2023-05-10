import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var email = "";
  var password = "";

  void register() async {
    final User? user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    if (user != null) {
      context.go('/devices');
    }
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => {register()}, child: const Text("Login!"))
        ],
      ),
    );
  }
}
