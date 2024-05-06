import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:park_app/pages/client/home/home_page.dart';
import 'package:park_app/pages/bidder/home/home_bidder_page.dart';
import '../../utils/app_color.dart';
import '../../widget/card_view.dart';
import '../../widget/forms/form_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _formOpacity;
  late Animation<Offset> _formPosition;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2), // Duración para la animación completa
      vsync: this,
    );

    _formOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _formPosition = Tween<Offset>(begin: Offset(0, 0.05), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _iconRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          child: FadeTransition(
            opacity: _formOpacity,
            child: SlideTransition(
              position: _formPosition,
              child: CardView(
                marginCard: 20,
                padingContainer: 20,
                paddingContainer: 20,
                elevtion: 8,
                elevation: 8,
                borderRadius: 15,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RotationTransition(
                        turns: _iconRotation,
                        child: Icon(Icons.person, size: 40, color: AppColor.green),
                      ),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loginUser,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColor.green,
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Iniciar Sesión')
                      ),
                    ]
                  ),
                )
              ),
            ),
          ),
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

      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();
      String role = userDoc.get('role');

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
