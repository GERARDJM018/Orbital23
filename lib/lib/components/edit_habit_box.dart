
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditHabitBox extends StatefulWidget {
  const EditHabitBox({
    Key? key,
    required this.onSave,
    required this.docId,
    required this.controller,
    required this.onCancel,
  }) : super(key: key);

  final VoidCallback onSave;
  final String docId;
  final TextEditingController controller;
  final VoidCallback onCancel;

  @override
  _EditHabitBoxState createState() => _EditHabitBoxState();
}

class _EditHabitBoxState extends State<EditHabitBox> {
  late FirebaseFirestore firestore;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
  }

  Future<DocumentSnapshot<Object?>> getData() async {
    String userId = getUserId();
    DocumentReference userDoc = firestore.collection("users").doc(userId);
    DocumentReference habits = userDoc.collection("habits").doc(widget.docId);
    return habits.get();
  }

  String getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Object?>>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var data = (snapshot.data?.data() ?? {}) as Map<String, dynamic>;
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            content: TextField(
              controller: widget.controller,
              style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
              decoration: InputDecoration(
                hintText: data['habit'][0],
                hintStyle: TextStyle(color: Colors.grey[600]),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: widget.onCancel,
                child: Text('Cancel', style: TextStyle(color: Colors.white)),
                color: Colors.black,
              ),
              MaterialButton(
                onPressed: widget.onSave,
                child: Text('Save', style: TextStyle(color: Colors.white)),
                color: Colors.black,
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
