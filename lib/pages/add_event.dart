import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zenith/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AddEvent extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? selectedDate;
  const AddEvent(
      {Key? key,
      required this.firstDate,
      required this.lastDate,
      this.selectedDate})
      : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final User? user = Auth().currentUser;
  late DateTime _selectedDate;
  static String _type = 'Class';
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _startHController = TextEditingController();
  final _startMController = TextEditingController();
  final _endHController = TextEditingController();
  final _endMController = TextEditingController();
  List<String> TypeMode = ['Class', 'Test', 'Refreshing', 'Assignment', 'Others']; 
  
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
			appBar: AppBar(title: const Text("Add Event")),
      body: ListView(
				padding: const EdgeInsets.all(16.0),
        children: [
          InputDatePickerFormField(
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            initialDate: _selectedDate,
            onDateSubmitted: (date) {
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
                  hintText: "01",
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
                  hintText: "20",
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
                  hintText: "02",
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
                  hintText: "20",
                  counterText: "",
                ),
                controller: _endMController,
                maxLength: 2,
                keyboardType: TextInputType.number,
              )),
          ]),
          SizedBox(height: 10,),
          DropdownButton(
            value: _type,
            items: TypeMode
              .map((category) => DropdownMenuItem(
                value: category,
                child: Text(
                  category,
              )))
              .toList(),
            onChanged: (value){
              if (value == null) {
                return;
              }
              setState(() {
                _type = value;
              });
            }),
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
		// save event to Firestore
    final title = _titleController.text;
    final description = _descController.text;
    final startH = _startHController.text;
    final startM = _startMController.text;
    final endH = _endHController.text;
    final endM = _endMController.text;
    final type = _type;
    if (title.isEmpty) {
      print('title cannot be empty');
	  	// you can use snackbar to display erro to the user
      return;
    }
    if (startH.isEmpty || startM.isEmpty || endH.isEmpty || endM.isEmpty) {
      print('time cannot be empty');
	  	// you can use snackbar to display erro to the user
      return;
    }
    await FirebaseFirestore.instance.collection('events').add({
      "title": title,
      "description": description,
      "date": Timestamp.fromDate(_newTime(_selectedDate)),
      "startH": int.parse(startH),
      "startM": int.parse(startM),
      "endH": int.parse(endH),
      "endM": int.parse(endM),
      "type": type,
      "email": user?.email ?? 'User email',
    });
    if(mounted) {
		  Navigator.pop<bool>(context, true);
   }
  }
}