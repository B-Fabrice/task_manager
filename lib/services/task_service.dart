import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/models/task.dart';

class TaskService {
  static final tasks = collections.tasks;
  static final firestore = FirebaseFirestore.instance;
  static final collection = firestore.collection(tasks);

  static Future<void> addTask(Map<String, dynamic> data) async {
    await collection.add(data);
  }

  static Future<void> updateTask(String id, Map<String, dynamic> data) async {
    await collection.doc(id).update(data);
  }

  static Future<void> deleteTask(String id) async {
    await collection.doc(id).delete();
  }

  static final tasksStream = StreamProvider<List<Task>>((ref) {
    final user = FirebaseAuth.instance.currentUser;
    return collection.where('user', isEqualTo: user?.uid).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Task.fromMap(data);
      }).toList();
    });
  });
}
