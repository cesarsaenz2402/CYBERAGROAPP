 
import 'usuario.dart';
import 'equipo.dart';

class Reserva {
  String id;
  Usuario usuario;
  Equipo equipo;
  DateTime fechaInicio;
  DateTime fechaFin;

  Reserva({
    required this.id,
    required this.usuario,
    required this.equipo,
    required this.fechaInicio,
    required this.fechaFin,
  });
}

class Usuario {
}
