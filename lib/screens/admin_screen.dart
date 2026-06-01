import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_plan_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  // 🔄 Update complaint status
  void updateStatus(String docId, String newStatus) async {
    await FirebaseFirestore.instance
        .collection('complaints')
        .doc(docId)
        .update({'status': newStatus});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get(),

      builder: (context, snapshot) {
        // 🔄 Loading
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>?;

        // 🔐 If no role OR not admin
        if (userData == null || userData['role'] != 'admin') {
          return const Scaffold(
            body: Center(
              child: Text(
                "Access Denied ❌",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

        // ✅ ADMIN UI
        return Scaffold(
          appBar: AppBar(
            title: const Text("Admin Panel"),
            centerTitle: true,
          ),

          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('complaints')
                .orderBy('time', descending: true)
                .snapshots(),

            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              var complaints = snapshot.data!.docs;

              if (complaints.isEmpty) {
                return const Center(child: Text("No complaints"));
              }

              return ListView.builder(
                itemCount: complaints.length,
                itemBuilder: (context, index) {
                  var data = complaints[index];
                  var docId = data.id;

                  var map = data.data() as Map<String, dynamic>;

                  String status =
                      map.containsKey('status') ? map['status'] : 'Pending';

                  return Card(
                    margin: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      title: Text(
                        map['title'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(map['description'] ?? ''),

                        if (map['image'] != null &&
                            map['image'] != "") 

                          Padding(
                          
                            padding:
                                const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),

                            child: ClipRRect(
                            
                              borderRadius:
                                  BorderRadius.circular(12),

                              child: Image.network(
                              
                                map['image'],

                                height: 180,

                                width: double.infinity,

                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // 🔔 STATUS DISPLAY
                          Row(
                            children: [
                              const Text(
                                "Status: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                status,
                                style: TextStyle(
                                  color: status == 'Solved'
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // ⚙️ STATUS CHANGE MENU
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          updateStatus(docId, value);
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: "Pending",
                            child: Text("Mark as Pending"),
                          ),
                          const PopupMenuItem(
                            value: "Solved",
                            child: Text("Mark as Solved"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}