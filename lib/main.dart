import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_media_app/firebase_options.dart';
import 'package:social_media_app/screens/posts_screen.dart';
import 'screens/auth_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Media App',
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser != null
          ? const PostsScreen()
          : const AuthScreen(),
    );
  }
}
