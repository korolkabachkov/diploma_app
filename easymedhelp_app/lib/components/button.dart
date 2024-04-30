import 'package:easymedhelp_app/utils/configuration.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.width,
    required this.title,
    required this.onPressed,
    required this.disabled,
  });

  final double width;
  final String title;
  final bool disabled;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 56,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4, // Add elevation
          shadowColor: Colors.grey[400], // Add shadow color
          backgroundColor: EasyMedHelpConfiguration.primaryColor,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
