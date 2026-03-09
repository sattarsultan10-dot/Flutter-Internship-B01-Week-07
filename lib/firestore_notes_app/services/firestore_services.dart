import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/notes_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CREATE Function
  Future<void> addNote(NotesModel note) async {
    await _firestore.collection("notes").add(note.toMap());
  }

  // READ
  Stream<List<NotesModel>> notesStream(String userId) {
    return _firestore.collection("notes").snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => NotesModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // UPDATE Function
  Future<void> updateNote(NotesModel note) async {
    await _firestore.collection("notes").doc(note.id).update(note.toMap());
  }

  // DELETE Function
  Future<void> deleteNote(String id) async {
    await _firestore.collection("notes").doc(id).delete();
  }
}
