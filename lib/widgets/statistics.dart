import 'package:flutter/material.dart';
import 'package:zenith/widgets/ongoing.dart';

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
    return Column(
      children: [
        Expanded(flex: 1, child: Ongoing(widget.onGoingFunction, onGoingAction)),
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
