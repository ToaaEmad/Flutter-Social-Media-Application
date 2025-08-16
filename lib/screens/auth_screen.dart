import 'package:flutter/material.dart';
import 'package:social_media_app/widgets/login_form.dart';
import 'package:social_media_app/widgets/register_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  final _registerNameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();

  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _isLogin ? 'Welcome Back!' : 'Create Account',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                _isLogin
                    ? LoginForm(
                        formKey: _loginFormKey,
                        emailController: _loginEmailController,
                        passwordController: _loginPasswordController,
                      )
                    : RegisterForm(
                        formKey: _registerFormKey,
                        nameController: _registerNameController,
                        emailController: _registerEmailController,
                        passwordController: _registerPasswordController,
                        onRegisterSuccess: () {
                          setState(() {
                            _isLogin = true;
                          });
                        },
                      ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLogin ? 'Don\'t have an account?' : 'Already have an account?',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Text(
                          _isLogin ? ' Register' : ' Login',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}