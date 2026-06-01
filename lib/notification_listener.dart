import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationListenerWidget extends StatefulWidget {
  final Widget child;

  const NotificationListenerWidget({super.key, required this.child});

  @override
  State<NotificationListenerWidget> createState() =>
      _NotificationListenerWidgetState();
}

class _NotificationListenerWidgetState
    extends State<NotificationListenerWidget> {

  bool firstLoad = true; // ✅ skip old data

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('time', descending: true)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isEmpty) return;

      // ✅ SKIP OLD DATA ON FIRST LOAD
      if (firstLoad) {
        firstLoad = false;
        return;
      }

      var data = snapshot.docs.first.data();

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(data['title'] ?? ''),
          content: Text(data['body'] ?? ''),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}