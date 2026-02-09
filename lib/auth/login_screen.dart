import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import  '../main.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('ALU Assistant Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),

            const SizedBox(height: 20),
            if (error.isNotEmpty) Text(error, style: const TextStyle(color: Colors.red)),

            ElevatedButton(
              onPressed: () {
                final success = AuthService.login(emailController.text, passwordController.text);
                if (success) {
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNav()));

                } else {
                  setState(() => error = 'Invalid email or password');
                }
              },
              child: const Text('Login'),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
              },
              child: const Text('Create an account'),
            )
          ],
        ),
      ),
    );
  }
}
