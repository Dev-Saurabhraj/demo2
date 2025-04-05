import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../widgets/signup_button_for_auth.dart';
import '../widgets/text_field_for_login.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  void _checkAutoLogin() async {
    final box = await Hive.openBox('authBox');
    final email = box.get('email');
    final password = box.get('password');

    if (email != null && password != null) {
      try {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        GoRouter.of(context).pushReplacementNamed('page_view');
      } catch (e) {
        print("Auto-login failed: $e");
      }
    }
  }

  Future<void> _loginUser() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    try {
      print('Logging in with username: $username, password: $password');
      final UserCredential newUser = await _auth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );

      if (newUser.user != null) {
        final box = await Hive.openBox('authBox');
        await box.put('email', username);
        await box.put('password', password);

        GoRouter.of(context).pushReplacementNamed('page_view');
      }
    } catch (e) {
      print('Login Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  cursorColor: Colors.green,
                  style: TextStyle(color: Colors.green),
                  obscureText: false,
                  onChanged: (value) {},
                  controller: _usernameController,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.person, color: Colors.grey),
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                    fillColor: Colors.green.shade50,
                    hintText: 'Username',
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.green),
                    hintStyle: TextStyle(color: Colors.grey),
                    focusColor: Colors.green.shade50,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(width: 2, color: Colors.green)),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  cursorColor: Colors.green,
                  style: TextStyle(color: Colors.green),
                  obscureText: false,
                  onChanged: (value) {},
                  controller: _passwordController,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.lock, color: Colors.grey),
                    prefixIcon: Icon(Icons.remove_red_eye, color: Colors.grey),
                    fillColor: Colors.green.shade50,
                    hintText: 'Password',
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.green),
                    hintStyle: TextStyle(color: Colors.grey),
                    focusColor: Colors.green.shade50,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(width: 2, color: Colors.green)),
                  ),
                ),
                SizedBox(height: 50),
                SignupButton(
                  text: 'Login',
                  onTap: _loginUser,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () => context.go('/'),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}