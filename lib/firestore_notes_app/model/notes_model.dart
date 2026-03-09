import 'package:cloud_firestore/cloud_firestore.dart';

class NotesModel {
  String? id;
  String title;
  String content;
  String userId;
  Timestamp timestamp;

  NotesModel({
    this.id,
    required this.title,
    required this.content,
    required this.userId,
    required this.timestamp,
  });

  // Convert object → Map (send to Firestore)
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "content": content,
      "userId": userId,
      "timestamp": timestamp,
    };
  }

  // Convert Map → Object (receive from Firestore)
  factory NotesModel.fromMap(Map<String, dynamic> map, String docId) {
    return NotesModel(
      id: docId,
      title: map["title"] ?? "",
      content: map["content"] ?? "",
      userId: map["userId"] ?? "",
      timestamp: map["timestamp"],
    );
  }
}
