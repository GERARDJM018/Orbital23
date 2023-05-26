import 'package:flutter/material.dart';
import 'package:zenith/widgets/ongoing.dart';

class Home extends StatefulWidget {
  const Home(this.minute, this.onGoingFunction,this.onGoingAction, {super.key});
  final int minute;
  final String onGoingAction;
  final void Function(String a) onGoingFunction;
  @override
  _HomeState createState() => _HomeState(onGoingAction, minute);
}

class _HomeState extends State<Home> {
  final String onGoingAction;
  int minute;
    _HomeState(this.onGoingAction, this.minute);
  final _timeController = TextEditingController();

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 1, child: Ongoing(minute, widget.onGoingFunction, onGoingAction)),
        const Expanded(
          flex: 8,
          child: Center(
            child: Text(
              'Home Screen',
              style: TextStyle(fontSize: 40),
            ),
          ),
        ),
        const Expanded(
          child: Row(),
        )
      ],
    );
  }
}
