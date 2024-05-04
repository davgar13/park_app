import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park_app/utils/app_color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(-17.7224164393445, -63.175013515343366);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('ParkApp', style: TextStyle(color: AppColor.white)),
          backgroundColor: AppColor.primary,
        ),
      body:Container(
            color: AppColor.primary,
            height: 400,
            width: double.infinity,
            margin: const EdgeInsets.all(10),
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 50.0,
              ),
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

