import 'package:flutter/material.dart';


class Scheduler extends StatefulWidget {
  const Scheduler(this.onGoingFunction, this.onGoingAction, {super.key});
  final String onGoingAction;
  final void Function(String a) onGoingFunction;

  @override
  _Scheduler createState() => _Scheduler(onGoingAction);
}

class _Scheduler extends State<Scheduler> {
  final String onGoingAction;
  _Scheduler(this.onGoingAction);
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 8,
          child: Center(
            child: Text(
              'Scheduler',
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