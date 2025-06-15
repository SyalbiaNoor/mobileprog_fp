import 'package:cloud_firestore/cloud_firestore.dart';

class Album {
  final String id;
  final String title;
  final String userId;
  final DateTime createdAt;
  final List<Photo> photos;

  Album({
    required this.id,
    required this.title,
    required this.userId,
    required this.createdAt,
    required this.photos,
  });

  // convert firestore document to Album object
  factory Album.fromMap(Map<String, dynamic> data, String docId) {
    return Album(
      id: docId,
      title: data['title'] ?? '',
      userId: data['userId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      photos: (data['photos'] as List<dynamic>?)
              ?.map((photoData) =>
                  Photo.fromMap(photoData as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  // convert Album object to firestore document
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'userId': userId,
      'createdAt': createdAt,
      'photos': photos.map((photo) => photo.toMap()).toList(),
    };
  }
}

class Photo {
  final String id;
  final String url;
  final String caption;

  Photo({
    required this.id,
    required this.url,
    required this.caption,
  });

  // convert firestore document to Photo object
  factory Photo.fromMap(Map<String, dynamic> data) {
    return Photo(
      id: data['id'] ?? '',
      url: data['url'] ?? '',
      caption: data['caption'] ?? '',
    );
  }

  // convert Photo object to firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'caption': caption,
    };
  }
}
