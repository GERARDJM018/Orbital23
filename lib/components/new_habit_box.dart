import 'package:flutter/material.dart';

class EnterNewHabitBox extends StatelessWidget {
  const EnterNewHabitBox(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.onSave,
      required this.onCancel});

  final controller; //new habit name controller
  final String hintText;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 205, 180, 180),
      content: TextField(
        controller: controller,
        style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ), //
      ),
      actions: [

        MaterialButton(
          onPressed: onCancel,
          child: Text('Cancel', style: TextStyle(color: Colors.white)),
          color: Colors.black,
        ),  MaterialButton(
          onPressed: onSave,
          child: Text('Save', style: TextStyle(color: Colors.white)),
          color: Colors.black,
        ),
      ],
    );
  }
}