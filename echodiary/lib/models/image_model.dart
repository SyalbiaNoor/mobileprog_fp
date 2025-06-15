import 'package:cloud_firestore/cloud_firestore.dart';

class ImageEntry {
  final String id;
  final String albumId;
  final String imageUrl;
  final DateTime uploadedAt;

  ImageEntry({
    required this.id,
    required this.albumId,
    required this.imageUrl,
    required this.uploadedAt,
  });

  factory ImageEntry.fromMap(Map<String, dynamic> data, String docId) {
    return ImageEntry(
      id: docId,
      albumId: data['albumId'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      uploadedAt: (data['uploadedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'albumId': albumId,
      'imageUrl': imageUrl,
      'uploadedAt': uploadedAt,
    };
  }
}
