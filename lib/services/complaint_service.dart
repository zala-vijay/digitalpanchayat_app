import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addComplaint({
    required String title,
    required String description,
  }) async {
    await _firestore.collection('complaints').add({
      'title': title,
      'description': description,
      'status': 'Pending',
      'time': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getComplaints() {
    return _firestore
        .collection('complaints')
        .orderBy('time', descending: true)
        .snapshots();
  }

  Future<void> updateStatus(
    String docId,
    String status,
  ) async {
    await _firestore
        .collection('complaints')
        .doc(docId)
        .update({'status': status});
  }
}