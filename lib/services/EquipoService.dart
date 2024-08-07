import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/equipo.dart';

class EquipoService {
  final CollectionReference equipoCollection =
  FirebaseFirestore.instance.collection('equipos');

  Future<void> agregarEquipo(Equipo equipo) async {
    await equipoCollection.add(equipo.toJson());
  }
}


