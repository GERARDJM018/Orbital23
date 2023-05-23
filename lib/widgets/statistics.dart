import 'package:flutter/material.dart';


class Statistics extends StatefulWidget {
  const Statistics({super.key});
  @override
  _Statistics createState() => _Statistics();
}

class _Statistics extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Statistics',
        style: TextStyle(fontSize: 40),
      ),
    );
  }
}
