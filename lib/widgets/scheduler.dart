import 'package:flutter/material.dart';

class Scheduler extends StatefulWidget {
  const Scheduler({super.key});
  @override
  _Scheduler createState() => _Scheduler();
}

class _Scheduler extends State<Scheduler> {

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Scheduler',
        style: TextStyle(fontSize: 40),
      ),
    );
  }
}