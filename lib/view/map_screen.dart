import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  MapType _currentMapType = MapType.normal;
  Offset _fabPosition = Offset(20.0, 20.0);
  BitmapDescriptor? customIcon;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
    _fetchMarkers();
  }

  Future<void> _loadCustomMarker() async {
    final BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(45, 45)),
      'assets/images/tractor.png',
    );
    setState(() {
      customIcon = icon;
    });
  }

  Future<void> _fetchMarkers() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('equipos').get();
      for (var doc in snapshot.docs) {
        var data = doc.data();
        String id = doc.id;
        String nombre = data['nombre'];
        String descripcion = data['descripcion'];
        String ubicacion = data['ubicacion'];
        String imagenUrl = data['imagen']; // URL de la imagen en Firebase Storage

        try {
          List<Location> locations = await locationFromAddress(ubicacion);
          if (locations.isNotEmpty) {
            Location location = locations.first;
            setState(() {
              markers.add(
                Marker(
                  markerId: MarkerId(id),
                  position: LatLng(location.latitude, location.longitude),
                  infoWindow: InfoWindow(
                    title: nombre,
                    snippet: ubicacion,
                    onTap: () {
                      _showEquipmentInfo(context, descripcion, imagenUrl);
                    },
                  ),
                  icon: customIcon ?? BitmapDescriptor.defaultMarker,
                ),
              );
            });
          } else {
            print('No se encontraron coordenadas para la ubicación: $ubicacion');
          }
        } catch (e) {
          print("Error al convertir la dirección a coordenadas: $e");
        }
      }
    } catch (e) {
      print("Error al obtener los datos de Firestore: $e");
    }
  }

  void _showEquipmentInfo(BuildContext context, String descripcion, String imagenUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Información del equipo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Descripción: $descripcion'),
              SizedBox(height: 10),
              Image.network(
                imagenUrl,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType =
      _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(6.244203, -75.581211), // Coordenadas de inicio, Medellín
              zoom: 12.0,
            ),
            markers: markers,
            mapType: _currentMapType,
          ),
          Positioned(
            left: _fabPosition.dx,
            top: _fabPosition.dy,
            child: Draggable(
              feedback: FloatingActionButton(
                onPressed: _toggleMapType,
                child: Icon(Icons.map),
                backgroundColor: Colors.blue,
              ),
              childWhenDragging: Container(),
              onDragEnd: (details) {
                setState(() {
                  _fabPosition = details.offset;
                });
              },
              child: FloatingActionButton(
                onPressed: _toggleMapType,
                child: Icon(Icons.map),
                backgroundColor: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
