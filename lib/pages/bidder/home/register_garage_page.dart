import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park_app/widget/card_view.dart';
import 'package:park_app/utils/app_color.dart';

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
  final TextEditingController priceController = TextEditingController();
  final TextEditingController nameGarageController = TextEditingController();
  List<String> selectedGates = [];
  LatLng? coordinatesGarage;
  Marker? marker;
  XFile? image;
  final picker = ImagePicker();
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: CardView(
            marginCard: 20,
            padingContainer: 20,
            elevtion: 8,
            borderRadius: 15,
            color: AppColor.green,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: buildInputs() + buildButtons(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      TextField(
        controller: nameGarageController,
        decoration: InputDecoration(
          labelText: 'Nombre del Garaje',
          icon: Icon(Icons.drive_eta),
        ),
      ),
      SizedBox(height: 10),
      TextField(
        controller: heightController,
        decoration: InputDecoration(
          labelText: 'Altura',
          icon: Icon(Icons.height),
        ),
      ),
      SizedBox(height: 10),
      TextField(
        controller: widthController,
        decoration: InputDecoration(
          labelText: 'Ancho',
          icon: Icon(Icons.square_foot),
        ),
      ),
      SizedBox(height: 10),
      TextField(
        controller: lengthController,
        decoration: InputDecoration(
          labelText: 'Largo',
          icon: Icon(Icons.straighten),
        ),
      ),
      SizedBox(height: 10),
      TextField(
        controller: TextEditingController(text: coordinatesGarage?.toString()),
        decoration: InputDecoration(
          labelText: 'Coordenadas del Garaje',
          icon: Icon(Icons.map),
        ),
        readOnly: true,
      ),
      SizedBox(height: 10),
      CheckboxListTile(
        title: Text("Puerta Automática"),
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
        title: Text("Puerta Manual"),
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
      SizedBox(height: 10),
      TextField(
        controller: numbersCarsController,
        decoration: InputDecoration(
          labelText: 'Número de Autos',
          icon: Icon(Icons.directions_car),
        ),
      ),
      SizedBox(height: 10),
      TextField(
        controller: priceController,
        decoration: InputDecoration(
          labelText: 'Precio',
          icon: Icon(Icons.money),
        ),
      ),
    ];
  }

  List<Widget> buildButtons() {
    return [
      ElevatedButton(
        onPressed: () => _selectCoordinates(context),
        child: Text('Seleccionar Coordenadas'),
      ),
      SizedBox(height: 10),
      ElevatedButton(
        child: Text("Subir Imagen"),
        onPressed: () => pickImage(),
      ),
      SizedBox(height: 20),
      ElevatedButton(
        onPressed: _registerGarage,
        child: Text('Registrar Garaje'),
      ),
    ];
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = pickedFile;
    });
  }

  Future<void> _selectCoordinates(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: 400,
            width: 300,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(-17.7224164393445, -63.175013515343366),
                zoom: 14,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              markers: marker != null ? {marker!} : {},
              onTap: (LatLng location) {
                setState(() {
                  coordinatesGarage = location;
                  marker = Marker(
                    markerId: MarkerId("selected"),
                    position: location,
                  );
                });
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _registerGarage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user logged in')),
      );
      return;
    }

    String imageUrl = '';
    if (image != null) {
      var data = await image!.readAsBytes();
      final fileName = 'garage_images/${DateTime.now()}.jpg';
      final ref = FirebaseStorage.instance.ref().child(fileName);
      await ref.putData(data);
      imageUrl = await ref.getDownloadURL();
    }

    try {
      await FirebaseFirestore.instance.collection('garages').add({
        'ownerId': user.uid,
        'name_garage': nameGarageController.text,
        'height': double.parse(heightController.text),
        'width': double.parse(widthController.text),
        'length': double.parse(lengthController.text),
        'type_gate': selectedGates,
        'numbers_cars': int.parse(numbersCarsController.text),
        'status_garage': 'Libre',
        'image_garage': imageUrl,
        'coordinates_garage': coordinatesGarage?.toString() ?? '',
        'price_garage': priceController.text,
      });

      nameGarageController.clear();
      heightController.clear();
      widthController.clear();
      lengthController.clear();
      numbersCarsController.clear();
      priceController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Garaje registrado exitosamente!')),
      );
    } catch (error) {
      print("Error registrando el garaje: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error registrando el garaje')),
      );
    }
  }
}
