import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:park_app/pages/login/login_page.dart';
import 'dart:io';

import 'package:park_app/utils/app_color.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut() async {
    await _auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  Future<String> _getImageUrl(String email) async {
    String filePath = 'profile_images/${email}_profile.jpg';
    return await firebase_storage.FirebaseStorage.instance
        .ref(filePath)
        .getDownloadURL();
  }

  Future<void> _updateProfileImage(String imagePath, String email) async {
    String filePath = 'profile_images/${email}_profile.jpg';
    File imageFile = File(imagePath);
    await firebase_storage.FirebaseStorage.instance
        .ref(filePath)
        .putFile(imageFile);
    String imageUrl = await _getImageUrl(email);
    FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).update({'image': imageUrl});
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    if (user == null) {
      return Center(child: Text("No user is logged in"));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.brown[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(30),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(userData['image'] ?? 'default_image.png'),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        await _updateProfileImage(pickedFile.path, user.email!);
                      }
                    },
                    child: Text('Cambiar Imagen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      textStyle: TextStyle(color: const Color.fromARGB(255, 242, 237, 237)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    elevation: 5,
                    shadowColor:Colors.grey[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ProfileField(label: 'Nombre (s):', value: userData['name'] ?? 'Ingresa el Nombre'),
                          ProfileField(label: 'Apellido (s):', value: userData['surname'] ?? 'Ingresa el Apellido'),
                          ProfileField(label: 'Email:', value: user.email ?? 'Ingresa el Email'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


class ProfileField extends StatelessWidget {
  final String label;
  final String value;

  ProfileField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
