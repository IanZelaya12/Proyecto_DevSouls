import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String? get uid => _auth.currentUser?.uid;

  /// 🔹 Leer datos una sola vez
  Future<Map<String, dynamic>?> getUserData() async {
    if (uid == null) return null;
    var doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  /// 🔹 Escuchar datos en tiempo real
  Stream<Map<String, dynamic>?> streamUserData() {
    if (uid == null) return const Stream.empty();
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.data());
  }

  /// 🔹 Actualizar datos
  Future<void> updateUserData(Map<String, dynamic> data) async {
    if (uid == null) return;
    await _firestore
        .collection('users')
        .doc(uid)
        .set(data, SetOptions(merge: true));
  }

  /// 🔹 Subir foto de perfil
  Future<String?> uploadProfileImage(File file) async {
    if (uid == null) return null;

    final storageRef = _storage.ref().child('profile_pics/$uid.jpg');
    await storageRef.putFile(file);
    return await storageRef.getDownloadURL();
  }

  /// 🔹 Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
