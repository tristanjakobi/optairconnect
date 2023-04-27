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
              actions: const [],
              title: const Text("OptAir Connect"),
            ),
            body: body,
            endDrawer: Drawer(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  const UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Colors.white),
                    accountName: Text(
                      "Pinkesh Darji",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    accountEmail: Text(
                      "pinkesh.earth@gmail.com",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    currentAccountPicture: FlutterLogo(),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.train,
                    ),
                    title: const Text('Dashboard'),
                    onTap: () {
                      context.go("/");
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.home,
                    ),
                    title: const Text('Devices'),
                    onTap: () {
                      context.go("/devices");
                    },
                  ),
                  const AboutListTile(
                    // <-- SEE HERE
                    icon: Icon(
                      Icons.info,
                    ),
                    applicationIcon: Icon(
                      Icons.local_play,
                    ),
                    applicationName: 'My Cool App',
                    applicationVersion: '1.0.25',
                    applicationLegalese: '© 2019 Company',
                    aboutBoxChildren: [
                      ///Content goes here...
                    ],
                    child: Text('About app'),
                  ),
                ],
              ),
            )));
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
