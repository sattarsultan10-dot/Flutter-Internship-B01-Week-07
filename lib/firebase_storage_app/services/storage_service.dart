import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final firestore = FirebaseFirestore.instance;

  Future<void> uploadFile(File file, String userId) async {
    String fileName = file.path.split('/').last;
    final ref = storage.ref("uploads/$userId/$fileName");
    UploadTask task = ref.putFile(file);
    await task;
    String url = await ref.getDownloadURL();
    await firestore.collection("files").add({
      "userId": userId,
      "filename": fileName,
      "url": url,
      "timestamp": Timestamp.now(),
    });
  }

  Future<void> deleteFile(String url) async {
    Reference ref = storage.refFromURL(url);
    await ref.delete();
  }
}
