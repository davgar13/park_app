import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:park_app/pages/bidder/home/my_reserves_page.dart';

class ReservesPage extends StatefulWidget {
  const ReservesPage({Key? key}) : super(key: key);

  @override
  _ReservesPageState createState() => _ReservesPageState();
}

class _ReservesPageState extends State<ReservesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final Stream<QuerySnapshot> _garageStream;

  @override
  void initState() {
    super.initState();
    User? user = _auth.currentUser;
    if (user != null) {
      _garageStream = FirebaseFirestore.instance
          .collection('garages')
          .where('ownerId', isEqualTo: user.uid)
          .snapshots();
    } else {
      // Asignar un stream vacío si no hay usuario
      _garageStream = Stream<QuerySnapshot>.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Garajes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _garageStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Algo salió mal: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>? ?? {};
              return ListTile(
                title: Text(data['name_garage'] ?? 'Nombre no disponible'),
                subtitle: Text('Precio: ${data['price_garage'] ?? 'No disponible'}'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyReservesPage(garageId: document.id))),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}