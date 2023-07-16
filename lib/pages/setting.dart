import 'package:firebase_auth/firebase_auth.dart';
import 'package:zenith/auth.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key});

  Future<void> signOut() async {
    await Auth(FirebaseAuth.instance).signOut();
  }

  @override
  Widget build(BuildContext context) {
    // Get user data (replace this with your own logic to fetch the user data)
    String email = 'ajneanjfn@gmail.com';
    int experience = 1000;
    String roomColor = 'White';
    int numberOfMoodsSaved =
        2; // Replace with the actual number of moods saved for the user

    int numberOfHabitsDone = 0; // Initialize the count to 0

    // Update the count based on the habit completion status from the database
    bool habit1Done =
        false; // Replace with the actual completion status of habit 1
    bool habit2Done =
        false; // Replace with the actual completion status of habit 2

    if (habit1Done) {
      numberOfHabitsDone++;
    }
    if (habit2Done) {
      numberOfHabitsDone++;
    }

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
              primary: Colors.red,
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