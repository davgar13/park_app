import 'package:flutter/material.dart';

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
            ]
          )
        ),
      ),
    );
  }
}
