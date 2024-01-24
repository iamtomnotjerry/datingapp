import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    print(currentUser?.emailVerified);
    // Use Future.delayed to schedule the navigation after the build has completed
    if (currentUser == null){
      Future.delayed(Duration.zero, () {
        // If the current user is null or email is not verified, navigate to the login screen
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
    
     if (!currentUser!.emailVerified) {
      Future.delayed(Duration.zero, () {
        // If the current user is null or email is not verified, navigate to the login screen
        Navigator.pushReplacementNamed(context, '/verify');
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // Sign out the current user
              await FirebaseAuth.instance.signOut();

              // After signing out, navigate to the login screen
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to the Home Page!'),
      ),
    );
  }
}
