import 'package:flutter/material.dart';
import 'package:zenith/widgets/home_page.dart';

void main() {
  runApp(
    MaterialApp(
        home: const HomePage(),
        theme: ThemeData().copyWith(
            useMaterial3: false,
            appBarTheme: const AppBarTheme().copyWith(
                backgroundColor: Color.fromARGB(145, 255, 255, 255),
                foregroundColor: Colors.black,
                titleSpacing: 0,),
                )),
  );
}
