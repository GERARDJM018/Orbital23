import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  const Home({super.key});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Home Screen',
        style: TextStyle(fontSize: 40),
      ),
    );
  }
}
