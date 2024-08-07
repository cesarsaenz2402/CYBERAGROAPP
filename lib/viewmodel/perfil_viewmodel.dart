
// viewmodels/user_viewmodel.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';

class PerfilViewModel extends ChangeNotifier {
  String? _name;
  String? _email;
  String? _phone;
  String? _role;
  String? _profilePicturePath;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  void setRole(String role) {
    _role = role;
    notifyListeners();
  }

  void setProfilePicture(String path) {
    _profilePicturePath = path;
    notifyListeners();
  }

  Future<void> saveUser() async {
    if (_name != null && _email != null && _phone != null && _role != null && _profilePicturePath != null) {
      final profilePictureUrl = await _uploadProfilePicture(_profilePicturePath!);
      final user = UserModel(
        name: _name!,
        email: _email!,
        phone: _phone!,
        role: _role!,
        profilePictureUrl: profilePictureUrl,
      );
      await _saveUserToFirestore(user);
    }
  }

  Future<String> _uploadProfilePicture(String path) async {
    final ref = FirebaseStorage.instance.ref().child('profile_pictures').child(DateTime.now().toString());
    await ref.putFile(File(path));
    return await ref.getDownloadURL();
  }

  Future<void> _saveUserToFirestore(UserModel user) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc();
    await docRef.set(user.toMap());
  }
}
