import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/app_color.dart';
import '../../../widget/card_view.dart';
import '../../../widget/forms/form_login.dart';

class RegisterCarPage extends StatefulWidget {
  const RegisterCarPage({Key? key});

  @override
  State<RegisterCarPage> createState() => _RegisterCarPageState();
}

class _RegisterCarPageState extends State<RegisterCarPage> {
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController licensePlateController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registro de Auto',
          style: TextStyle(color: Colors.white), // Cambiar color del texto a blanco
        ),
        backgroundColor: AppColor.primary,
        iconTheme: IconThemeData(color: Colors.white), // Cambiar color del icono a blanco
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),


      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CardView(
          paddingContainer: 20,
          marginCard: 20,
          padingContainer: 20,
          elevation: 8,
          elevtion: 8,
          borderRadius: 15,
          color: Colors.brown[50]!,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                Text(
                  'Registro de Auto',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColor.primary),
                ),
                SizedBox(height: 20),
                ...buildInputs(),
                SizedBox(height: 20),
                buildImageButton(),
                SizedBox(height: 20),
                buildRegisterButton(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      FormLogin(
        formController: brandController,
        labelText: 'Marca',
        icon: Icons.branding_watermark,
        messageError: 'Ingrese una marca válida',
      ),
      const SizedBox(height: 10),
      FormLogin(
        formController: modelController,
        labelText: 'Modelo',
        icon: Icons.car_rental,
        messageError: 'Ingrese un modelo válido',
      ),
      const SizedBox(height: 10),
      FormLogin(
        formController: licensePlateController,
        labelText: 'Placa',
        icon: Icons.confirmation_num,
        messageError: 'Ingrese una placa válida',
      ),
      const SizedBox(height: 10),
      FormLogin(
        formController: heightController,
        labelText: 'Alto',
        icon: Icons.height,
        messageError: 'Ingrese una altura válida',
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: 10),
      FormLogin(
        formController: widthController,
        labelText: 'Ancho',
        icon: Icons.aspect_ratio,
        messageError: 'Ingrese un ancho válido',
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: 10),
      FormLogin(
        formController: lengthController,
        labelText: 'Largo',
        icon: Icons.straighten,
        messageError: 'Ingrese un largo válido',
        keyboardType: TextInputType.number,
      ),
    ];
  }

  Widget buildImageButton() {
    return ElevatedButton(
      onPressed: pickImage,
      child: Text('Seleccionar Imagen del Auto'),
      style: ElevatedButton.styleFrom(backgroundColor: AppColor.green),
    );
  }

  Widget buildRegisterButton() {
    return ElevatedButton(
      onPressed: _registerCar,
      child: Text('Registrar Auto'),
      style: ElevatedButton.styleFrom(backgroundColor: AppColor.green),
    );
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = pickedFile;
    });
  }

  Future<void> _registerCar() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No hay usuario registrado. Por favor inicie sesión primero.')),
      );
      return;
    }

    String imageUrl = '';
    if (image != null) {
      File file = File(image!.path);
      var data = await file.readAsBytes();
      final fileName = 'car_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance.ref().child(fileName);
      await ref.putData(data);
      imageUrl = await ref.getDownloadURL();
    }

    FirebaseFirestore.instance.collection('user_cars').add({
      'userId': currentUser.uid,
      'brand': brandController.text,
      'model': modelController.text,
      'licensePlate': licensePlateController.text,
      'height': double.parse(heightController.text),
      'width': double.parse(widthController.text),
      'length': double.parse(lengthController.text),
      'image_car': imageUrl,
    }).then((result) {
      brandController.clear();
      modelController.clear();
      licensePlateController.clear();
      heightController.clear();
      widthController.clear();
      lengthController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Auto registrado exitosamente!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar el auto: $error')),
      );
    });
  }
}
