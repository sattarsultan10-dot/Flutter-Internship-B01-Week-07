import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_integrations/firebase_storage_app/services/storage_service.dart';
import 'package:flutter/material.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final StorageService service = StorageService();
  final String userId = "user123";
  double progress = 0;
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      await service.uploadFile(file, userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("File Uploader")),
      body: Column(
        children: [
          SizedBox(height: 10),
          ElevatedButton(onPressed: pickFile, child: Text("Upload Files")),
          SizedBox(height: 10),
          LinearProgressIndicator(value: progress),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("files")
                  .where("userId", isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var files = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    var file = files[index];
                    return ListTile(
                      title: Text(file["FileName"]),
                      subtitle: Text(file["url"]),
                      trailing: IconButton(
                        onPressed: () {
                          service.deleteFile(file["url"]);
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
