import 'dart:async';

import 'package:datingapp/widgets/map_widget.dart';
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

    // Use Future.delayed to schedule the navigation after the build has completed
    Future.delayed(Duration.zero, () {
      // If the current user is null, navigate to the login screen
      if (currentUser == null) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        // If the email is not verified, navigate to the verification screen
        // if (!currentUser.emailVerified) {
        //   Navigator.pushReplacementNamed(context, '/verify');
        // }
      }
    });

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
        child: MapSample(),
      ),
    );
  }
}
