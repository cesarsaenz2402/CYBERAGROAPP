import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../viewmodel/home_viewmodel.dart';
import 'equipment_list_view.dart';
import 'map_screen.dart';
import 'perfil_view.dart'; // Importar PerfilView

class HomeView_arrend extends StatefulWidget {
  final HomeViewModel viewModel;

  const HomeView_arrend({Key? key, required this.viewModel}) : super(key: key);

  @override
  _HomeView_arrendState createState() => _HomeView_arrendState();
}

class _HomeView_arrendState extends State<HomeView_arrend> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    MapScreen(), // Ahora MapScreen es la primera vista
    EquipmentListView(),
    UsuarioPage(), // Cambié UsuarioPage por PerfilView
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<String> getNombreArrendador() async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc('name').get();
    return userDoc.data()?['name'] ?? 'Desconocido';
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CyberAgroApp'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Equipos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}
