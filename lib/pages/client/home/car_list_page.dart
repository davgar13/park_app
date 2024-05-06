import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:park_app/pages/client/home/register_car_page.dart';

class CarListPage extends StatefulWidget {
  const CarListPage({Key? key}) : super(key: key);

  @override
  _CarListPageState createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final Stream<QuerySnapshot> _carsStream;

  @override
  void initState() {
    super.initState();
    final User? user = _auth.currentUser;
    if (user != null) {
      _carsStream = FirebaseFirestore.instance
          .collection('user_cars')
          .where('userId', isEqualTo: user.uid)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Autos', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown[400],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _carsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Algo salió mal: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return _buildCarItem(context, data);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterCarPage()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green[400],
      ),
    );
  }

  Widget _buildCarItem(BuildContext context, Map<String, dynamic> data) {
    return Card(
      color: Colors.brown[50],
      child: ListTile(
        title: Text(data['brand'] ?? 'Marca no disponible', style: TextStyle(color: Colors.brown[400])),
        subtitle: Text('Modelo: ${data['model'] ?? 'No disponible'}', style: TextStyle(color: Colors.brown[400])),
        leading: CircleAvatar(
          backgroundColor: Colors.brown[300],
          backgroundImage: data['image'] != null ? NetworkImage(data['image']) : null,
        ),
        onTap: () => _showCarDetails(context, data),
      ),
    );
  }

  void _showCarDetails(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(data['brand'] ?? 'Detalle del Auto', style: TextStyle(color: Colors.brown[400])),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Modelo: ${data['model'] ?? 'No disponible'}', style: TextStyle(color: Colors.brown[400])),
                Text('Placa: ${data['licensePlate'] ?? 'No disponible'}', style: TextStyle(color: Colors.brown[400])),
                Text('Color: ${data['color'] ?? 'No disponible'}', style: TextStyle(color: Colors.brown[400])),
                data['image'] != null
                  ? Image.network(data['image'], fit: BoxFit.cover)
                  : Text('No hay imagen disponible', style: TextStyle(color: Colors.brown[400])),
                Text('Precio: ${data['price'] ?? 'No disponible'}', style: TextStyle(color: Colors.brown[400])),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar', style: TextStyle(color: Colors.brown[400])),
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
