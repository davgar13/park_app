import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:park_app/pages/client/home/home_page.dart';
import 'package:park_app/pages/bidder/home/home_bidder_page.dart'; // Asumiendo que esta es la importación correcta
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
              const SizedBox(height: 10),
              FormLogin(
                formController: passwordController,
                labelText: 'Contraseña',
                icon: Icons.lock_rounded,
                messageError: 'Ingrese una contraseña válida',
                keyboardType: TextInputType.visiblePassword,
              ),
              ElevatedButton(
                onPressed: _loginUser,
                child: const Text('Iniciar Sesión'),
              ),
            ]
          )
        ),
      ),
    );
  }

  Future<void> _loginUser() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, ingrese todos los campos.'),
          backgroundColor: Colors.red,
        )
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve role from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();
      String role = userDoc.get('role');

      // Navigate based on role
      if (role == 'Cliente') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else if (role == 'Ofertante') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeBidderPage()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al iniciar sesión: $e'),
          backgroundColor: Colors.red,
        )
      );
    }
  }
}
