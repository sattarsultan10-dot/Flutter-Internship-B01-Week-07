import 'package:firebase_integrations/firestore_notes_app/model/notes_model.dart';
import 'package:firebase_integrations/firestore_notes_app/services/firestore_services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class NotesProvider extends ChangeNotifier {
  String _searchText = "";
  String get searchText => _searchText;
  FirestoreService service = FirestoreService();
  void updateNotes(String value) {
    _searchText = value.toLowerCase();
    notifyListeners();
  }

  Future<void> addNotes(NotesModel note) async {
    await service.addNote(note);
  }

  Stream<List<NotesModel>> getNotes(String userId) {
    return service.notesStream(userId);
  }

  Future<void> deleteNotes(String id) async {
    await service.deleteNote(id);
  }

  Future<void> newNote(NotesModel note) async {
    await service.updateNote(note);
  }
}
