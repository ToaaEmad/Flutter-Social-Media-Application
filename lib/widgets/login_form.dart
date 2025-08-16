import 'package:flutter/material.dart';
import 'package:social_media_app/services/auth_service.dart';
import 'package:social_media_app/validators/auth_validators.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  
  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: AuthValidators.validateEmail,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            validator: AuthValidators.validatePassword,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await AuthService().signIn(
                  context: context,
                  email: emailController.text,
                  password: passwordController.text,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Login', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}