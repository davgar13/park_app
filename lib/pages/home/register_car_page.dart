import 'package:flutter/material.dart';
import 'package:park_app/pages/home/home_page.dart';

import '../../utils/app_color.dart';
import '../../widget/card_view.dart';
import '../../widget/forms/form_login.dart';

class RegisterCarPage extends StatefulWidget {
  const RegisterCarPage({super.key});

  @override
  State<RegisterCarPage> createState() => _RegisterCarPageState();
}

class _RegisterCarPageState extends State<RegisterCarPage> {
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController licensePlateController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController lenghtController = TextEditingController();

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
                  formController: brandController, 
                  labelText: 'Marca', 
                  icon: Icons.branding_watermark, 
                  messageError: 'Ingrese un correo electrónico válido',
                ),
                const SizedBox(height: 10,),
                FormLogin(
                  formController: modelController, 
                  labelText: 'Modelo', 
                  icon: Icons.lock_rounded, 
                  messageError: 'Ingrese una contraseña válida',
                  keyboardType: TextInputType.visiblePassword,
                ),
                FormLogin(
                  formController: licensePlateController, 
                  labelText: 'Placa', 
                  icon: Icons.email_rounded, 
                  messageError: 'Ingrese un correo electrónico válido',
                ),
                const SizedBox(height: 10,),
                FormLogin(
                  formController: heightController, 
                  labelText: 'Alto', 
                  icon: Icons.lock_rounded, 
                  messageError: 'Ingrese una contraseña válida',
                  keyboardType: TextInputType.visiblePassword,
                ),
                FormLogin(
                  formController: widthController, 
                  labelText: 'Ancho', 
                  icon: Icons.email_rounded, 
                  messageError: 'Ingrese un correo electrónico válido',
                ),
                const SizedBox(height: 10,),
                FormLogin(
                  formController: lenghtController, 
                  labelText: 'Largo', 
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