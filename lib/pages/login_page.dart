// ignore_for_file: use_build_context_synchronously

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  bool registering = false;

  void login() async {
    final User? user = (await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    if (user != null) {
      await _auth.currentUser!.getIdToken(true);

      context.go('/dashboard');
    }
  }

  void pushFCMToken(String uid) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final tokenReference =
        FirebaseDatabase.instance.reference().child('FCMTokens/$uid');
    tokenReference.set(fcmToken);
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        pushFCMToken(user.uid);
        FirebaseAuth.instance.currentUser!.getIdToken(true);

        context.go('/dashboard');
      }
    });
    return Stack(children: [
      Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 249, 249, 249),
            Color.fromRGBO(195, 226, 255, 0.612),
          ],
        )),
      ),
      if (registering)
        const RegisterPage()
      else
        Card(
          color: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
          child: Column(
            children: [
              Text("Anmelden", style: Theme.of(context).textTheme.titleLarge),
              Text("Anmelden um die Geräte zu verwalten",
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text("Email"),
                    TextField(
                      style: Theme.of(context).textTheme.bodySmall,
                      autofocus: true,
                      onChanged: (value) => {
                        setState(() {
                          email = value;
                        })
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Password"),
                    TextField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: Theme.of(context).textTheme.bodySmall,
                      autofocus: true,
                      onChanged: (value) => {
                        setState(() {
                          password = value;
                        })
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shadowColor: Theme.of(context).colorScheme.shadow,
                      minimumSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    onPressed: () => {login()},
                    child: const Text("Login")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(150, 50),
                      foregroundColor: Theme.of(context).colorScheme.tertiary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    onPressed: () => {setState(() => registering = true)},
                    child: const Text("Registrieren")),
              ),
            ],
          ),
        ),
    ]);
  }
}

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
      await FirebaseAuth.instance.currentUser!.getIdToken(true);
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      child: Column(
        children: [
          Text("Registrieren", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text("Email"),
                TextField(
                  style: Theme.of(context).textTheme.bodySmall,
                  autofocus: true,
                  onChanged: (value) => {
                    setState(() {
                      email = value;
                    })
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Passwort"),
                TextField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  style: Theme.of(context).textTheme.bodySmall,
                  autofocus: true,
                  onChanged: (value) => {
                    setState(() {
                      password = value;
                    })
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shadowColor: Theme.of(context).colorScheme.shadow,
                  minimumSize: const Size(150, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                onPressed: () => {register()},
                child: const Text("Register!")),
          ),
        ],
      ),
    );
  }
}
