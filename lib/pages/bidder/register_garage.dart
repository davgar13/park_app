import 'package:flutter/material.dart';
import '../../utils/app_color.dart';
import '../../widget/card_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class RegisterGaragePage extends StatefulWidget {
  const RegisterGaragePage({Key? key}) : super(key: key);

  @override
  State<RegisterGaragePage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterGaragePage> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController numbersCarsController = TextEditingController();
  final TextEditingController coordinatesGarageController = TextEditingController();
  List<String> selectedGates = [];
  XFile? image;
  final picker = ImagePicker();
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
              TextField(
                controller: heightController,
                decoration: const InputDecoration(
                  labelText: 'Altura',
                  icon: Icon(Icons.height),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: widthController,
                decoration: const InputDecoration(
                  labelText: 'Ancho',
                  icon: Icon(Icons.square_foot),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: lengthController,
                decoration: const InputDecoration(
                  labelText: 'Largo',
                  icon: Icon(Icons.straighten),
                ),
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: const Text("Puerta Automática"),
                value: selectedGates.contains("automatic"),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      selectedGates.add("automatic");
                    } else {
                      selectedGates.remove("automatic");
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Puerta Manual"),
                value: selectedGates.contains("manual"),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      selectedGates.add("manual");
                    } else {
                      selectedGates.remove("manual");
                    }
                  });
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: numbersCarsController,
                decoration: const InputDecoration(
                  labelText: 'Número de Autos',
                  icon: Icon(Icons.directions_car),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: coordinatesGarageController,
                decoration: const InputDecoration(
                  labelText: 'Coordenadas del Garaje',
                  icon: Icon(Icons.map),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text("Subir Imagen"),
                onPressed: () => pickImage(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerGarage,
                child: const Text('Registrar Garaje'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = pickedFile;
    });
  }

  Future<void> _registerGarage() async {
    String imageUrl = '';
    if (image != null) {
      var data = await image!.readAsBytes();
      final fileName = 'garage_images/${DateTime.now()}.jpg';
      final ref = FirebaseStorage.instance.ref().child(fileName);
      await ref.putData(data);
      imageUrl = await ref.getDownloadURL();
    }

    FirebaseFirestore.instance.collection('garage').add({
      'height': double.parse(heightController.text),
      'width': double.parse(widthController.text),
      'length': double.parse(lengthController.text),
      'type_gate': selectedGates,
      'numbers_cars': int.parse(numbersCarsController.text),
      'status_garage': 'Libre',
      'image_car': imageUrl,
      'coordinates_garage': coordinatesGarageController.text,
    });
  }
}