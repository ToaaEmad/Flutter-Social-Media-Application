import 'package:flutter/material.dart';
import 'package:social_media_app/services/auth_service.dart';
import 'package:social_media_app/validators/auth_validators.dart';

class RegisterForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onRegisterSuccess;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.onRegisterSuccess,
  });
  
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextFormField(
            controller: widget.nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
            ),
            validator: AuthValidators.validateName,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: AuthValidators.validateEmail,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.passwordController,
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
              if (widget.formKey.currentState!.validate()) {
                await AuthService().signUp(
                  context: context,
                  email: widget.emailController.text,
                  password: widget.passwordController.text,
                  userName: widget.nameController.text,
                );
                widget.onRegisterSuccess();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Register', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}