import 'package:flutter/material.dart';
import 'package:park_app/utils/app_color.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ReservationGarage extends StatefulWidget {
  final String name;
  final String price;
  final String garageId;

  const ReservationGarage({
    Key? key,
    required this.name,
    required this.price,
    required this.garageId,
  }) : super(key: key);

  @override
  State<ReservationGarage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationGarage> {
  final TextEditingController noteController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DateFormat _format = DateFormat("yyyy-MM-dd HH:mm");
  DateTime? startDate;
  DateTime? endDate;
  String? userName;
  Map<String, double>? garageDimensions;
  List<Map<String, dynamic>> compatibleCars = [];
  Map<String, dynamic>? selectedCar;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadGarageDimensions(widget.garageId);
  }

  void _loadUserName() {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then((document) {
        if (document.exists) {
          setState(() {
            userName = document.data()?['name'] as String?;
          });
        }
      });
    }
  }

  void _loadGarageDimensions(String garageId) {
    FirebaseFirestore.instance
        .collection('garages')
        .doc(garageId)
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          garageDimensions = {
            'width': doc.data()?['width'] as double,
            'length': doc.data()?['length'] as double,
            'height': doc.data()?['height'] as double,
          };
        });

        String ownerId = doc.data()?['ownerId'] as String;

        _findCompatibleCars(ownerId);
      }
    });
  }

  void _findCompatibleCars(String ownerId) {
    FirebaseFirestore.instance
        .collection('user_cars')
        .where('width', isLessThanOrEqualTo: garageDimensions?['width'])
        .get()
        .then((querySnapshot) {
      List<Map<String, dynamic>> tempList = [];
      for (var doc in querySnapshot.docs) {
        double docLength = doc.data()['length'] as double? ?? 0.0;
        double docHeight = doc.data()['height'] as double? ?? 0.0;
        if ((docLength <= (garageDimensions?['length'] ?? 0.0)) &&
            (docHeight <= (garageDimensions?['height'] ?? 0.0))) {
          tempList.add({
            'brand': doc.data()['brand'],
            'model': doc.data()['model'],
            'width': doc.data()['width'],
            'length': doc.data()['length'],
            'height': doc.data()['height'],
          });
        }
      }
      setState(() {
        compatibleCars = tempList;
      });
    });
  }

  void _saveReservation() {
    if (_formKey.currentState!.validate()) {
      if (selectedCar == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Por favor, seleccione un auto para la reserva.'),
          backgroundColor: Colors.red,
        ));
        return;
      }
      _formKey.currentState!.save();
      FirebaseFirestore.instance.collection('reservations').add({
        'garageId': widget.garageId,
        'garageName': widget.name,
        'price': widget.price,
        'startDateTime': startDate,
        'endDateTime': endDate,
        'status_garage': 'Libre',
        'additionalNote': noteController.text,
        'userName': userName,
        'carModel': selectedCar!['model']
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Reserva guardada con éxito.'),
          backgroundColor: Colors.green,
        ));
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al guardar la reserva: $error'),
          backgroundColor: Colors.red,
        ));
      });
    }
  }

  Widget _buildDateTimePicker(
      String label, DateTime? value, ValueChanged<DateTime?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        DateTimeField(
          format: _format,
          initialValue: value,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(),
          ),
          onShowPicker: (context, currentValue) async {
            final date = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              );
              return DateTimeField.combine(date, time);
            } else {
              return currentValue;
            }
          },
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget buildCompatibleCarsDropdown() {
    return DropdownButton<Map<String, dynamic>>(
      value: selectedCar,
      hint: Text("Seleccione un auto"),
      onChanged: (newValue) {
        setState(() {
          selectedCar = newValue;
        });
      },
      items: compatibleCars.map((car) {
        return DropdownMenuItem<Map<String, dynamic>>(
          value: car,
          child: Text(
              '${car['brand']} ${car['model']} - ${car['width']}x${car['length']}x${car['height']}'),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Reserva'),
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Nombre del Cliente:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary)),
              SizedBox(height: 8),
              Text(userName ?? 'Cargando...',
                  style: TextStyle(fontSize: 16, color: Colors.black)),
              SizedBox(height: 20),
              Text('Nombre del Garaje:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary)),
              SizedBox(height: 8),
              Text(widget.name,
                  style: TextStyle(fontSize: 16, color: Colors.black)),
              SizedBox(height: 20),
              Text('Precio:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary)),
              SizedBox(height: 8),
              Text(widget.price,
                  style: TextStyle(fontSize: 16, color: Colors.black)),
              SizedBox(height: 20),
              TextField(
                controller: noteController,
                decoration: InputDecoration(
                  labelText: 'Nota adicional',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              _buildDateTimePicker('Fecha y hora de inicio:', startDate,
                  (date) => setState(() => startDate = date)),
              SizedBox(height: 20),
              _buildDateTimePicker('Fecha y hora de finalización:', endDate,
                  (date) => setState(() => endDate = date)),
              SizedBox(height: 20),
              Text('Seleccione su auto para la reserva:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary)),
              buildCompatibleCarsDropdown(),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: AppColor.green, onPrimary: AppColor.white),
                  onPressed: _saveReservation,
                  child: const Text('Confirmar Reserva'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
