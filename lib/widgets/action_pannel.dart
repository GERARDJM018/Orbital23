import 'package:flutter/material.dart';


class ActionPanel extends StatefulWidget {
  const ActionPanel({super.key});

  @override
  State<ActionPanel> createState() {
    return _ActionPanel();
  }
}

class _ActionPanel extends State<ActionPanel> {
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(onPressed: () {}, icon: Image.asset('lib/icons/study.png')),
        IconButton(onPressed: () {}, icon: Image.asset('lib/icons/lunges.png')),
        const SizedBox(
          width: 10,
        ),
        IconButton(onPressed: () {}, icon: Image.asset('lib/icons/sleep.png')),
        IconButton(onPressed: () {}, icon: Image.asset('lib/icons/logout.png')),
      ],
    );
  }
}
