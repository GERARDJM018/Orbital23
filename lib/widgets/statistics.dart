import 'package:flutter/material.dart';


class Statistics extends StatefulWidget {
  const Statistics(this.onGoingFunction, this.onGoingAction, {super.key});
  final String onGoingAction;
  final void Function(String a) onGoingFunction;
  
  @override
  _Statistics createState() => _Statistics(onGoingAction);
}

class _Statistics extends State<Statistics> {
  final String onGoingAction;
  _Statistics(this.onGoingAction);
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 8,
          child: Center(
            child: Text(
              'Statistics',
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
