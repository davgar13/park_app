import 'package:flutter/material.dart';

class ReturnPage extends StatelessWidget{
  final Color colorBackground;
  final Color colorIcon;

  const ReturnPage({Key? key, required this.colorBackground, required this.colorIcon}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pop(context);
      },
      mini: true,
      backgroundColor: colorBackground,
      child: Icon(
        Icons.arrow_back,
        color: colorIcon,
      ),
    );
  }
}
