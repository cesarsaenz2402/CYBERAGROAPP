import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/equipo.dart';


class ListadoMaquinariaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Equipos'),
        backgroundColor: Colors.greenAccent, // Ejemplo de color
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('equipos') // Asegúrate de que este nombre sea correcto
            .where('uidUsuario', isEqualTo: user?.uid) // Filtro por UID
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay equipos registrados.'));
          }

          final equipos = snapshot.data!.docs.map((doc) {
            return Maquinaria.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();

          return ListView.builder(
            itemCount: equipos.length,
            itemBuilder: (context, index) {
              final maquinaria = equipos[index];
              return ListTile(
                title: Text(maquinaria.nombre),
                subtitle: Text(maquinaria.descripcion),
                leading: maquinaria.imagenes.isNotEmpty
                    ? Image.network(maquinaria.imagenes[0], width: 50, height: 50, fit: BoxFit.cover)
                    : null,
                trailing: Text('\$${maquinaria.precio}'),
              );
            },
          );
        },
      ),
    );
  }
}
