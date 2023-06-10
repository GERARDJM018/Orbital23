import 'package:flutter/material.dart';

class MainToolBar extends StatefulWidget {
  const MainToolBar(this.switchScreen, {super.key});
  final void Function(int i) switchScreen;

  @override
  State<StatefulWidget> createState() {
    return _MainToolBar();
  }
}

class _MainToolBar extends State<MainToolBar> {
  int index = 0;
  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.black),
      child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
            onPressed: () {
              widget.switchScreen(0);
              index = 0;
            },
            icon: index == 0
                ? Image.asset('lib/icons/redhome.png')
                : Image.asset('lib/icons/home.png')),
        IconButton(
            onPressed: () {
              widget.switchScreen(1);
              index = 1;
            },
            icon: index == 1
                ? Image.asset('lib/icons/redschedule.png')
                : Image.asset('lib/icons/calendar.png')),
        const SizedBox(
          width: 10,
        ),
        IconButton(
            onPressed: () {
              widget.switchScreen(2);
              index = 2;
            },
            icon: index == 2
                ? Image.asset('lib/icons/redstats.png')
                : Image.asset('lib/icons/statistics.png')),
        IconButton(
            onPressed: () {
              widget.switchScreen(3);
              index = 3;
            },
            icon: index == 3
                ? Image.asset('lib/icons/redmenu.png')
                : Image.asset('lib/icons/menu.png')),
      ],
    ));
  }
}

