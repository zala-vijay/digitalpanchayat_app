import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        centerTitle: true,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('complaints')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var docs = snapshot.data!.docs;

          int total = docs.length;
          int pending = 0;
          int solved = 0;

          for (var doc in docs) {
            var data = doc.data() as Map<String, dynamic>;

            String status =
                data.containsKey('status') ? data['status'] : 'Pending';

            if (status == 'Solved') {
              solved++;
            } else {
              pending++;
            }
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                // TOTAL
                _buildCard("Total Complaints", total, Colors.blue),

                const SizedBox(height: 15),

                // PENDING
                _buildCard("Pending", pending, Colors.orange),

                const SizedBox(height: 15),

                // SOLVED
                _buildCard("Solved", solved, Colors.green),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🔧 Reusable Card Widget
  Widget _buildCard(String title, int value, Color color) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Text(
            value.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}