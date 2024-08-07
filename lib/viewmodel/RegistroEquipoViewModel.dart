import 'package:flutter/material.dart';

import '../models/equipo.dart';
import '../services/EquipoService.dart';


class RegistroEquipoViewModel extends ChangeNotifier {
  final EquipoService _equipoService = EquipoService();

  Future<void> registrarEquipo(Equipo equipo) async {
    await _equipoService.agregarEquipo(equipo);
    notifyListeners();
  }
}
