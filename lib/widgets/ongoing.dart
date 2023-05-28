import 'package:flutter/material.dart';

class Ongoing extends StatefulWidget {
  final int time;
  const Ongoing(this.time, this.onGoingFunction, this.onGoingAction, {super.key});
  final void Function(String a) onGoingFunction;
  final String onGoingAction;
  
  
  @override
  _Ongoing createState() => _Ongoing(time);
}

class _Ongoing extends State<Ongoing> {
  _Ongoing(this.time);
  int time;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: TextButton.styleFrom(
            shape: ContinuousRectangleBorder(),
            foregroundColor: Colors.black,
            backgroundColor: Colors.grey),
        onPressed: () {},
        child: Row(
          children: [
            Expanded(
              flex: 9,
              child: Container(
                child: Text(widget.onGoingAction),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Text(time.toString()),
              ),
            ),
          ],
        ));
  }
}
