import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/equipment_viewmodel.dart';
import 'arrendamiento_view.dart'; // Importa ArrendamientoView
import '../services/firebase_service.dart'; // Si aún no lo has importado, asegúrate de importar FirebaseService

class EquipmentListView extends StatelessWidget {
  final FirebaseService _db = FirebaseService(); // Instancia del servicio

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EquipmentViewModel>(
      create: (context) => EquipmentViewModel(),
      child: Scaffold(

        body: Consumer<EquipmentViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.equipments.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: viewModel.equipments.length,
              itemBuilder: (context, index) {
                final equipment = viewModel.equipments[index];
                return GestureDetector(
                  onTap: () {
                    // Navegar a la vista de arrendamiento al presionar la tarjeta
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ArrendamientoView(nombreEquipo: equipment.nombre)),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (equipment.imagen != null)
                            Image.network(equipment.imagen!),
                          SizedBox(height: 10),
                          Text(
                            equipment.nombre,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (!equipment.disponible)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                color: Colors.red,
                                child: Text(
                                  'No disponible',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Marca:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${equipment.marca}',
                                ),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Modelo:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${equipment.modelo}',
                                ),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Descripción:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${equipment.descripcion}',
                                ),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Precio:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${equipment.precio}',
                                ),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Ubicación:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${equipment.ubicacion}',
                                ),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Municipio:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${equipment.municipio}',
                                ),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Capacidad:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${equipment.capacidad}',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
