import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/RegistroEquipoViewModel.dart';
import '../models/equipo.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class RegistroEquipoPage extends StatefulWidget {
  @override
  _RegistroEquipoPageState createState() => _RegistroEquipoPageState();
}

class _RegistroEquipoPageState extends State<RegistroEquipoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _disponibleController = TextEditingController(text: 'false');
  final _precioController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _municipio = TextEditingController();
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _capacidadController = TextEditingController();
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    setState(() {
      if (pickedFiles != null) {
        _images = pickedFiles.map((file) => File(file.path)).toList();
      } else {
        print('No images selected.');
      }
    });
  }

  Future<List<String>> _uploadImagesToFirebase() async {
    List<String> imageUrls = [];
    if (_images.isEmpty) {
      throw 'No images selected';
    }

    for (File image in _images) {
      String fileName = Uuid().v4();
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('Equipos')
          .child('$fileName.jpg');
      UploadTask uploadTask = firebaseStorageRef.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      imageUrls.add(imageUrl);
    }
    return imageUrls;
  }

  void _showResultDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                if (message.contains('exitosamente')) {
                  _resetForm(); // Reinicia el formulario si el registro fue exitoso
                }
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nombreController.clear();
    _descripcionController.clear();
    _categoriaController.clear();
    _disponibleController.text = 'false';
    _precioController.clear();
    _ubicacionController.clear();
    _municipio.clear();
    _marcaController.clear();
    _modeloController.clear();
    _capacidadController.clear();
    setState(() {
      _images.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // Obtiene el usuario actual
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Equipo'),
        backgroundColor: Colors.greenAccent, // Ejemplo de color
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre del equipo',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción del equipo',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoriaController,
                decoration: InputDecoration(
                  labelText: 'Categoría',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una categoría';
                  }
                  return null;
                },
              ),
              TextButton(
                onPressed: _pickImages,
                child: Text('Seleccionar imágenes'),
              ),
              _images.isEmpty
                  ? Text('No se han seleccionado imágenes.')
                  : Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _images.map((image) {
                  return Image.file(
                    image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  );
                }).toList(),
              ),
              SwitchListTile(
                title: Text('Disponible'),
                value: _disponibleController.text == 'true',
                activeColor: Colors.greenAccent, // Ejemplo de color
                onChanged: (bool value) {
                  setState(() {
                    _disponibleController.text = value.toString();
                  });
                },
              ),
              TextFormField(
                controller: _precioController,
                decoration: InputDecoration(
                  labelText: 'Precio de arrendamiento',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un precio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ubicacionController,
                decoration: InputDecoration(
                  labelText: 'Ubicación',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una ubicación';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _municipio,
                decoration: InputDecoration(
                  labelText: 'Municipio',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un municipio';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _marcaController,
                decoration: InputDecoration(
                  labelText: 'Marca',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una marca';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _modeloController,
                decoration: InputDecoration(
                  labelText: 'Modelo',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un modelo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _capacidadController,
                decoration: InputDecoration(
                  labelText: 'Capacidad',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una capacidad';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      List<String> imageUrls = await _uploadImagesToFirebase();

                      var uuid = Uuid();
                      Equipo nuevoEquipo = Equipo(
                        id: uuid.v4(),
                        nombre: _nombreController.text,
                        descripcion: _descripcionController.text,
                        categoria: _categoriaController.text,
                        imagen: imageUrls, // Cambiar a una lista de URLs
                        disponible: _disponibleController.text == 'true',
                        precio: double.parse(_precioController.text),
                        ubicacion: _ubicacionController.text,
                        municipio: _municipio.text,
                        marca: _marcaController.text,
                        modelo: _modeloController.text,
                        capacidad: _capacidadController.text,
                        uidUsuario: user!.uid, // Asigna el UID del usuario actual
                      );
                      await Provider.of<RegistroEquipoViewModel>(context, listen: false)
                          .registrarEquipo(nuevoEquipo);

                      _showResultDialog('Equipo registrado exitosamente');
                    } catch (e) {
                      _showResultDialog('Error registrando equipo: $e');
                    }
                  }
                },
                child: Text('Registrar Equipo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
