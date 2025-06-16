import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/album_model.dart';

class AlbumService {
  final CollectionReference _albumRef =
      FirebaseFirestore.instance.collection('albums');

  // add new album
  Future<void> addAlbum(Album album) async {
    await _albumRef.add(album.toMap());
  }

  // get all albums for a specific user
  Stream<List<Album>> getUserAlbums(String userId) {
    return _albumRef
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                Album.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // delete an album by id
  Future<void> deleteAlbum(String id) async {
    await _albumRef.doc(id).delete();
  }

  // update an album
  Future<void> updateAlbum(String id, Map<String, dynamic> data) async {
    await _albumRef.doc(id).update(data);
  }

  // add photo to album
  Future<void> addPhotoToAlbum(String albumId, Photo photo) async {
    final albumDoc = _albumRef.doc(albumId);
    final snapshot = await albumDoc.get();

    if (snapshot.exists) {
      final albumData = snapshot.data() as Map<String, dynamic>;
      List<dynamic> photos = albumData['photos'] ?? [];
      photos.add(photo.toMap());

      await albumDoc.update({'photos': photos});
    }
  }

  // get photos from a specific album
  Stream<List<Photo>> getPhotos(String albumId) {
    return _albumRef.doc(albumId).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return [];
      }
      final data = snapshot.data() as Map<String, dynamic>;
      List<dynamic> photos = data['photos'] ?? [];
      return photos
          .map((photoData) => Photo.fromMap(photoData as Map<String, dynamic>))
          .toList();
    });
  }

  // delete photo from album
  Future<void> deletePhoto(String albumId, String photoId) async {
    final albumDoc = _albumRef.doc(albumId);
    final snapshot = await albumDoc.get();

    if (snapshot.exists) {
      final albumData = snapshot.data() as Map<String, dynamic>;
      List<dynamic> photos = albumData['photos'] ?? [];
      photos.removeWhere((photoData) => photoData['id'] == photoId);

      await albumDoc.update({'photos': photos});
    }
  }
}
