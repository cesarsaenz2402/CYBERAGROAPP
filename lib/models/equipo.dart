// Registrar los equipos
import 'package:flutter/src/widgets/framework.dart';

class Equipo {
  String id;
  String nombre;
  String descripcion;
  List<String> imagen; // Cambiado a lista
  bool disponible;
  double precio;
  String ubicacion;
  String municipio;
  String marca;
  String modelo;
  String capacidad;
  String categoria;
  String uidUsuario;

  Equipo({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    required this.disponible,
    required this.precio,
    required this.ubicacion,
    required this.municipio,
    required this.marca,
    required this.modelo,
    required this.capacidad,
    required this.categoria,
    required this.uidUsuario,
  });

  // Método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'imagen': imagen,
      'disponible': disponible,
      'precio': precio,
      'ubicacion': ubicacion,
      'municipio': municipio,
      'marca': marca,
      'modelo': modelo,
      'capacidad': capacidad,
      'categoria': categoria,
      'uidUsuario': uidUsuario,
    };
  }

  // Constructor para crear desde JSON
  factory Equipo.fromJson(Map<String, dynamic> json) {
    return Equipo(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      imagen: json['imagen'],
      disponible: json['disponible'],
      precio: json['precio'],
      ubicacion: json['ubicacion'],
      municipio: json['municipio'],
      marca: json['marca'],
      modelo: json['modelo'],
      capacidad: json['capacidad'],
      categoria: json['categoria'],
      uidUsuario: json['uidUsuario'],
    );
  }


}


//listar los equpipos
class Equipment {
  final String id;
  final String nombre;
  final String marca;
  final String modelo;
  final String categoria;
  final String descripcion;
  final String imagen;
  final String precio;
  final String ubicacion;
  final String municipio;
  final String capacidad;
  final bool  disponible;

  Equipment({required this.id, required this.nombre,required this.marca, required this.modelo, required this.descripcion,
    required this.imagen, required this.precio, required this.ubicacion, required this.municipio,
    required this.capacidad, required this.disponible, required this.categoria,
  });

  factory Equipment.fromMap(Map<String, dynamic> data, String documentId) {
    return Equipment(
      id: documentId,
      marca: data['marca'] ?? '',
      nombre: data['nombre'] ?? '',
      modelo: data['modelo'] ?? '',
      categoria: data['categoria'] ?? '',
      descripcion: data['descripcion'] ?? '',
        imagen: data['imagen'] ?? '',
      precio: data['precio'].toString(),
        ubicacion: data['ubicacion'] ?? '',
        municipio: data['municipio'] ?? '',
        capacidad: data['capacidad'] ?? '',
        disponible : data['disponible'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'marca': marca,
      'nombre': nombre,
      'modelo': modelo,
      'categoria': categoria,
      'descripcion': descripcion,
      'imagen': imagen,
      'precio': precio,
      'ubicacion': ubicacion,
      'municipio': municipio,
      'capacidad': capacidad,
      'disponible':disponible

    };
  }
}



class Arrendamiento {
  final String id;
  final String equipoId;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String arrendador;
  final String arrendatario;

  Arrendamiento({
    required this.id,
    required this.equipoId,
    required this.fechaInicio,
    required this.fechaFin,
    required this.arrendador,
    required this.arrendatario,
  });
}





class Maquinaria {
  final String id;
  final String nombre;
  final String descripcion;
  final String categoria;
  final List<String> imagenes;
  final bool disponible;
  final double precio;
  final String ubicacion;
  final String municipio;
  final String marca;
  final String modelo;
  final String capacidad;
  final String uidUsuario;

  Maquinaria({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.imagenes,
    required this.disponible,
    required this.precio,
    required this.ubicacion,
    required this.municipio,
    required this.marca,
    required this.modelo,
    required this.capacidad,
    required this.uidUsuario,
  });

  // Convertir un objeto Maquinaria a un mapa de datos de Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria': categoria,
      'imagen': imagenes,
      'disponible': disponible,
      'precio': precio,
      'ubicacion': ubicacion,
      'municipio': municipio,
      'marca': marca,
      'modelo': modelo,
      'capacidad': capacidad,
      'uidUsuario': uidUsuario,
    };
  }

  // Crear un objeto Maquinaria a partir de un mapa de datos de Firestore
  factory Maquinaria.fromMap(Map<String, dynamic> data) {
    return Maquinaria(
      id: data['id'] ?? '',
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      categoria: data['categoria'] ?? '',
      imagenes: List<String>.from(data['imagenes'] ?? []),
      disponible: data['disponible'] ?? false,
      precio: (data['precio'] ?? 0.0).toDouble(),
      ubicacion: data['ubicacion'] ?? '',
      municipio: data['municipio'] ?? '',
      marca: data['marca'] ?? '',
      modelo: data['modelo'] ?? '',
      capacidad: data['capacidad'] ?? '',
      uidUsuario: data['uidUsuario'] ?? '',
    );
  }
}
