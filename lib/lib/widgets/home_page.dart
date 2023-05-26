import 'package:flutter/material.dart';
import 'package:zenith/widgets/action_panel.dart';
import 'package:zenith/widgets/main_toolbar.dart';
import 'package:zenith/widgets/menu.dart';
import 'package:zenith/widgets/scheduler.dart';
import 'package:zenith/widgets/statistics.dart';
import 'package:zenith/widgets/home.dart';
import 'package:zenith/widgets/home_action.dart';
import 'package:zenith/widgets/home_action2.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  
  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  
 
  void passTime(){

  }
 

  String onGoing = 'choose the actions'; // problem is here
  int minute =  0; 
  String cancleConfirm = 'cancle';
  void inputMinute(int i) {
    minute = i;
  }

  String activeScreen = 'home-default';
  String activePanel = 'main';
  
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

  void confirm() {
    setState(() {
      cancleConfirm = 'confirm';
    });
  }

  void cancle() {
    setState(() {
      cancleConfirm = 'cancle';
    });
  }

  void toHome() {
    setState(() {
      activePanel = 'main';
      activeScreen = 'home-default';
    });
  }

  void _chooseAction(String action) {
    setState(() {
      onGoing = action;
      activeScreen =
          activeScreen == 'home_action' ? 'home-action' : 'home_action';
    });
  }

  Widget whichTitle() {
    if (activeScreen == 'home-default' ||
        activeScreen == 'home-action' ||
        activeScreen == 'home_action') {
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
    return const Text('error');
  }

  int currentTab = 0;
  Widget screenWidget = Home(0, (String a) {}, 'a');
  Widget panelWidget = MainToolBar((i) {});

  @override
  Widget build(BuildContext context) {
    if (activeScreen == 'home-default') {
      screenWidget = Home(minute, _chooseAction, 'a');
      currentTab = 0;
    }
    if (activeScreen == 'scheduler') {
      screenWidget = Scheduler(_chooseAction, 'b');
      currentTab = 1;
    }
    if (activeScreen == 'statistics') {
      screenWidget = Statistics(_chooseAction, 'c');
      currentTab = 2;
    }
    if (activeScreen == 'menu') {
      screenWidget = Menu(_chooseAction, 'd');
      currentTab = 3;
    }
    if (activePanel == 'main') {
      panelWidget = MainToolBar(switchScreen);
    }
    if (activePanel == 'action') {
      screenWidget = HomeAction(minute, _chooseAction, onGoing);
    }
    if (activePanel == 'action') {
      panelWidget = ActionPanel(_chooseAction, onGoing, confirm, cancle);
    }
    if (activeScreen == 'home-action') {
      screenWidget = HomeAction(minute, _chooseAction, onGoing);
    }
    if (activeScreen == 'home_action') {
      screenWidget = HomeAction2(minute, _chooseAction, onGoing);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: whichTitle(),
        centerTitle: true,
      ), // do this
      body: screenWidget,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: activeScreen == 'home-default' ||
              activeScreen == 'statistics' ||
              activeScreen == 'scheduler' ||
              activeScreen == 'menu'
          ? FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 32, 113, 35),
              onPressed: activePanel == 'action' ? toHome : toAction,
              tooltip: 'Increment',
              elevation: 2.0,
              child: const Icon(Icons.add),
            )
          : cancleConfirm == "cancle"
              ? FloatingActionButton(
                  backgroundColor: const Color.fromARGB(255, 32, 113, 35),
                  onPressed: activePanel == 'action' ? toHome : toAction,
                  tooltip: 'Increment',
                  elevation: 2.0,
                  child: const Icon(
                    Icons.cancel_outlined,
                    size: 50,
                    color: Colors.black,
                  ),
                )
              : FloatingActionButton(
                  backgroundColor: const Color.fromARGB(255, 32, 113, 35),
                  onPressed: () {},
                  tooltip: 'Increment',
                  elevation: 2.0,
                  child: const Icon(Icons.start),
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
