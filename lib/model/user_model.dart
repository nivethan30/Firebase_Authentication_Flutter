import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final Timestamp createdAt;
  final String? photoUrl;

  UserModel(
      {required this.uid,
      required this.email,
      required this.name,
      required this.createdAt,
      this.photoUrl});

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    Timestamp? createdAt,
    String? photoUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'name': name,
      'created_at': createdAt,
      'photo_url': photoUrl
    };
  }

  factory UserModel.fromDoc(DocumentSnapshot map) {
    final data = map.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'] as String,
      email: data['email'] as String,
      name: data['name'] as String,
      createdAt: data['created_at'] as Timestamp,
      photoUrl: data['photo_url'],
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, name: $name, createdAt: $createdAt, photoUrl: $photoUrl)';
  }
}
