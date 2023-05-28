import 'package:flutter/material.dart';
import 'package:zenith/auth.dart';



class Menu extends StatefulWidget {
  const Menu(this.onGoingFunction, this.onGoingAction, {super.key});
  final void Function(String a) onGoingFunction;
  final String onGoingAction;
    
  Future<void> signOut() async{
    await Auth().signOut();
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out'),
      );
  }

  
  @override
  _Menu createState() => _Menu(onGoingAction);
  
}

class _Menu extends State<Menu> {
  final String onGoingAction;
  _Menu(this.onGoingAction);

  Future<void> signOut() async{
    await Auth().signOut();
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 1, child: _signOutButton()),
         Expanded(
          flex: 8,
          child: Center(
            child: Text(
              'Menu',
              style: TextStyle(fontSize: 40),
            ),
          ),
        ),
        Expanded(
          child: Row(),
        )
      ],
    );
  }
}