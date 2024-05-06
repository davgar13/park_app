import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyReservesPage extends StatefulWidget {
  final String garageId;

  const MyReservesPage({Key? key, required this.garageId}) : super(key: key);

  @override
  _MyReservesPageState createState() => _MyReservesPageState();
}

class _MyReservesPageState extends State<MyReservesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void acceptReservation(String docId) {
    _firestore.collection('reservations').doc(docId).update({'status_garage': 'Reservado'});
  }

  void rejectReservation(String docId) {
    _firestore.collection('reservations').doc(docId).delete();
  }

  void finalizeReservation(String docId) {
    _firestore.collection('reservations').doc(docId).update({'status_garage': 'Libre'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservas del Garaje'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('reservations')
            .where('garageId', isEqualTo: widget.garageId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Algo salió mal: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Text('No hay reservas disponibles.');
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>? ?? {};
              return Card(
                child: ListTile(
                  title: Text(data['carModel'] ?? 'Modelo no disponible'),
                  subtitle: Text('Inicio: ${data['startDateTime']} - Fin: ${data['endDateTime']}'),
                  trailing: Wrap(
                    spacing: 12, 
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () => acceptReservation(document.id),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => rejectReservation(document.id),
                      ),
                      IconButton(
                        icon: Icon(Icons.lock_open, color: Colors.blue),
                        onPressed: () => finalizeReservation(document.id),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}