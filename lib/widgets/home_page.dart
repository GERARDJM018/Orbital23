import 'package:flutter/material.dart';
import 'package:zenith/widgets/action_pannel.dart';
import 'package:zenith/widgets/main_toolbar.dart';
import 'package:zenith/widgets/menu.dart';
import 'package:zenith/widgets/scheduler.dart';
import 'package:zenith/widgets/statistics.dart';
import 'package:zenith/widgets/home.dart';

int currentTab = 0; // here?
Widget screenWidget = const Home();
Widget panelWidget = const MainToolBar();
var activeScreen = 'statistics';
var activePanel = 'main';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  
  void toAction() {
    setState(() {
      activePanel = 'action';
    });
  }

  Widget whichTitle() {
    if (activeScreen == 'home') { // active screen is not changed
      return const Text('Home');
    }

    if (activeScreen == 'scheduler') {
      return const Text('Scheduler ');
    }

    if (activeScreen == 'menu') {
      return const Text('Menu');
    }
    if (activeScreen == 'statistics') {
      return const Text('Statistics');
    }
    return const Text('Home');
  }

  @override
  Widget build(BuildContext context) {
    if (activeScreen == 'home') {
      screenWidget = const Home();
      currentTab = 0;
    }
    if (activeScreen == 'scheduler') {
      screenWidget = const Scheduler();
      currentTab = 1;
    }
    if (activeScreen == 'statistics') {
      screenWidget = const Statistics();
      currentTab = 2;
    }
    if (activeScreen == 'menu') {
      screenWidget = const Menu();
      currentTab = 3;
    }
    if (activePanel == 'main') {
      panelWidget = const MainToolBar();
    }
    if (activePanel == 'action') {
      panelWidget = const ActionPanel();
    }

    return Scaffold(
      appBar: AppBar(
        title: whichTitle(),
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
/* bottomNavigationBar: BottomNavigationBar(
          
          iconSize: 20,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Scheduler',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                  height: 20,
                  width: 20,
                  child: Image.asset('lib/icons/happy.png')),
              label: 'Mood',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                  height: 20,
                  width: 20,
                  child: Image.asset('lib/icons/menu.png')),
              label: 'Menu',
            ),
          ],
          currentIndex: _selectedIndex, //New
          onTap: _onItemTapped,
        )*/
