import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/add_plan_screen.dart';

class DevelopmentPlansScreen extends StatefulWidget {
  const DevelopmentPlansScreen({super.key});

  @override
  State<DevelopmentPlansScreen> createState() =>
      _DevelopmentPlansScreenState();
}

class _DevelopmentPlansScreenState
    extends State<DevelopmentPlansScreen> {

  String role = "user";

  @override
  void initState() {
    super.initState();
    getUserRole();
  }

  void getUserRole() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (doc.exists) {
      setState(() {
        role = doc['role'];
      });
    }
  }

  // 🔄 Update plan status
  void updateStatus(String docId, String newStatus) async {
    await FirebaseFirestore.instance
        .collection('development_plans')
        .doc(docId)
        .update({'status': newStatus});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Development Plans"),
        centerTitle: true,
      ),

      // ➕ Add Plan (Admin only)
      floatingActionButton: role == "admin"
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddPlanScreen()),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('development_plans')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var plans = snapshot.data!.docs;

          if (plans.isEmpty) {
            return const Center(child: Text("No plans available"));
          }

          return ListView.builder(
            itemCount: plans.length,
            itemBuilder: (context, index) {
              var doc = plans[index];
              var data = doc.data() as Map<String, dynamic>;

              String status = data['status'] ?? 'Ongoing';

              // 🎨 STATUS COLOR
              Color statusColor =
                  status == "Completed" ? Colors.green : Colors.orange;

              return Card(
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ListTile(
                  title: Text(
                    data['title'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(data['description'] ?? ''),
                      const SizedBox(height: 8),

                      // 🎨 STATUS UI
                      Row(
                        children: [
                          const Text(
                            "Status: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // 🔐 ADMIN STATUS CHANGE
                  trailing: role == "admin"
                      ? PopupMenuButton<String>(
                          onSelected: (value) {
                            updateStatus(doc.id, value);
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: "Ongoing",
                              child: Text("Mark as Ongoing"),
                            ),
                            const PopupMenuItem(
                              value: "Completed",
                              child: Text("Mark as Completed"),
                            ),
                          ],
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}