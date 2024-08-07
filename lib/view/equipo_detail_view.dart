 
import 'package:flutter/material.dart';
import '../viewmodel/equipo_detail_viewmodel.dart';
import '../../models/equipo.dart';

class EquipoDetailView extends StatelessWidget {
  final Equipo equipo;
  final EquipoDetailViewModel viewModel;

  const EquipoDetailView({Key? key, required this.equipo, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Equipo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              equipo.nombre,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              equipo.descripcion,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Precio: \$${equipo.precio.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Ubicación: ${equipo.ubicacion}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implementar acción de reserva o gestión de equipo
              },
              child: Text('Reservar'),
            ),
          ],
        ),
      ),
    );
  }
}
