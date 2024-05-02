import 'package:flutter/material.dart';

class FormLogin extends StatelessWidget {
  final TextEditingController formController;
  final String labelText;
  final IconData icon;
  final String messageError;
  final TextInputType? keyboardType;

  const FormLogin({
    super.key,
    required this.formController,
    required this.labelText,
    required this.icon,
    required this.messageError,
    this.keyboardType
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: formController,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
        )
      ),
      validator: (value){
        if(value!.isEmpty){
          return messageError;
        }
        return null;
      },
    );
  }
}