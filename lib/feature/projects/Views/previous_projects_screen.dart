import 'package:flutter/material.dart';

class PreviousProjectsScreen extends StatelessWidget {
  const PreviousProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Previous Projects Screen',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
