import 'package:flutter/material.dart';

class ActionPanel extends StatefulWidget {
  const ActionPanel(this.chooseAction, this.onGoing, {super.key});

  final void Function(String action) chooseAction;
  final String onGoing;

  @override
  State<ActionPanel> createState() {
    return _ActionPanel(onGoing);
  }
}

class _ActionPanel extends State<ActionPanel> {
  _ActionPanel(this.onGoing);
  String onGoing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
            onPressed: () {
              widget.chooseAction('study');
              onGoing = onGoing == 'study' ? 'nothing' : 'study';
            },
            icon: onGoing == 'study'
                ? Image.asset(
                    'lib/icons/study.png',
                    color: Colors.blue,
                  )
                : Image.asset('lib/icons/study.png')),
        IconButton(
            onPressed: () {
              widget.chooseAction('workout');
              onGoing = onGoing == 'workout' ? 'nothing' : 'workout';
            },
            icon: onGoing == 'workout'
                ? Image.asset('lib/icons/lunges.png', color: Colors.blue)
                : Image.asset('lib/icons/lunges.png')),
        const SizedBox(
          width: 10,
        ),
        IconButton(
            onPressed: () {
              widget.chooseAction('sleep');
              onGoing = onGoing == 'sleep' ? 'nothing' : 'sleep';
            },
            icon: onGoing == 'sleep'
                ? Image.asset(
                    'lib/icons/sleep.png',
                    color: Colors.blue,
                  )
                : Image.asset('lib/icons/sleep.png')),
        IconButton(
            onPressed: () {
              widget.chooseAction('logout');
              onGoing = onGoing == 'logout' ? 'nothing' : 'logout';
            },
            icon: onGoing == 'logout'
                ? Image.asset(
                    'lib/icons/logout.png',
                    color: Colors.blue,
                  )
                : Image.asset('lib/icons/logout.png')),
      ],
    );
  }
}
