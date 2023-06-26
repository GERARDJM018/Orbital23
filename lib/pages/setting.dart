import 'package:firebase_auth/firebase_auth.dart';
import 'package:zenith/auth.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  Future<void> signOut() async{
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Setting'),), body: TextButton(child: Text('Log out'), onPressed: () {signOut();},),);
  }
}