import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/videostory_model.dart';

class VideoStoryService {
  final CollectionReference _videoRef =
      FirebaseFirestore.instance.collection('video_stories');

  Future<void> addVideoStory(VideoStory story) async {
    await _videoRef.add(story.toMap());
  }

  Stream<List<VideoStory>> getAllVideoStories() {
    return _videoRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => VideoStory.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> deleteVideoStory(String id) async {
    await _videoRef.doc(id).delete();
  }

  Future<void> updateVideoStory(String id, Map<String, dynamic> data) async {
    await _videoRef.doc(id).update(data);
  }
}