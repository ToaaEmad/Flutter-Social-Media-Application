import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/screens/auth_screen.dart';
// import 'package:social_media_app/widgets/login_form.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 32),
                  tooltip: 'Back',
                  color: Colors.deepPurple,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AuthScreen()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 32),
                  tooltip: 'Reload',
                  color: Colors.deepPurple,
                  onPressed: () async {
                    await FirebaseAuth.instance.currentUser?.reload();
                    if (FirebaseAuth.instance.currentUser?.emailVerified == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Email verified successfully!',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AuthScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Email not verified yet.')),
                      );
                    }
                  },
                ),
              ],
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Please verify your email address.',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
                    },
                    child: const Text('Resend Verification Email'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
