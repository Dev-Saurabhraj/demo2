
import 'package:flutter/material.dart';

class SignupButton extends StatelessWidget{
  final String text;
  final Function() onTap;
  const SignupButton({required this.text, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.grey,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 3))],
            color: Colors.green,
            borderRadius: BorderRadius.circular(25)
        ),
        child: Center(
          child: Text(
            text ,
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white
            ),
          ),
        ),

      ),
    )
    ;
  }
}