import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:optairconnect/pages/device.dart';
import 'package:optairconnect/pages/devices.dart';
import 'package:optairconnect/pages/login.dart';
import 'package:optairconnect/pages/register.dart';
import 'package:optairconnect/pages/userpage.dart';
import 'package:optairconnect/pages/users.dart';
import 'firebase_options.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(App());
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class MaterialAppWithScaffold extends StatelessWidget {
  const MaterialAppWithScaffold({super.key, this.body});
  final body;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        context.go('/');
      } else {
        context.go('/devices');
      }
    });

    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              actions: [FloatingActionButton(onPressed: () => {})],
              title: const Text("OptAir Connect"),
            ),
            body: body));
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MaterialAppWithScaffold(body: Login()),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) =>
          const MaterialAppWithScaffold(body: Register()),
    ),
    GoRoute(
      path: '/devices',
      builder: (context, state) =>
          const MaterialAppWithScaffold(body: Devices()),
    ),
    GoRoute(
      path: '/device',
      builder: (context, state) =>
          const MaterialAppWithScaffold(body: Device()),
    ),
    GoRoute(
      path: '/admin/users',
      builder: (context, state) => const MaterialAppWithScaffold(body: Users()),
    ),
    GoRoute(
      path: '/admin/user',
      builder: (context, state) =>
          const MaterialAppWithScaffold(body: UserPage()),
    ),
  ],
);

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const MaterialApp(title: "Error");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp.router(
            routerConfig: _router,
          );
        }
        return const MaterialApp(title: "Loading");
      },
    );
  }
}
