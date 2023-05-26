import 'package:flutter/material.dart';

class Ongoing extends StatefulWidget {
  const Ongoing(this.onGoingFunction, this.onGoingAction, {super.key});
  final void Function(String a) onGoingFunction;
  final String onGoingAction;
  @override
  _Ongoing createState() => _Ongoing();
}

class _Ongoing extends State<Ongoing> {
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
                child: Text('Time'),
              ),
            ),
          ],
        ));
  }
}
