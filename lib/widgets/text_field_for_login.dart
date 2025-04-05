import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget{
  final String labelText;
  final String hintText;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final Function() TextEditingController;
  final ValueChanged<String> onChanged;

  const TextFieldCustom({required this.labelText, required this.hintText, required this.TextEditingController, required this.onChanged, required this.suffixIcon, required this.prefixIcon});


  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.green,
      style: TextStyle(color: Colors.green),
      obscureText: false,
      onChanged: onChanged,
      controller: TextEditingController(),
      decoration: InputDecoration(
        suffixIcon: Icon(suffixIcon, color: Colors.grey,),
        prefixIcon: Icon(prefixIcon, color: Colors.grey,),
        fillColor: Colors.green.shade50,
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.green),
        hintStyle: TextStyle(color: Colors.grey),
        focusColor: Colors.green.shade50,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(width: 2,color: Colors.green)
        ),
      ),
    );
  }

}