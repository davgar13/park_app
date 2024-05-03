import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/app_color.dart';
import '../../widget/card_view.dart';
import '../../widget/forms/form_login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CardView(
          marginCard: 20,
          padingContainer: 20,
          elevtion: 8, 
          borderRadius: 15, 
          color: AppColor.green, 
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormLogin(
                formController: nameController, 
                labelText: 'Nombre(s)', 
                icon: Icons.person, 
                messageError: 'Ingrese su nombre',
              ),
              const SizedBox(height: 10,),
              FormLogin(
                formController: surnameController, 
                labelText: 'Apellido(s)', 
                icon: Icons.person_outline, 
                messageError: 'Ingrese su apellido',
              ),
              const SizedBox(height: 10,),
              FormLogin(
                formController: emailController, 
                labelText: 'Correo Electrónico', 
                icon: Icons.email_rounded, 
                messageError: 'Ingrese un correo electrónico válido',
              ),
              const SizedBox(height: 10,),
              FormLogin(
                formController: passwordController, 
                labelText: 'Contraseña', 
                icon: Icons.lock_rounded, 
                messageError: 'Ingrese una contraseña válida',
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(height: 10,),
              DropdownButton<String>(
                value: selectedRole,
                hint: Text("Seleccione un rol"),
                icon: Icon(Icons.arrow_drop_down),
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRole = newValue;
                  });
                },
                items: <String>['Cliente', 'Ofertante']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUser,
                child: const Text('Guardar')
              ),
            ]
          )
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    FirebaseFirestore.instance.collection('users').add({
      'name': nameController.text,
      'surname': surnameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'role': selectedRole,
    });
  }
}
