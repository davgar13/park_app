import 'package:flutter/material.dart';
import 'package:park_app/widget/btn/primary_button.dart';

import '../../utils/app_color.dart';
import '../../widget/card_view.dart';
import 'login_page.dart';
import 'register_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icon/FondLogo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(bottom: 50),
                child: CardView(
                  marginCard: 20,
                  elevtion: 8, 
                  borderRadius: 15, 
                  color: AppColor.primary, 
                  padingContainer: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [ 
                      const Text('Bienvenido', 
                        style: TextStyle(
                          fontSize: 25, 
                          fontWeight: FontWeight.bold,
                          color: AppColor.white,
                        )
                      ),
                      const SizedBox(height: 20),
                      PrimaryButton(
                        onPressed:() => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          ),
                        backgroundColor: AppColor.secondary, 
                        text: 'Iniciar Sesión', 
                        textColor: AppColor.white, 
                        borderRadius: 10, 
                        width: double.infinity, 
                        fontSize: 20
                      ),
                      const SizedBox(height: 5),
                      Divider(
                        color: Colors.white.withOpacity(0.8),
                        thickness: 1.5,
                      ),
                      const SizedBox(height: 5),
                      PrimaryButton(
                        onPressed:() => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          ),
                        backgroundColor: Colors.transparent, 
                        colorBorder: AppColor.white,
                        text: 'Registrarse', 
                        textColor: AppColor.white, 
                        borderRadius: 10, 
                        width: double.infinity, 
                        fontSize: 20
                      ),
                    ]
                  )
                ),
              )
            ),
          ],
        )
      );
  }
}
