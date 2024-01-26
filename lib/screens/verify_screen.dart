import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyCodeScreen extends StatefulWidget {
  @override
  _VerifyCodeScreenState createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool isSent = false;

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
        backgroundColor: Colors.pink[100],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please verify the email ${user?.email}',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await verifyEmail(user);
                } on FirebaseAuthException catch (e) {
                  handleVerificationError(context, e);
                } catch (e) {
                  print('Unexpected error during verification: $e');
                }
              },
              child: Text(isSent ? 'Already Confirmed the Verification Email' : 'Send Verification Email'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(248, 187, 208, 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> verifyEmail(User? user) async {
    await user?.reload();
    user = FirebaseAuth.instance.currentUser;
    if (user?.emailVerified == true) {
      Navigator.pushReplacementNamed(context, '/HomeScreen');
    } else {
      if (!isSent) {
        await user?.sendEmailVerification();
        setState(() {
          isSent = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification email sent. Check your inbox and click on the link to complete the verification.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification email already sent. Check your inbox and click on the link to complete the verification.'),
          ),
        );
      }
    }
  }

  void handleVerificationError(BuildContext context, FirebaseAuthException e) {
    if (e.code == 'expired-action-code') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification code has expired. Please request a new one.'),
        ),
      );
      setState(() {
        isSent = false;
      });
    } else {
      print('Error during verification: $e');
      // Handle other Firebase authentication errors as needed
    }
  }
}
