import 'package:flutter/material.dart';


import '../models/equipo.dart';
import '../services/firebase_service.dart';

class EquipmentViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Equipment> _equipments = [];
  String _categoriaSeleccionada = ''; // Propiedad para almacenar la categoría seleccionada

  List<Equipment> get equipments => _equipments;

  // Constructor
  EquipmentViewModel() {
    fetchEquipments();
  }

  // Método para obtener los equipos desde Firebase
  void fetchEquipments() {
    _firebaseService.getEquipments().listen((equipments) {
      _equipments = equipments;
      notifyListeners();
    });
  }

  // Método para establecer la categoría seleccionada y filtrar los equipos
  void filterByCategoria(String categoria) {
    _categoriaSeleccionada = categoria;
    notifyListeners();
  }

  // Getter para obtener la categoría seleccionada
  String get categoriaSeleccionada => _categoriaSeleccionada;
}