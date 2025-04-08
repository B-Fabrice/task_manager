import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class Task {
  final String id, title, description;
  final TaskPriority priority;
  final DateTime date;
  final TaskStatus status;
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.date,
    required this.status,
  });

  factory Task.fromMap(Map<String, dynamic> data) {
    return Task(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == data['priority'],
        orElse: () => TaskPriority.medium,
      ),
      date: (data['date'] as Timestamp).toDate(),
      status: TaskStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => TaskStatus.pending,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'priority': priority.name,
      'date': date,
      'status': status.name,
    };
  }

  Color get color {
    return switch (priority) {
      TaskPriority.high => Colors.red,
      TaskPriority.medium => Colors.grey,
      TaskPriority.low => Colors.green,
    };
  }
}
