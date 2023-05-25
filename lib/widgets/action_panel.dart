import 'package:flutter/material.dart';

class ActionPanel extends StatefulWidget {
  const ActionPanel(this.onGoing, {super.key});

  final void Function(String action) onGoing;

  @override
  State<ActionPanel> createState() {
    return _ActionPanel(onGoing);
  }
}

class _ActionPanel extends State<ActionPanel> {
  final void Function(String onGoing) onGoing;

  _ActionPanel(this.onGoing);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
            onPressed: () {
              return onGoing('study');
            },
            icon: Image.asset('lib/icons/study.png')),
        IconButton(
            onPressed: () {
              return onGoing('workout');
            },
            icon: Image.asset('lib/icons/lunges.png')),
        const SizedBox(
          width: 10,
        ),
        IconButton(
            onPressed: () {
              return onGoing('sleep');
            },
            icon: Image.asset('lib/icons/sleep.png')),
        IconButton(
            onPressed: () {
              return onGoing('logout');
            },
            icon: Image.asset('lib/icons/logout.png')),
      ],
    );
  }
}
