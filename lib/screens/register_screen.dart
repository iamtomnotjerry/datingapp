import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:datingapp/firebase_options.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.pink[100]),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(labelText: 'Username'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.email, color: Colors.pink[100]),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.lock, color: Colors.pink[100]),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.lock, color: Colors.pink[100]),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });

                          await Firebase.initializeApp(
                            options: DefaultFirebaseOptions.currentPlatform,
                          );

                          if (_usernameController.text.isEmpty ||
                              _emailController.text.isEmpty ||
                              _passwordController.text.isEmpty ||
                              _confirmPasswordController.text.isEmpty) {
                            showSnackBar('Please fill in all the fields');
                          } else if (!isValidEmail(_emailController.text)) {
                            showSnackBar('Please enter a valid email address');
                          } else if (!isGmUitEmail(_emailController.text)) {
                            showSnackBar('Email must be from @gm.uit.edu.vn domain');
                          } else if (_passwordController.text != _confirmPasswordController.text) {
                            showSnackBar('Passwords do not match');
                          } else {
                            await registerUser(
                              _emailController.text,
                              _passwordController.text,
                            );
                          }

                          setState(() {
                            isLoading = false;
                          });
                        },
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(248, 187, 208, 1)),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
  }

  bool isGmUitEmail(String email) {
    return email.endsWith('@gmail.com');
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> registerUser(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacementNamed(context, '/login');

      print('User registered: ${userCredential.user?.uid}');
    } catch (e) {
      print('Error during registration: $e');

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            showSnackBar('This email address is already in use. Please use a different email.');
            break;
          case 'weak-password':
            showSnackBar('The password is too weak. Please choose a stronger password.');
            break;
          // Handle other error cases as needed
          default:
            showSnackBar('Registration failed. Please try again.');
        }
      } else {
        showSnackBar('Registration failed. Please try again.');
      }
    }
  }
}
