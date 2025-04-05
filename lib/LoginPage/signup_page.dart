import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/signup_button_for_auth.dart';
import '../widgets/text_field_for_login.dart';


class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _auths = FirebaseAuth.instance;
  late String email2;
  late String username2;
  late String password2;

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
                    Text('Sign up',
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    Text('Create you account',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    SizedBox(
                      height: 50,
                    ),
                    TextFieldCustom(
                      onChanged: (username1) {
                        email2 = username1;
                      },
                      TextEditingController: () {},
                      labelText: 'Email address',
                      hintText: 'Email address',
                      suffixIcon: null,
                      prefixIcon: Icons.email,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFieldCustom(
                      onChanged: (username1) {
                        username2 = username1;
                      },
                      TextEditingController: () {},
                      labelText: 'Username',
                      hintText: 'Username',
                      suffixIcon: null,
                      prefixIcon: Icons.person,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFieldCustom(
                      onChanged: (password) {
                        password2 = password;
                      },
                      TextEditingController: () {},
                      labelText: 'Password',
                      hintText: 'Password',
                      suffixIcon: CupertinoIcons.eye,
                      prefixIcon: Icons.lock,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    SignupButton(
                        text: 'Sign up',
                        onTap: () async {
                          try {
                            final newUser =
                            await _auths.createUserWithEmailAndPassword(
                                email: email2, password: password2);
                            if (_auths.currentUser != null) {
                              context.push('/home');
                            }
                          } catch (e) {
                            print(e);
                          }
                        }),
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 25, left: 10, bottom: 30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account ?  ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          InkWell(
                              onTap: () => context.push('/login'),
                              child: Text('Login',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green)))
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 2,
                      color: Colors.grey.shade200,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Sign up with',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.grey.shade500),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BottomIcon(
                          icon: Icons.facebook,
                          color: CupertinoColors.activeBlue,
                        ),
                        BottomIcon(
                          icon: Icons.apple,
                          color: Colors.black,
                        ),
                        BottomIcon(
                          icon: Icons.snapchat,
                          color: Colors.red,
                        ),
                      ],
                    )
                  ],
                ),
              ))),
    );
  }
}

class BottomIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const BottomIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 40,
        width: 70,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          icon,
          size: 35,
          color: color,
        ),
      ),
    );
  }
}
