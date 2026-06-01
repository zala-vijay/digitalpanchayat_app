import 'package:cloud_firestore/cloud_firestore.dart';

class PlanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPlan({
    required String title,
    required String description,
    required String status,
  }) async {
    await _firestore.collection('development_plans').add({
      'title': title,
      'description': description,
      'status': status,
      'time': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getPlans() {
    return _firestore
        .collection('development_plans')
        .orderBy('time', descending: true)
        .snapshots();
  }

  Future<void> updatePlanStatus(
    String docId,
    String status,
  ) async {
    await _firestore
        .collection('development_plans')
        .doc(docId)
        .update({'status': status});
  }
}