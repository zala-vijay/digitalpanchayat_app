import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsDashboardScreen extends StatelessWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics Dashboard"),
        centerTitle: true,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('complaints')
            .snapshots(),

        builder: (context, complaintSnapshot) {

          if (!complaintSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          int totalComplaints =
              complaintSnapshot.data!.docs.length;

          int solved = 0;
          int pending = 0;

          for (var doc
              in complaintSnapshot.data!.docs) {

            var data =
                doc.data() as Map<String, dynamic>;

            String status =
                data['status'] ?? 'Pending';

            if (status == "Solved") {
              solved++;
            } else {
              pending++;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [

                // 📊 CARDS
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),

                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,

                  children: [

                    _buildCard(
                      "Total Complaints",
                      totalComplaints.toString(),
                      Colors.blue,
                    ),

                    _buildCard(
                      "Solved",
                      solved.toString(),
                      Colors.green,
                    ),

                    _buildCard(
                      "Pending",
                      pending.toString(),
                      Colors.orange,
                    ),

                    _buildCard(
                      "Success Rate",
                      totalComplaints == 0
                          ? "0%"
                          : "${((solved / totalComplaints) * 100).toStringAsFixed(1)}%",
                      Colors.purple,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // 📈 PIE CHART
                const Text(
                  "Complaint Analytics",

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  height: 250,

                  child: PieChart(
                    PieChartData(
                      sections: [

                        PieChartSectionData(
                          value: solved.toDouble(),
                          title: "Solved",
                          color: Colors.green,
                          radius: 70,
                          titleStyle:
                              const TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        PieChartSectionData(
                          value: pending.toDouble(),
                          title: "Pending",
                          color: Colors.orange,
                          radius: 70,
                          titleStyle:
                              const TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 📦 CARD
  Widget _buildCard(
    String title,
    String value,
    Color color,
  ) {
    return Card(
      elevation: 5,

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(15),
      ),

      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(15),

          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.7),
              color,
            ],
          ),
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Text(
              value,

              style: const TextStyle(
                fontSize: 28,
                fontWeight:
                    FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              title,

              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}