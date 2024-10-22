import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final StorageService _storageService = StorageService._internal();

  StorageService._internal();

  factory StorageService() {
    return _storageService;
  }

  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a file to Firebase Storage and returns the download URL.
  ///
  /// The file is stored in the 'profile_pics' directory with the user's UID as 
  /// the file name. If the upload is successful, it returns the download URL 
  /// of the uploaded file. If there is an error during the upload process, 
  /// the error is propagated.
  ///
  /// [uid] - The unique identifier for the user, used as the file name.
  /// [filePath] - The local file path of the file to be uploaded.
  Future<String> uploadFile(String uid, String filePath) async {
    File file = File(filePath);
    try {
      final ref = _storage.ref().child('profile_pics/$uid');

      await ref.putFile(file);

      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }
}
