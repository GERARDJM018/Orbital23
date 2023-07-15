import 'package:firebase_auth/firebase_auth.dart';
import 'package:zenith/auth.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget  {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>  {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
        );
    } on FirebaseAuthException 
    catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
        try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
        );
    } on FirebaseAuthException 
    catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return const Text('Zenith');
  }

  Widget _entryField(String title, TextEditingController controller)  {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _errorMessage()  {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage',
        style: const TextStyle(color: Colors.red),);
  }

  Widget _submitButton()  {
    return ElevatedButton(
      style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
      onPressed:
        isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(
        isLogin ? 'Login' : 'Register',
        style: TextStyle(color: Colors.green[600]),),
      );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(
        isLogin? 'Register instead' : 'Login instead',
        style: TextStyle(color: Colors.black),)
      );
  }

  Widget _logo()  {
    return Image.asset('lib/images/Zenith-logos_white.png',
    scale: 5,);
  }

  Widget _resetPass() {
    return Align(alignment:Alignment.bottomRight , child : TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ResetPage()));
      },
      child: const Text(
        'Reset Password',
        style: TextStyle(color: Colors.black),))
    );
  }

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        color: Colors.green[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _logo(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                ),
              height: 160,
              padding: EdgeInsets.all(10),
              child: Column(children: [
                _entryField('email', _controllerEmail),
                _entryField('password', _controllerPassword),
              ],)
            ),
            _resetPass(),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton(),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

class ResetPage extends StatefulWidget  {
  const ResetPage({Key? key}) : super(key: key);

  @override
  State<ResetPage> createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage>  {
  String? errorMessage = '';

  final TextEditingController _controllerEmail = TextEditingController();

  Future<void> resetPassword() async {
    try {
      await Auth().resetPassword( // change
        email: _controllerEmail.text,
        );
      setState(() {
      errorMessage = 'success';
    });
    } on FirebaseAuthException 
    catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return const Text('Zenith');
  }

  Widget _entryField(String title, TextEditingController controller)  {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _errorMessage()  {
    if (errorMessage == 'success')  {
      String email = _controllerEmail.text;
      return Text(
        'Reset Password Link has been sent to $email',
        style: const TextStyle(color: Colors.black),);
    } else if (errorMessage != '') {
      return Text('Humm ? $errorMessage',
        style: const TextStyle(color: Colors.red),);
    } else{
      return const Text('');
    }
  }

  Widget _submitButton()  {
    return ElevatedButton(
      style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
      onPressed: resetPassword, //change
      child: Text(
        'reset',
        style: TextStyle(color: Colors.green[600]),),
      );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        'Login',
        style: TextStyle(color: Colors.black),)
      );
  }

  Widget _logo()  {
    return Image.asset('lib/images/Zenith-logos_white.png',
    scale: 5,);
  }

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        color: Colors.green[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _logo(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                ),
              height: 80,
              padding: EdgeInsets.fromLTRB(10,5,10,10),
              child: Column(children: [
                _entryField('email', _controllerEmail),
              ],)
            ),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton(),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}