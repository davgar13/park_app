import 'package:flutter/material.dart';
import 'package:park_app/utils/app_color.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReservationGarage extends StatefulWidget {
  final String name;
  final String price;

  const ReservationGarage({Key? key, required this.name, required this.price})
      : super(key: key);

  @override
  State<ReservationGarage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationGarage> {
  TextEditingController noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? startDate;
  DateTime? endDate;
  final _format = DateFormat("yyyy-MM-dd HH:mm");

  void _saveReservation() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FirebaseFirestore.instance.collection('reservations').add({
        'garageName': widget.name,
        'price': widget.price,
        'startDateTime': startDate,
        'endDateTime': endDate,
        'status_garage': 'Libre',
        'additionalNote': noteController.text,
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
              initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
        onChanged: onChanged,
        validator: (value) {
          if (value == null) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
      ),
    ],
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
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppColor.green,
                    onPrimary: AppColor.white,
                  ),
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
