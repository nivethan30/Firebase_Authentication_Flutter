import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_model.dart';
export '../model/user_model.dart';

class DatabaseService {
  static final DatabaseService _databaseService = DatabaseService._internal();

  DatabaseService._internal();

  factory DatabaseService() {
    return _databaseService;
  }

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  /// Fetches the user details from the database using the user's UID.
  ///
  /// If the user is not null, it fetches the user details from the Firestore
  /// database. If the user details are fetched successfully, it returns the
  /// user details in the form of a [UserModel]. If the user details are not
  /// fetched or the user is null, it returns null.
  Future<UserModel?> getCurrentUserDetails(User? user) async {
    if (user != null) {
      final DocumentReference doc = userCollection.doc(user.uid);
      final DocumentSnapshot snapshot = await doc.get();

      if (snapshot.exists) {
        return UserModel.fromDoc(snapshot);
      }
    }
    return null;
  }

  /// Creates a new user in the database with the given user details.
  ///
  /// If a user with the same UID does not exist in the database, it creates a
  /// new document in the 'users' collection with the given user details. If the
  /// user is created successfully, it returns true. If a user with the same UID
  /// already exists, it returns false. If there is an error while creating the
  /// user, it throws an exception.
  Future<bool> createNewUser(UserModel user) async {
    try {
      final doc = userCollection.doc(user.uid);
      final snapshot = await doc.get();
      if (!snapshot.exists) {
        await doc.set(user.toMap());
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Updates the user's profile picture URL in the database.
  ///
  /// If the update is successful, it returns true. If there is an error while
  /// updating the user, it throws an exception. If the user does not exist in
  /// the database, it throws an exception.
  Future<bool> updateProfilePicUrl(String uid, String profileUrl) async {
    try {
      final DocumentReference doc = userCollection.doc(uid);
      await doc.update({'photo_url': profileUrl});
    } catch (e) {
      rethrow;
    }
    return false;
  }
}
