import 'package:flutter/material.dart';
import 'package:park_app/pages/client/register_car_page.dart';

class HomeBidderPage extends StatefulWidget {
  const HomeBidderPage({super.key});

  @override
  State<HomeBidderPage> createState() => _HomeBidderPageState();
}

class _HomeBidderPageState extends State<HomeBidderPage> {
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
            child: Text('Añadir garage'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}

