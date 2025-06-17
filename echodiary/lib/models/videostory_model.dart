import 'package:cloud_firestore/cloud_firestore.dart';

class VideoStory {
  final String id;
  final String title;
  final String videoUrl;
  final DateTime createdAt;
  final String userId;

  VideoStory({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.createdAt,
    required this.userId,
  });

  factory VideoStory.fromMap(Map<String, dynamic> data, String docId) {
    return VideoStory(
      id: docId,
      title: data['title'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'videoUrl': videoUrl,
      'createdAt': createdAt,
      'userId': userId,
    };
  }
}