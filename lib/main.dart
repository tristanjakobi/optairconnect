import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:optairconnect/pages/dashboard_page.dart';
import 'package:optairconnect/pages/device_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:optairconnect/pages/login_page.dart';
import 'package:optairconnect/pages/user_page.dart';
import 'firebase_options.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'pages/create_device_page.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('notification_icon');

void main() {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(App());
}

final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseMessaging messaging = FirebaseMessaging.instance;

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
          scaffoldBackgroundColor: const Color.fromARGB(255, 249, 249, 249),
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
            titleSmall: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
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
                  Builder(builder: (context) => const OptAirDrawerIcon()),
                ],
                backgroundColor: const Color.fromARGB(0, 249, 249, 249),
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
                    title: const Text('Logout'),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
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

class OptAirDrawerIcon extends StatelessWidget {
  const OptAirDrawerIcon({super.key});
  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    if (router.location != "/") {
      return IconButton(
        padding: const EdgeInsets.all(15),
        icon: Image.asset("assets/bars.png"),
        onPressed: () => Scaffold.of(context).openEndDrawer(),
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      );
    }
    return const Text("");
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
      path: '/dashboard',
      builder: (context, state) =>
          MaterialAppWithScaffold(body: DashboardPage()),
    ),
    GoRoute(
      path: '/device/:id',
      builder: (BuildContext context, GoRouterState state) {
        final id = state.pathParameters['id']!;
        return MaterialAppWithScaffold(body: DevicePage(id: id));
      },
    ),
    GoRoute(
      path: '/createdevice',
      builder: (BuildContext context, GoRouterState state) {
        return MaterialAppWithScaffold(body: CreateDevicePage());
      },
    ),
    GoRoute(
      path: '/account',
      builder: (context, state) => MaterialAppWithScaffold(body: UserPage()),
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
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
          const AndroidNotificationChannel channel = AndroidNotificationChannel(
            'high_importance_channel', // id
            'High Importance Notifications', // title
            importance: Importance.max,
          );

          RemoteNotification? notification = message.notification;
          AndroidNotification? android = message.notification?.android;

          // If `onMessage` is triggered with a notification, construct our own
          // local notification to show to users using the created channel.
          if (notification != null && android != null) {
            flutterLocalNotificationsPlugin.initialize(
              const InitializationSettings(
                  android: initializationSettingsAndroid),
            );

            flutterLocalNotificationsPlugin.show(
                notification.hashCode,
                notification.title,
                notification.body,
                NotificationDetails(
                  android: AndroidNotificationDetails(
                    channel.id,
                    channel.name,
                    icon: android.smallIcon,
                    // other properties...
                  ),
                ));
          }
        });

        askPermission();
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

  void askPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }
}
