import 'package:flutter/material.dart';


class Menu extends StatefulWidget {
  const Menu({super.key});
  @override
  _Menu createState() => _Menu();
}

class _Menu extends State<Menu> {

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Menu',
        style: TextStyle(fontSize: 40),
      ),
    );
  }
}