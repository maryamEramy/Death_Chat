import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final String title;
  final VoidCallback onPressed;

  const RoundedButton({
    super.key,
    required this.title,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        color: color,
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 400.0,
          height: 42.0,
          child: Text(title, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
