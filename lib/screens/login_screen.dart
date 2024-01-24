import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:datingapp/firebase_options.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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

                          if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                            showToast('Please fill in all the fields');
                          } else {
                            await loginUser(
                              _emailController.text,
                              _passwordController.text,
                            );
                          }

                          setState(() {
                            isLoading = false;
                          });
                        },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(248, 187, 208, 1)),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          // Add navigation to the "Forgot your password?" screen
                          // For example: Navigator.pushNamed(context, '/forgot_password');
                          showToast('Navigate to the "Forgot your password?" screen');
                        },
                  child: Text('Forgot your password?'),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              // Add navigation to the "Register" screen
                              // For example: Navigator.pushNamed(context, '/register');
                              Navigator.pushNamed(context, '/register');
                            },
                      child: Text('Register'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(const Color.fromRGBO(252, 228, 236, 1)), // Set the color to pink
                ),
              ),
            ),
        ],
      ),
    );
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  Future<void> loginUser(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacementNamed(context, '/HomeScreen');

    } catch (e) {
      print('Error during login: $e');

      if (e is FirebaseAuthException) {
        
        switch (e.code) {
          case 'invalid-email':
            showToast('User not found. Please check your email or register.');
            break;
          case 'invalid-credential':
            showToast('User not found or Wrong password');
            break;
          // Handle other error cases as needed
          default:
            showToast('Login failed. Please try again.');
        }
      } else {
        showToast('Login failed. Please try again.');
      }
    }
  }
}
