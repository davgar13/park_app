import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:park_app/utils/app_color.dart';
import 'package:park_app/pages/reservations/reservation_garage_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadGarages();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
        return AlertDialog(
          title: Text(garage['name_garage'] ?? 'Sin nombre'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                garage['image_garage'] ?? '',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              Text('Coordinates: ${garage['coordinates_garage'] ?? 'N/A'}'),
              Text('Number of Cars: ${garage['numbers_Cars'] ?? 'N/A'}'),
              Text('Price: ${garage['price_garage'] ?? 'N/A'}'),
              Text('Status: ${garage['status_garage'] ?? 'N/A'}'),
              Text('Type of Gate: ${garage['type_gate'] ?? 'N/A'}'),
              Text('Height: ${garage['height'] ?? 'N/A'}'),
              Text('Width: ${garage['width'] ?? 'N/A'}'),
              Text('Length: ${garage['length'] ?? 'N/A'}'),
            ],
          ),
          actions: [
            TextButton(
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
              child: Text('Reservar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
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
      body: Container(
        color: AppColor.primary,
        height: 400,
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(-17.7224164393445, -63.175013515343366),
            zoom: 14.0,
          ),
          markers: _markers.toSet(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColor.primary,
        selectedItemColor: AppColor.green,
        unselectedItemColor: AppColor.white,
        selectedFontSize: 18,
        unselectedFontSize: 13,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_crash_rounded),
            label: 'Garages',
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
