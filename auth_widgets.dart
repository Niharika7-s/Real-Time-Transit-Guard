import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType keyboard;

  const AuthTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.keyboard = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        validator: (v) => v == null || v.isEmpty ? 'Please enter $hint' : null,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.teal.shade50,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15), 
            borderSide: BorderSide(color: Colors.teal.shade400, width: 2)
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15), 
            borderSide: BorderSide(color: Colors.teal.shade100)
          ),
        ),
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16), 
        backgroundColor: Colors.teal.shade600, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), 
        elevation: 8
      ),
      child: Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}




