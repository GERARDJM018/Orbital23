import 'package:flutter/material.dart';
import 'package:zenith/widgets/ongoing.dart';

class Menu extends StatefulWidget {
  const Menu(this.onGoingAction, {super.key});
  final String onGoingAction;
  
  @override
  _Menu createState() => _Menu(onGoingAction);
  
}

class _Menu extends State<Menu> {
  final String onGoingAction;
  _Menu(this.onGoingAction);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 1, child: Ongoing(onGoingAction)),
        Expanded(
          flex: 8,
          child: Center(
            child: Text(
              'Menu',
              style: TextStyle(fontSize: 40),
            ),
          ),
        ),
        Expanded(
          child: Row(),
        )
      ],
    );
  }
}