import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'database_service.dart';
export 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../widgets/alerts.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth get auth => _auth;

  User? get user => _auth.currentUser;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final DatabaseService _databaseService = DatabaseService();

/// Reloads the current user's data from the server.
///
/// This method triggers a reload of the current user's data
/// from the server.
  Future<void> reload() async {
    _auth.currentUser?.reload();
  }

  /// Signs in the user using Google authentication.
  ///
  /// This method uses Google Sign-In to authenticate the user and then
  /// signs them into Firebase. It retrieves the Google account, obtains
  /// the authentication credentials, and uses these credentials to sign
  /// in with Firebase. If the sign-in is successful, a new user is created
  /// in the database if not already present, and the Firebase [User] object
  /// is returned. In case of failure or exception, it returns null.
  ///
  /// Returns:
  /// - A [User] object if the sign-in is successful and the user is created in the database.
  /// - `null` if the sign-in fails or an exception occurs.
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;
        if (user != null) {
          UserModel newUser = UserModel(
              uid: user.uid,
              email: user.email!,
              name: user.displayName ?? "No name",
              createdAt: Timestamp.fromDate(user.metadata.creationTime!),
              photoUrl: user.photoURL);
          final bool isCreated = await _databaseService.createNewUser(newUser);
          if (isCreated) {
            return user;
          }
          return user;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  /// Creates a new user with the given [userName], [email] and [password].
  ///
  /// It utilizes the `FirebaseAuth` service to create a new user with the given
  /// email and password. If the user is created successfully, it creates a new
  /// user in the database with the given user name and the uid from the
  /// Firebase user object, and returns the Firebase user object.
  ///
  /// If the user creation fails, it catches the exception and shows an alert
  /// dialog with the error message.
  ///
  /// Returns:
  /// - The Firebase [User] object if the user is created successfully.
  /// - `null` if the user creation fails or an exception occurs.
  Future<User?> createUserWithEmailAndPassword(
      String userName, String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        UserModel newUser = UserModel(
            uid: user.uid,
            email: user.email!,
            name: userName,
            createdAt: Timestamp.fromDate(user.metadata.creationTime!));
        _databaseService.createNewUser(newUser);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e, 'Signup Failed');
      return null;
    } catch (e) {
      _handleAuthError(e, 'Signup Failed');
      return null;
    }
  }

  /// Signs in a user with the provided [email] and [password].
  ///
  /// This method attempts to sign in to the application using the given
  /// email and password through the FirebaseAuth service. If the sign-in
  /// is successful, it shows an alert dialog with a success message and
  /// returns the Firebase [User] object.
  ///
  /// If the sign-in fails due to a FirebaseAuthException or any other
  /// exception, it handles the error by showing an alert dialog with an
  /// error message and returns `null`.
  ///
  /// Returns:
  /// - The Firebase [User] object if the sign-in is successful.
  /// - `null` if the sign-in fails or an exception occurs.
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      alertWidget(
          title: 'Login Success', text: 'You Have Logged In Successfully');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e, 'Login Failed');
      return null;
    } catch (e) {
      _handleAuthError(e, 'Login Failed');
      return null;
    }
  }

/// Signs out the current user by performing the following actions:
/// 1. Signs out from Google using Google Sign-In.
/// 2. Signs out from Firebase Authentication.
/// 
/// If any error occurs during the sign-out process, it calls [_handleAuthError] 
/// with the error and the message 'Logout Failed'.
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      _handleAuthError(e, 'Logout Failed');
    }
  }

  /// Sends a verification email to the current user's email address using the
  /// Firebase Authentication service.
  ///
  /// If the user is not null, it sends a verification email to the user's email
  /// address. If the email is sent successfully, the method returns without
  /// any errors. If the email is not sent or an exception occurs during the
  /// process, it calls [_handleAuthError] with the error and the message
  /// 'Verification Failed'.
  Future<void> sendVerificationEmail() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.sendEmailVerification();
      }
    } catch (e) {
      _handleAuthError(e, 'Verification Failed');
    }
  }

  /// Sends a password reset email to the user with the given email address
  /// using the Firebase Authentication service.
  /// 
  /// If the email is sent successfully, the method returns `true`. If the
  /// email is not sent or an exception occurs during the process, it calls
  /// [_handleAuthError] with the error and the message 'Reset Failed' and
  /// returns `false`.
  /// 
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      _handleAuthError(e, 'Reset Failed');
    }
    return false;
  }

  /// Links the current user's account to the given email and password using the
  /// Firebase Authentication service.
  ///
  /// If the user is not null, it creates a credential with the given email and
  /// password using the EmailAuthProvider and links the current user's account
  /// to the credential. If the linking is successful, it returns true. If the
  /// linking fails or an exception occurs during the process, it calls
  /// [_handleAuthError] with the error and the message 'Linking Failed' and
  /// returns false.
  ///
  /// Returns:
  /// - true if the linking is successful.
  /// - false if the linking fails or an exception occurs.
  Future<bool> linkEmailAndPassword(String email, String password) async {
    if (_auth.currentUser != null) {
      final credential =
          EmailAuthProvider.credential(email: email, password: password);
      try {
        await _auth.currentUser?.linkWithCredential(credential);
        return true;
      } catch (e) {
        _handleAuthError(e, 'Linking Failed');
        return false;
      }
    } else {
      return false;
    }
  }

  /// Updates the password of the current user in the Firebase Authentication
  /// service.
  //
  /// If the current user is not null, it updates the password of the current user
  /// using the given password. If the update is successful, it returns true. If
  /// the update fails or an exception occurs during the process, it calls
  /// [_handleAuthError] with the error and the message 'Update Failed' and
  /// returns false.
  //
  /// Returns:
  /// - true if the update is successful.
  /// - false if the update fails or an exception occurs.
  Future<bool> updatePassword(String password) async {
    if (_auth.currentUser != null) {
      try {
        await _auth.currentUser?.updatePassword(password);
        return true;
      } catch (e) {
        _handleAuthError(e, 'Update Failed');
        return false;
      }
    } else {
      return false;
    }
  }

  /// Handles a Firebase Authentication error.
  ///
  /// This function takes a dynamic error and a string title as parameters. It
  /// checks if the error is a FirebaseAuthException and if so, it checks the
  /// error code and sets the errorMessage variable to a user-friendly error
  /// message. Finally, it calls [alertWidget] with the title, errorMessage and
  /// QuickAlertType.error to show an error alert dialog to the user.
  void _handleAuthError(dynamic error, String title) {
    String errorMessage = error.toString();
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'weak-password':
          errorMessage = "The password provided is too weak.";
          break;
        case 'email-already-in-use':
          errorMessage = "The account already exists for that email.";
          break;
        case 'invalid-email':
          errorMessage = "The email address is badly formatted.";
          break;
        case 'wrong-password':
          errorMessage = "The password is invalid. Please try again.";
          break;
        case 'user-not-found':
          errorMessage = "User Not Found. Please Sign Up First.";
          break;
        case 'invalid-credential':
          errorMessage = "Invalid Credential. Please try again.";
          break;
      }
    }
    alertWidget(title: title, text: errorMessage, type: QuickAlertType.error);
  }
}
