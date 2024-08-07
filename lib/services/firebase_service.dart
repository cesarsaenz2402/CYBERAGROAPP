
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../models/equipo.dart';
import '../models/usuario.dart';


class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Equipment>> getEquipments() {
    return _db.collection('equipos').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Equipment.fromMap(doc.data(), doc.id)).toList());
  }

  guardarArrendamiento(String nombreEquipo, DateTime fechaInicio, int duracionDias) {}


}
