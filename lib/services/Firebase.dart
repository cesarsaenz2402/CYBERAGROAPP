import 'package:cloud_firestore/cloud_firestore.dart';

class servicio {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> guardarArrendamiento(String nombreEquipo, DateTime fechaInicio, int duracionDias) async {
    try {
      await _firestore.collection('arrendamientos').add({
        'nombreEquipo': nombreEquipo,
        'fechaInicio': fechaInicio,
        'duracionDias': duracionDias,
      });
      print('Arrendamiento guardado correctamente');
    } catch (e) {
      print('Error al guardar arrendamiento: $e');
    }
  }
}
