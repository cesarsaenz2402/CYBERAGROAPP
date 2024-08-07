import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/HomeViewModel2.dart';
import '../viewmodel/RegistroEquipoViewModel.dart';
import 'RegistroEquipoPage.dart';

import 'arrendador.dart'; // Asegúrate de importar esta página

// Arrendador
class HomeView_arrendatario extends StatefulWidget {
  final HomeViewModelar viewModel;

  const HomeView_arrendatario({Key? key, required this.viewModel}) : super(key: key);

  @override
  _HomeView_arrendatarioState createState() => _HomeView_arrendatarioState();
}

class _HomeView_arrendatarioState extends State<HomeView_arrendatario> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    ListadoMaquinariaPage(), // Muestra el listado de maquinarias en lugar del texto de bienvenida
    ChangeNotifierProvider(
      create: (_) => RegistroEquipoViewModel(),
      child: RegistroEquipoPage(),
    ),
    // Agrega más widgets según sea necesario
  ];

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
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Registrar Equipo',
          ),
          // Agrega más elementos de la barra de navegación según sea necesario
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
