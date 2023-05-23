import 'package:flutter/material.dart';
import 'package:zenith/widgets/menu.dart';
import 'package:zenith/widgets/scheduler.dart';
import 'package:zenith/widgets/statistics.dart';
import 'package:zenith/widgets/home.dart';
import 'package:zenith/widgets/home_page.dart';
import 'package:zenith/widgets/action_pannel.dart';

class MainToolBar extends StatefulWidget {
  const MainToolBar({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainToolBar();
  }
}

class _MainToolBar extends State<MainToolBar> {
  
  void toHome() {
    setState(() {
      //problem is here
      activeScreen = 'home';
      screenWidget = const Home();
    });
  }

  void toMenu() {
    setState(() {
      activeScreen = 'menu';
      screenWidget = const Menu();
    });
  }

  void toStatistics() {
    setState(() {
      activeScreen = 'statistics';
      screenWidget = const Statistics();
    });
  }

  void toScheduler() {
    setState(() {
      activeScreen = 'scheduler';
      screenWidget = const Scheduler();
    });
  }

  @override
  Widget build(context) {
    if (activeScreen == 'home') {
      screenWidget = const Home();

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

      ;
      currentTab = 3;
    }
    if (activePanel == 'main') {
      setState(() {
        panelWidget = const MainToolBar();
      });
    }

    if (activePanel == 'action') {
      setState(() {
        panelWidget = const ActionPanel();
      });
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
            onPressed: toHome,
            icon: currentTab == 0
                ? Image.asset('lib/icons/redhome.png')
                : Image.asset('lib/icons/home.png')),
        IconButton(
            onPressed: toScheduler,
            icon: currentTab == 1
                ? Image.asset('lib/icons/redschedule.png')
                : Image.asset('lib/icons/calendar.png')),
        const SizedBox(
          width: 10,
        ),
        IconButton(
            onPressed: toStatistics,
            icon: currentTab == 2
                ? Image.asset('lib/icons/redstats.png')
                : Image.asset('lib/icons/statistics.png')),
        IconButton(
            onPressed: toMenu,
            icon: currentTab == 3
                ? Image.asset('lib/icons/redmenu.png')
                : Image.asset('lib/icons/menu.png')),
      ],
    );
  }
}
