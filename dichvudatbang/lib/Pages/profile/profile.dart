import 'package:dichvudatbang/Login%20and%20register/Subscreen.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder:(context) => Subscreen()));
      }, child: Text("MainScreen")),
    );
  }
}
