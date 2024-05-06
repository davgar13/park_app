import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/app_color.dart';
import '../../widget/card_view.dart';
import '../../widget/forms/form_login.dart';
import '../../pages/client/home/home_page.dart'; // Importa la página de inicio del cliente
import '../../pages/bidder/home/home_bidder_page.dart'; // Importa la página de inicio del ofertante

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedRole;
  late AnimationController _animationController;
  late Animation<double> _formOpacity;
  late Animation<Offset> _formPosition;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _formOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _formPosition = Tween<Offset>(begin: Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _iconRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    if (mounted) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro', style: TextStyle(color: AppColor.white)),
        backgroundColor: AppColor.primary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FadeTransition(
              opacity: _formOpacity,
              child: SlideTransition(
                position: _formPosition,
                child: CardView(
                  marginCard: 0,
                  paddingContainer: 20,
                  padingContainer: 20,
                  elevation: 8,
                  elevtion: 8,
                  borderRadius: 15,
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Regístrate",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primary,
                        ),
                      ),
                      RotationTransition(
                        turns: _iconRotation,
                        child: Icon(Icons.person_add, size: 40, color: AppColor.green),
                      ),
                      const SizedBox(height: 20),
                      FormLogin(
                        formController: nameController,
                        labelText: 'Nombre(s)',
                        icon: Icons.person,
                        messageError: 'Ingrese su nombre',
                      ),
                      const SizedBox(height: 10),
                      FormLogin(
                        formController: surnameController,
                        labelText: 'Apellido(s)',
                        icon: Icons.person_outline,
                        messageError: 'Ingrese su apellido',
                      ),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
                      DropdownButton<String>(
                        value: selectedRole,
                        hint: Text("Seleccione un rol"),
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 16,
                        style: TextStyle(color: AppColor.primary),
                        underline: Container(
                          height: 2,
                          color: AppColor.primary,
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
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColor.green,
                        ),
                        child: const Text('Registrar')
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': nameController.text,
        'surname': surnameController.text,
        'role': selectedRole,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario registrado con éxito'))
      );

      if (selectedRole == 'Cliente') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()), 
        );
      } else if (selectedRole == 'Ofertante') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeBidderPage()), 
        );
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar usuario: $e'))
      );
    }
  }
}
