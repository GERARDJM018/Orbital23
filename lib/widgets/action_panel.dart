import 'package:flutter/material.dart';

class ActionPanel extends StatefulWidget {
  const ActionPanel(this.chooseAction, this.onGoing, this.confirm, this.cancle,
      {super.key});

  final void Function(String action) chooseAction;
  final String onGoing;
  final void Function() confirm;
  final void Function() cancle;
  

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
              if (onGoing == 'study') {
                onGoing = 'nothing';
                widget.cancle();
              } else {
                onGoing = 'study';
                widget.confirm();
              }
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
              if (onGoing == 'workout') {
                onGoing = 'nothing';
                widget.cancle();
              } else {
                onGoing = 'workout';
                widget.confirm();
              }
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
              if (onGoing == 'sleep') {
                onGoing = 'nothing';
                widget.cancle();
              } else {
                onGoing = 'sleep';
                widget.confirm();
              }
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
              if (onGoing == 'logout') {
                onGoing = 'nothing';
                widget.cancle();
              } else {
                onGoing = 'logout';
                widget.confirm();
              }
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
