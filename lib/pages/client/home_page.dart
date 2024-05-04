import 'package:flutter/material.dart';
import 'package:park_app/pages/client/register_car_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterCarPage()),
                  );
            },
            child: Text('Añadir auto'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}

