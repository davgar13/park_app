import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Function() onPressed;
  final Color backgroundColor;
  final String text;
  final Color textColor;
  final double borderRadius;
  final double width;
  final double fontSize;
  final Color? colorBorder;
  const PrimaryButton({super.key, 
    required this.onPressed, 
    required this.backgroundColor, 
    required this.text, 
    required this.textColor, 
    required this.borderRadius, 
    required this.width, 
    required this.fontSize, 
    this.colorBorder,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, 
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(color: colorBorder ?? Colors.transparent)
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: width,
        child: Center(
          child:  Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      )
    );
  }
}