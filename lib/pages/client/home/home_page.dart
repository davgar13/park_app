import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:park_app/utils/app_color.dart';
import 'package:park_app/pages/reservations/reservation_garage_page.dart';
import 'package:park_app/pages/client/home/car_list_page.dart';
import 'package:park_app/pages/client/home/profile_page.dart';
import 'package:park_app/pages/client/home/register_car_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadGarages();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => CarListPage()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
        break;
    }
  }

  void _loadGarages() {
    FirebaseFirestore.instance.collection('garages').snapshots().listen(
      (snapshot) {
        print("Loaded ${snapshot.docs.length} garages");
        setState(() {
          _markers.clear();
          for (var document in snapshot.docs) {
            Map<String, dynamic> garage = document.data() as Map<String, dynamic>;
            print("Garage data: $garage");
            if (garage['coordinates_garage'] != null) {
              String coordsString = garage['coordinates_garage'];
              RegExp regex = RegExp(r'LatLng\(([^,]+),\s*([^)]+)\)');
              Iterable<Match> matches = regex.allMatches(coordsString);
              if (matches.isNotEmpty) {
                Match match = matches.first;
                double lat = double.parse(match.group(1)!);
                double lng = double.parse(match.group(2)!);
                LatLng position = LatLng(lat, lng);
                _markers.add(Marker(
                  markerId: MarkerId(document.id),
                  position: position,
                  infoWindow: InfoWindow(
                    title: garage['name_garage'] ?? 'Sin nombre',
                    snippet: 'Precio: ${garage['price_garage'] ?? 'N/A'}',
                    onTap: () {
                      _showGarageDetails(garage, document.id);
                    },
                  ),
                ));
              }
            }
          }
        });
      },
    );
  }

  void _showGarageDetails(Map<String, dynamic> garage, String garageId) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), 
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  garage['image_garage'] ?? '',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.error, size: 150, color: AppColor.primary),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColor.primary, // Color de fondo
                    borderRadius: BorderRadius.circular(10), // Borde redondeado
                  ),
                  child: Text(
                    'Nombre: ${garage['name_garage'] ?? 'Sin nombre'}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Texto en color blanco para contrastar
                    ),
                  ),
                ),
              ),

              Row(
                children: [
                  Icon(Icons.location_on, color: AppColor.primary),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text('Coordenadas: ${garage['coordinates_garage'] ?? 'N/A'}',
                        style: TextStyle(color: Colors.grey[600])),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.directions_car, color: AppColor.primary),
                  SizedBox(width: 5),
                  Text('Número de Autos: ${garage['numbers_Cars'] ?? 'N/A'}',
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.attach_money, color: AppColor.green),
                  SizedBox(width: 5),
                  Text('Precio: \Bs ${garage['price_garage'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.green)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.check_circle, color: AppColor.primary),
                  SizedBox(width: 5),
                  Text('Estado: ${garage['status_garage'] ?? 'N/A'}',
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.home, color: AppColor.primary),
                  SizedBox(width: 5),
                  Text('Tipo de Puerta: ${garage['type_gate'] ?? 'N/A'}',
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.square_foot, color: AppColor.primary),
                  SizedBox(width: 5),
                  Text('Altura: ${garage['height'] ?? 'N/A'}m',
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.square_foot, color: AppColor.primary),
                  SizedBox(width: 5),
                  Text('Ancho: ${garage['width'] ?? 'N/A'}m',
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.square_foot, color: AppColor.primary),
                  SizedBox(width: 5),
                  Text('Longitud: ${garage['length'] ?? 'N/A'}m',
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReservationGarage(
                            name: garage['name_garage'] ?? 'Sin nombre',
                            price: garage['price_garage'] ?? 'N/A',
                            garageId: garageId,  
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.green,
                      textStyle: TextStyle(color: Colors.white),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                    ),
                    child: Text('Reservar', style: TextStyle(fontSize: 16)),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColor.primary),
                      textStyle: TextStyle(color: AppColor.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                    ),
                    child: Text('Cerrar', style: TextStyle(fontSize: 16, color: AppColor.primary)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ParkApp', style: TextStyle(color: AppColor.white)),
        backgroundColor: AppColor.primary,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(-17.7224164393445, -63.175013515343366),
          zoom: 14.0,
        ),
        markers: _markers.toSet(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColor.primary,
        selectedItemColor: AppColor.green,
        unselectedItemColor: AppColor.white,
        selectedFontSize: 18,
        unselectedFontSize: 13,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_crash_rounded),
            label: 'Autos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
