import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'full_screen_image.dart'; // Importa el paquete de carrusel

class ArrendamientoView extends StatefulWidget {
  final String nombreEquipo; // Nombre del equipo a arrendar

  ArrendamientoView({required this.nombreEquipo});

  @override
  _ArrendamientoViewState createState() => _ArrendamientoViewState();
}

class _ArrendamientoViewState extends State<ArrendamientoView> {
  DateTime _fechaInicio = DateTime.now(); // Fecha inicial por defecto
  int _duracionDias = 1; // Duración del arrendamiento en días, por defecto 1 día
  double _precioPorDia = 0.0; // Precio por día, inicializado a 0.0
  double _precioActualFirebase = 0.0; // Precio actual almacenado en Firebase

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? _informacionEquipo;

  @override
  void initState() {
    super.initState();
    // Recuperar información del equipo desde Firebase al inicio
    _obtenerInformacionDesdeFirebase();
  }

  Future<void> _obtenerInformacionDesdeFirebase() async {
    try {
      // Obtener el documento del equipo desde Firestore
      DocumentSnapshot snapshot = await _firestore.collection('equipos')
          .where('nombre', isEqualTo: widget.nombreEquipo)
          .get()
          .then((querySnapshot) => querySnapshot.docs.first);

      // Extraer la información del equipo almacenada en Firebase
      if (snapshot.exists) {
        setState(() {
          _informacionEquipo = snapshot.data() as Map<String, dynamic>?;
          _precioPorDia = _informacionEquipo?['precio']?.toDouble() ?? 0.0; // Usa el precio desde Firebase
          _calcularPrecio(); // Calcula el precio total con el precio obtenido
        });
      }
    } catch (e) {
      print('Error al obtener información desde Firebase: $e');
    }
  }

  String _formatearPrecio(double precio) {
    final formatCurrency = NumberFormat.currency(
      locale: 'es_CO', // Configura la localidad a Colombia
      symbol: '', // No mostrar el símbolo de moneda
      decimalDigits: 2, // Muestra hasta dos decimales
    );
    return formatCurrency.format(precio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arrendar ${widget.nombreEquipo}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Muestra la información del equipo
              Text(
                'Detalles del equipo:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Agrega el carrusel de imágenes
              _buildCarruselDeImagenes(),
              SizedBox(height: 10),
              Text('Marca: ${_informacionEquipo?['marca'] ?? 'N/A'}'),
              Text('Modelo: ${_informacionEquipo?['modelo'] ?? 'N/A'}'),
              Text('Descripción: ${_informacionEquipo?['descripcion'] ?? 'N/A'}'),
              Text('Ubicación: ${_informacionEquipo?['ubicacion'] ?? 'N/A'}'),
              Text('Municipio: ${_informacionEquipo?['municipio'] ?? 'N/A'}'),
              Text('Capacidad: ${_informacionEquipo?['capacidad'] ?? 'N/A'}'),
              SizedBox(height: 20),
              Text(
                'Selecciona las opciones de arrendamiento:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('Fecha de inicio:'),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      _seleccionarFecha(context);
                    },
                    child: Text(
                      '${_fechaInicio.day}/${_fechaInicio.month}/${_fechaInicio.year}',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('Duración (días):'),
                  SizedBox(width: 10),
                  DropdownButton<int>(
                    value: _duracionDias,
                    onChanged: (value) {
                      setState(() {
                        _duracionDias = value!;
                        _calcularPrecio();
                      });
                    },
                    items: [1, 3, 7, 15, 30].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('Precio total: ${_formatearPrecio(_precioActualFirebase)}'),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Guardar arrendamiento en Firebase Firestore con el nuevo precio total
                  try {
                    await _firestore.collection('arrendamientos').add({
                      'nombreEquipo': widget.nombreEquipo,
                      'fechaInicio': _fechaInicio,
                      'duracionDias': _duracionDias,
                      'precioTotal': _precioActualFirebase, // Solo el precio calculado
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Arrendamiento guardado correctamente'),
                      ),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al guardar arrendamiento: $e'),
                      ),
                    );
                  }
                },
                child: Text('Arrendar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarruselDeImagenes() {
    if (_informacionEquipo?['imagen'] == null) {
      return Container(); // No hay imágenes
    }

    var imagenes = _informacionEquipo!['imagen'];

    if (imagenes is String) {
      // Si solo hay una imagen, conviértela en una lista de un solo elemento
      imagenes = [imagenes];
    }

    if (imagenes is List<dynamic>) {
      return CarouselSlider(
        options: CarouselOptions(
          height: 200.0,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          viewportFraction: 0.8,
        ),
        items: imagenes.map((item) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FullScreenImage(
                    imageUrls: imagenes.cast<String>(), // Pasa la lista completa de imágenes
                    initialIndex: imagenes.indexOf(item), // Pasa el índice de la imagen actual
                  ),
                ),
              );
            },
            child: Container(
              child: Center(
                child: Image.network(item, fit: BoxFit.cover, width: 1000),
              ),
            ),
          );
        }).toList(),
      );
    }

    return Container(); // No se reconoce el formato de imágenes
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _fechaInicio,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null && pickedDate != _fechaInicio) {
      setState(() {
        _fechaInicio = pickedDate;
      });
    }
  }

  void _calcularPrecio() {
    setState(() {
      _precioActualFirebase = _duracionDias * _precioPorDia; // Calcula el precio total con el precio obtenido de Firebase
    });
  }
}
