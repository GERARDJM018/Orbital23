import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zenith/class/event.dart';
import 'package:zenith/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';


class EditEvent extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final Event event;
  const EditEvent(
      {Key? key,
      required this.firstDate,
      required this.lastDate,
      required this.event})
      : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final User? user = Auth().currentUser;
  late DateTime _selectedDate;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _startHController;
  late TextEditingController _startMController;
  late TextEditingController _endHController;
  late TextEditingController _endMController;
  
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.event.date;
    _titleController = TextEditingController(text: widget.event.title);
    _descController = TextEditingController(text: widget.event.description);
    _startHController = TextEditingController(text: widget.event.startH.toString().padLeft(2,'0'));
    _startMController = TextEditingController(text: widget.event.startM.toString().padLeft(2,'0'));
    _endHController = TextEditingController(text: widget.event.endH.toString().padLeft(2,'0'));
    _endMController = TextEditingController(text: widget.event.endM.toString().padLeft(2,'0'));
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Event")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          InputDatePickerFormField(
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            initialDate: _selectedDate,
            onDateSubmitted: (date) {
              print(date);
              setState(() {
                _selectedDate = date;
              });
            },
          ),
          TextField(
            controller: _titleController,
            maxLines: 1,
            decoration: const InputDecoration(labelText: 'title'),
          ),
          Row(
            children: [
            Text('Start: ', textScaleFactor: 1.2,),
            Container(
              color: Colors.white,
              width: 20,
              child: TextField(
                decoration: InputDecoration(
                  counterText: "",
                ),
                controller: _startHController,
                maxLength: 2,
                keyboardType: TextInputType.number,
              )),
            Text(':'),
            SizedBox(
              width: 20,
              child: TextField(
                decoration: InputDecoration(
                  counterText: "",
                ),
                controller: _startMController,
                maxLength: 2,
                keyboardType: TextInputType.number,
              )),
          ]),
                    Row(
            children: [
            Text('End: ', textScaleFactor: 1.2,),
            Container(
              color: Colors.white,
              width: 20,
              child: TextField(
                decoration: InputDecoration(
                  counterText: "",
                ),
                controller: _endHController,
                maxLength: 2,
                keyboardType: TextInputType.number,
              )),
            Text(':'),
            SizedBox(
              width: 20,
              child: TextField(
                decoration: InputDecoration(
                  counterText: "",
                ),
                controller: _endMController,
                maxLength: 2,
                keyboardType: TextInputType.number,
              )),
          ]),
          TextField(
            controller: _descController,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'description'),
          ),
          ElevatedButton(
            onPressed: () {
              _addEvent();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  DateTime _newTime(DateTime dTime) {
    return DateTime(dTime.year, dTime.month, dTime.day, 0,0,0,0,0);
  }

  void _addEvent() async {
    final title = _titleController.text;
    final description = _descController.text;
    final startH = _startHController.text;
    final startM = _startMController.text;
    final endH = _endHController.text;
    final endM = _endMController.text;
    if (title.isEmpty) {
      print('title cannot be empty');
      return;
    }
    if (startH.isEmpty || startM.isEmpty || endH.isEmpty || endM.isEmpty) {
      print('time cannot be empty');
	  	// you can use snackbar to display erro to the user
      return;
    }
    await FirebaseFirestore.instance.collection('events').doc(widget.event.id).update({
      "title": title,
      "description": description,
      "date": Timestamp.fromDate(_newTime(_selectedDate)),
      "startH": int.parse(startH),
      "startM": int.parse(startM),
      "endH": int.parse(endH),
      "endM": int.parse(endM),
      "email": user?.email ?? 'User email',
    });
    if (mounted) {
      Navigator.pop<bool>(context, true);
    }
  }
}