import 'package:datingapp/screens/home_screen.dart';
import 'package:datingapp/screens/login_screen.dart';
import 'package:datingapp/screens/register_screen.dart';
import 'package:datingapp/screens/splash_screen.dart'; // Import the splash screen
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:datingapp/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/SplashScreen', // Set the initial route to the splash screen
      routes: {
        '/SplashScreen': (context) => SplashScreen(), // Add the splash screen route
        '/HomeScreen': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
