import 'package:flutter/material.dart';
import 'package:park_app/pages/home/home_page.dart';

import '../../utils/app_color.dart';
import '../../widget/card_view.dart';
import '../../widget/forms/form_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  child: const Text('Iniciar Sesión')
                ),
            ]
          )
        ),
      ),
    );
  }
}