import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/image_model.dart';

class ImageService {
  final CollectionReference _imageRef =
      FirebaseFirestore.instance.collection('images');

  Future<void> addImage(ImageEntry image) async {
    await _imageRef.add(image.toMap());
  }

  Stream<List<ImageEntry>> getImagesByAlbum(String albumId) {
    return _imageRef
        .where('albumId', isEqualTo: albumId)
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                ImageEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> deleteImage(String id) async {
    await _imageRef.doc(id).delete();
  }
}
