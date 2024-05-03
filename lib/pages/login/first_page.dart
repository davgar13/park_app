import 'package:flutter/material.dart';

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
        body: Center(
          child: CardView(
            marginCard: 20,
            elevtion: 8, 
            borderRadius: 15, 
            color: AppColor.grey, 
            padingContainer: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text('Iniciar Sesión')
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Text('Registro')
                ),
              ]
            )
          )
        ),
      );
  }
}
