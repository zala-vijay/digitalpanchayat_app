import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/complaint_screen.dart';
import '../screens/development_plans_screen.dart';
import '../screens/settings_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() =>
      _MainNavigationState();
}

class _MainNavigationState
    extends State<MainNavigation> {

  int currentIndex = 0;

  final List<Widget> screens = [

    const HomeScreen(),

    const ComplaintScreen(),

    const DevelopmentPlansScreen(),

    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),

      bottomNavigationBar:
          BottomNavigationBar(

        currentIndex: currentIndex,

        selectedItemColor:
            Colors.green,

        unselectedItemColor:
            Colors.grey,

        type:
            BottomNavigationBarType
                .fixed,

        onTap: (index) {

          setState(() {
            currentIndex = index;
          });
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: "Complaints",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Plans",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}