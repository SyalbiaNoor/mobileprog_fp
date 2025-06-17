import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  void login() async {
    try {
      await _auth.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Diary')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text('Log In')),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SignupScreen()));
              },
              child: const Text("Sign Up"),
            )
          ],
        ),
      ),
    );
  }
}
