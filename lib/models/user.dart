import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String name;
  final String email;
  final String userImage;
  final createdAt;
  final updatedAt;

  User({
    this.uid,
    this.name,
    this.email,
    this.userImage,
    this.updatedAt,
    this.createdAt,
  });

  User.fromFirebase(DocumentSnapshot document)
      : uid = document.documentID,
        name = document["title"],
        email = document["content"],
        userImage = document["userImage"],
        createdAt = document["createdAt"],
        updatedAt = document["updatedAt"];
}
