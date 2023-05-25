import 'package:flutter/material.dart';
import 'package:zenith/widgets/action_panel.dart';
import 'package:zenith/widgets/main_toolbar.dart';
import 'package:zenith/widgets/menu.dart';
import 'package:zenith/widgets/scheduler.dart';
import 'package:zenith/widgets/statistics.dart';
import 'package:zenith/widgets/home.dart';
import 'package:zenith/widgets/home_action.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  String onGoing = 'choose the actions'; // problem is here

  String activeScreen = 'home-default';
  String activePanel = 'action';
  void switchScreen(int i) {
    if (i == 0) {
      setState(() {
        activeScreen = 'home-default';
      });
    }
    if (i == 1) {
      setState(() {
        activeScreen = 'scheduler';
      });
    }
    if (i == 2) {
      setState(() {
        activeScreen = 'statistics';
      });
    }
    if (i == 3) {
      setState(() {
        activeScreen = 'menu';
      });
    }
  }

  void toAction() {
    setState(() {
      activePanel = 'action';
      activeScreen = 'home_action';
    });
  }

  Widget whichTitle() {
    if (activeScreen == 'home-default' || activeScreen == 'home-action') {
      // active screen is not changed
      return const Text(
        'Home',
        style: TextStyle(
          fontSize: 30,
        ),
      );
    }

    if (activeScreen == 'scheduler') {
      return const Text(
        'Scheduler ',
        style: TextStyle(
          fontSize: 30,
        ),
      );
    }

    if (activeScreen == 'menu') {
      return const Text(
        'Menu',
        style: TextStyle(
          fontSize: 30,
        ),
      );
    }
    if (activeScreen == 'statistics') {
      return const Text(
        'Statistics',
        style: TextStyle(
          fontSize: 30,
        ),
      );
    }
    return const Text('Home');
  }

  int currentTab = 0;
  Widget screenWidget = const Home('a');
  Widget panelWidget = MainToolBar((i) {});

  void _chooseAction(String action) {
    setState(() {
      onGoing = action;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (activeScreen == 'home-default') {
      screenWidget = const Home('a');
      currentTab = 0;
    }
    if (activeScreen == 'scheduler') {
      screenWidget = const Scheduler('b');
      currentTab = 1;
    }
    if (activeScreen == 'statistics') {
      screenWidget = const Statistics('c');
      currentTab = 2;
    }
    if (activeScreen == 'menu') {
      screenWidget = const Menu('d');
      currentTab = 3;
    }
    if (activePanel == 'main') {
      panelWidget = MainToolBar(switchScreen);
    }
    if (activePanel == 'action') {
      panelWidget = ActionPanel(_chooseAction);
      screenWidget = HomeAction(onGoing);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: whichTitle(),
        centerTitle: true,
      ), // do this
      body: screenWidget,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 32, 113, 35),
        onPressed: toAction,
        tooltip: 'Increment',
        elevation: 2.0,
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        color: const Color.fromARGB(255, 250, 247, 247),
        child: panelWidget,
      ),
    );
  }
}
