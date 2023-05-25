import 'package:flutter/material.dart';

class Ongoing extends StatefulWidget {
  const Ongoing(this.onGoingAction, {super.key});
  final String onGoingAction;
  @override
  _Ongoing createState() => _Ongoing(onGoingAction);
}

class _Ongoing extends State<Ongoing> {
  final String onGoingAction;
  _Ongoing(this.onGoingAction);

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
                child: Text(onGoingAction),
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
