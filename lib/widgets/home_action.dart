import 'package:flutter/material.dart';
import 'package:authentication/widgets/ongoing.dart';

class HomeAction extends StatefulWidget {
  HomeAction(this.minute, this.onGoingFuntion, this.onGoingAction, {super.key});
  final String onGoingAction;
  final void Function(String a) onGoingFuntion;
  final int minute;
  final _timeController = TextEditingController();
  int timeGetter() {
    return int.parse(_timeController.toString());
  }

  @override
  _HomeActionState createState() => _HomeActionState(onGoingAction, minute);
}

class _HomeActionState extends State<HomeAction> {
  final String onGoingAction;

  _HomeActionState(this.onGoingAction, this.minute);

  int minute;

  @override
  void dispose() {
    widget._timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Ongoing(minute, widget.onGoingFuntion, onGoingAction)),
        const Expanded(
          flex: 8,
          child: Center(
            child: Text(
              'Home Action Screen',
              style: TextStyle(fontSize: 40),
            ),
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  width: 180,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 254, 252, 252),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 20, 5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey),
                          shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: const BorderSide(color: Colors.grey)))),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: TextField(
                          keyboardType: TextInputType.datetime,
                          controller: widget._timeController,
                          maxLength: 3,
                          decoration: const InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 5),
                              prefixText: '',
                              label: Text('minutes: ')),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        )
      ],
    );
  }
}
