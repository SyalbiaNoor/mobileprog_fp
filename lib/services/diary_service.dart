import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/diary_model.dart';

class DiaryService {
  final CollectionReference _diaryRef =
      FirebaseFirestore.instance.collection('diary');

  Future<void> addEntry(DiaryEntry entry) async {
    await _diaryRef.add(entry.toMap());
  }

  Stream<List<DiaryEntry>> getUserEntries(String userId) {
    return _diaryRef
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DiaryEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Stream<List<DiaryEntry>> getAllEntries() {
    return _diaryRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DiaryEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> deleteEntry(String id) async {
    await _diaryRef.doc(id).delete();
  }

  Future<void> updateEntry(String id, Map<String, dynamic> data) async {
    await _diaryRef.doc(id).update(data);
  }
}
