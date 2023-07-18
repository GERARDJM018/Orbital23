import 'package:firebase_auth/firebase_auth.dart';
import 'package:zenith/auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int numberOfMoodsSaved = 0;
  String email = '';

  @override
  void initState() {
    super.initState();
    fetchData();
    calculateEmotions();
  }

  Future<void> fetchData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();

      if (userSnapshot.exists) {
        String userId = currentUser.uid;
        String userEmail = userSnapshot.get('email').toString();

        setState(() {
          email = userEmail;
        });
      } else {
        // User document doesn't exist, handle the error case
        setState(() {
          email = 'User not found';
        });
      }
    }
  }

  Future<void> signOut() async {
    await Auth(FirebaseAuth.instance).signOut();
  }

  void calculateEmotions() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('user_moods').get();

    setState(() {
      numberOfMoodsSaved = snapshot.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    int experience = 1000;
    String roomColor = 'White';
    int numberOfHabitsDone = 0; // Initialize the count to 0

    // Update the count based on the habit completion status from the database

    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'User Information',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.email),
            title: Text('Email'),
            subtitle: Text(email),
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Experience'),
            subtitle: Text('$experience'),
          ),
          ListTile(
            leading: Icon(Icons.room),
            title: Text('Room Color'),
            subtitle: Text(roomColor),
          ),
          ListTile(
            leading: Icon(Icons.mood),
            title: Text('Number of Moods Saved'),
            subtitle: Text('$numberOfMoodsSaved'),
          ),
          ListTile(
            leading: Icon(Icons.check_circle),
            title: Text('Number of Habits Done'),
            subtitle: Text('$numberOfHabitsDone'),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            child: Text('Log out'),
            onPressed: () {
              signOut();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              onPrimary: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
