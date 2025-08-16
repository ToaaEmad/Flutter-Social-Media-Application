import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/screens/email_verification_screen.dart';
import 'package:social_media_app/screens/posts_screen.dart';
import 'package:social_media_app/services/firestore_service.dart';

class AuthService {
  Future<void> signUp({
    required BuildContext context,
    required String email,
    required String password,
    required String userName,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await userCredential.user!.updateProfile(displayName: userName);
        await userCredential.user!.sendEmailVerification();
        await FirestoreService().addUser(
          userId: userCredential.user!.uid,
          userName: userName,
          email: email,
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registration successful!\nAn email has been sent to ${userCredential.user!.email} for verification.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registration failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      // UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (FirebaseAuth.instance.currentUser?.emailVerified == false) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EmailVerificationScreen()),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successful!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PostsScreen()),
      );
      // return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
      // return false;
    }
  }
}
