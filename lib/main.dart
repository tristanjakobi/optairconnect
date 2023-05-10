import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:optairconnect/pages/dashboard_page.dart';
import 'package:optairconnect/pages/device_page.dart';
import 'package:optairconnect/pages/devices_page.dart';
import 'package:optairconnect/pages/login_page.dart';
import 'package:optairconnect/pages/register_page.dart';
import 'package:optairconnect/pages/user_page.dart';
import 'package:optairconnect/pages/users_page.dart';
import 'firebase_options.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      }
    });

    return MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          colorScheme: const ColorScheme.light(
            background: Colors.white,
            primary: Color.fromRGBO(24, 144, 255, 100.0),
            secondary: Color.fromRGBO(255, 24, 24, 100.0),
            tertiary: Color.fromRGBO(114, 46, 209, 100.0),
            shadow: Color.fromRGBO(26, 26, 26, 100),
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontSize: 47.0,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(26, 26, 26, 100),
            ),
            titleMedium: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            bodyMedium: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(26, 26, 26, 100),
            ),
            bodySmall: TextStyle(
              fontSize: 16.0,
              color: Color.fromRGBO(26, 26, 26, 100),
            ),
          ),
        ),
        home: Scaffold(
            appBar: AppBar(
                toolbarHeight: 100.0,
                actions: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.filter),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip,
                    ),
                  ),
                ],
                backgroundColor: Colors.white,
                elevation: 0,
                leadingWidth: 100,
                leading: IconButton(
                  icon: Image.asset("assets/logo.png"),
                  onPressed: () {
                    print('Button pressed!');
                  },
                )),
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
                      context.go("/dashboard");
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
                  AboutListTile(
                    // <-- SEE HERE
                    icon: const Icon(
                      Icons.info,
                    ),
                    applicationIcon: Image.asset("assets/logo.png"),
                    applicationName: 'OptAir Connect',
                    applicationVersion: '1.0.1',
                    applicationLegalese: '2023 Gruenes Zuhause',
                    aboutBoxChildren: [],
                    child: const Text('About app'),
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
      builder: (context, state) =>
          const MaterialAppWithScaffold(body: LoginPage()),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) =>
          const MaterialAppWithScaffold(body: RegisterPage()),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) =>
          MaterialAppWithScaffold(body: DashboardPage()),
    ),
    GoRoute(
      path: '/devices',
      builder: (context, state) =>
          const MaterialAppWithScaffold(body: DevicesPage()),
    ),
    GoRoute(
      path: '/device',
      builder: (context, state) =>
          const MaterialAppWithScaffold(body: DevicePage()),
    ),
    GoRoute(
      path: '/admin/users',
      builder: (context, state) =>
          const MaterialAppWithScaffold(body: UsersPage()),
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
