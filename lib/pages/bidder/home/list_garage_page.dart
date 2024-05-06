import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GarageListPage extends StatefulWidget {
  const GarageListPage({Key? key}) : super(key: key);

  @override
  _GarageListPageState createState() => _GarageListPageState();
}

class _GarageListPageState extends State<GarageListPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final Stream<QuerySnapshot> _garageStream;

  @override
  void initState() {
    super.initState();
    final User? user = _auth.currentUser;
    if (user != null) {
      _garageStream = FirebaseFirestore.instance
          .collection('garages')
          .where('ownerId', isEqualTo: user.uid)
          .snapshots();
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

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return _buildGarageItem(context, data);
            },
          );
        },
      ),
    );
  }

  Widget _buildGarageItem(BuildContext context, Map<String, dynamic> data) {
    return ListTile(
      title: Text(data['name_garage'] ?? 'Nombre no disponible'),
      subtitle: Text('Precio: ${data['price_garage'] ?? 'No disponible'}'),
      trailing: Icon(Icons.arrow_forward),
      onTap: () => _showGarageDetails(context, data),
    );
  }

  void _showGarageDetails(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(data['name_garage'] ?? 'Detalle del Garaje'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                data['image_garage'] != null
                  ? Image.network(data['image_garage'], fit: BoxFit.cover)
                  : Text('No hay imagen disponible'),
                Text('Coordenadas: ${data['coordinates_garage'] ?? 'No disponible'}'),
                Text('Número de Autos: ${data['numbers_cars'] ?? 'No disponible'}'),
                Text('Precio: ${data['price_garage'] ?? 'No disponible'}'),
                Text('Estado: ${data['status_garage'] ?? 'No disponible'}'),
                Text('Tipo de Puerta: ${data['type_gate'].join(", ") ?? 'No disponible'}'),
                Text('Altura: ${data['height'] ?? 'No disponible'}'),
                Text('Ancho: ${data['width'] ?? 'No disponible'}'),
                Text('Largo: ${data['length'] ?? 'No disponible'}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GarageListPage(),
  ));
}
