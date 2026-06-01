import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'complaint_screen.dart';
import 'admin_screen.dart';
import 'settings_screen.dart';
import 'admin_dashboard_screen.dart';
import 'development_plans_screen.dart';
import 'notices_screen.dart';
import 'analytics_dashboard_screen.dart';
import 'scheme_assistant_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  String role = "user";

  @override
  void initState() {
    super.initState();
    getUserRole();
  }

  // 🔐 Get User Role
  void getUserRole() async {

    String uid =
        FirebaseAuth.instance
            .currentUser!
            .uid;

    var doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

    if (doc.exists) {
      setState(() {
        role = doc['role'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>>
        features = [

      {
        "title": "Complaints",
        "icon": Icons.report,
      },

      {
        "title": "Development Plans",
        "icon": Icons.map,
      },

      {
        "title": "Notices",
        "icon": Icons.campaign,
      },

      {
        "title": "Scheme Assistant",
        "icon": Icons.account_balance,
      },

      {
        "title": "Settings",
        "icon": Icons.settings,
      },

      // 🔐 Admin Only
      if (role == "admin")
        {
          "title": "Admin",
          "icon":
              Icons.admin_panel_settings,
        },

      if (role == "admin")
        {
          "title": "Dashboard",
          "icon": Icons.dashboard,
        },

      if (role == "admin")
        {
          "title": "Analytics",
          "icon": Icons.analytics,
        },
    ];

    return Scaffold(

      appBar: AppBar(
        title:
            const Text("Smart Village"),
        centerTitle: true,
      ),

      body: GridView.builder(

        padding:
            const EdgeInsets.all(10),

        itemCount: features.length,

        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(

          crossAxisCount: 2,

          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),

        itemBuilder:
            (context, index) {

          return InkWell(

            onTap: () {

              String title =
                  features[index]["title"];

              // 📢 Complaints
              if (title ==
                  "Complaints") {

                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        const ComplaintScreen(),
                  ),
                );
              }

              // 🏗 Plans
              else if (title ==
                  "Development Plans") {

                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        const DevelopmentPlansScreen(),
                  ),
                );
              }

              // 📢 Notices
              else if (title ==
                  "Notices") {

                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        const NoticesScreen(),
                  ),
                );
              }
              // scheme assistant
              else if (title == 
                  "Scheme Assistant") {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        const SchemeAssistantScreen(),
                  ),
                );
              }

              // ⚙ Settings
              else if (title ==
                  "Settings") {

                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        const SettingsScreen(),
                  ),
                );
              }

              // 🔐 Admin
              else if (title ==
                  "Admin") {

                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        const AdminScreen(),
                  ),
                );
              }

              // 📊 Dashboard
              else if (title ==
                  "Dashboard") {

                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        const AdminDashboardScreen(),
                  ),
                );
              }

              // 📈 Analytics
              else if (title ==
                  "Analytics") {

                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        const AnalyticsDashboardScreen(),
                  ),
                );
              }
            },

            child: Card(

              elevation: 5,

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                        15),
              ),

              child: Column(

                mainAxisAlignment:
                    MainAxisAlignment
                        .center,

                children: [

                  Icon(
                    features[index]["icon"],

                    size: 40,

                    color: Colors.green,
                  ),

                  const SizedBox(
                      height: 10),

                  Text(
                    features[index]
                        ["title"],

                    style:
                        const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),

                    textAlign:
                        TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}