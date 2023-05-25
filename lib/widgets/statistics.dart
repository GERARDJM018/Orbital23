import 'package:flutter/material.dart';
import 'package:zenith/widgets/ongoing.dart';

class Statistics extends StatefulWidget {
  const Statistics(this.onGoingAction, {super.key});
  final String onGoingAction;
  
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
        Expanded(flex: 1, child: Ongoing(onGoingAction)),
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
