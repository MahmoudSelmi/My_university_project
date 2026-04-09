import 'package:flutter/material.dart';

class DoctorHome extends StatelessWidget {
  const DoctorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Doctor Home')),
      body: Center(child: Text('Welcome to the Doctor Home screen!')),
    );
  }
}
