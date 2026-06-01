import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPlanScreen extends StatefulWidget {
  const AddPlanScreen({super.key});

  @override
  State<AddPlanScreen> createState() => _AddPlanScreenState();
}

class _AddPlanScreenState extends State<AddPlanScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  String status = "Ongoing";

  Future<void> addPlan() async {
    await FirebaseFirestore.instance.collection('development_plans').add({
      'title': titleController.text.trim(),
      'description': descController.text.trim(),
      'status': status,
      'time': Timestamp.now(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Plan")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),

            DropdownButton<String>(
              value: status,
              onChanged: (value) {
                setState(() {
                  status = value!;
                });
              },
              items: ["Ongoing", "Completed"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: addPlan,
              child: const Text("Add Plan"),
            ),
          ],
        ),
      ),
    );
  }
}