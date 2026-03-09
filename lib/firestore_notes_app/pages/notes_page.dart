import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_integrations/firestore_notes_app/model/notes_model.dart';
import 'package:firebase_integrations/firestore_notes_app/services/firestore_services.dart';
import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final FirestoreService service = FirestoreService();
  final String userId = "user123";
  String searchText = "";
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  void openNoteDialog({NotesModel? note}) {
    if (note != null) {
      titleController.text = note.title;
      contentController.text = note.content;
    } else {
      titleController.clear();
      contentController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(note == null ? "Add Note" : "Edit Note"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: "Content"),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (note == null) {
                  await service.addNote(
                    NotesModel(
                      title: titleController.text,
                      content: contentController.text,
                      timestamp: Timestamp.now(),
                      userId: userId,
                    ),
                  );
                } else {
                  await service.updateNote(
                    NotesModel(
                      id: note.id,
                      title: titleController.text,
                      content: contentController.text,
                      timestamp: Timestamp.now(),
                      userId: userId,
                    ),
                  );
                }

                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firestore Notes")),

      body: Column(
        children: [
          //  Search bar
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search notes...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),

          Expanded(
            child: StreamBuilder<List<NotesModel>>(
              stream: service.notesStream(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No notes found"));
                }

                var notes = snapshot.data!;
                // 🔍 Filter notes
                notes = notes.where((note) {
                  return note.title.toLowerCase().contains(searchText) ||
                      note.content.toLowerCase().contains(searchText);
                }).toList();

                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: ListTile(
                        title: Text(
                          note.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(note.content),

                            SizedBox(height: 5),

                            Text(
                              note.timestamp.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //  Edit
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                openNoteDialog(note: note);
                              },
                            ),

                            //  Delete
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                service.deleteNote(note.id!);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      //  Add Note
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openNoteDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
