import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterUserForm extends StatefulWidget {
  @override
  _RegisterUserFormState createState() => _RegisterUserFormState();
}

class _RegisterUserFormState extends State<RegisterUserForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String? _name, _email, _password, _role = 'arrendador';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrarse'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su nombre';
                  }
                  return null;
                },
                onSaved: (value) => _name = value,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty ||!value.contains('@')) {
                    return 'Por favor, ingrese un correo electrónico válido';
                  }
                  return null;
                },
                onSaved: (value) => _email = value,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 8) {
                    return 'Por favor, ingrese una contraseña válida';
                  }
                  return null;
                },
                onSaved: (value) => _password = value,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Rol',
                  border: OutlineInputBorder(),
                ),
                value: _role,
                onChanged: (value) => setState(() => _role = value),
                items: [
                  DropdownMenuItem(child: Text('Arrendador'), value: 'arrendador'),
                  DropdownMenuItem(child: Text('Arrendatario'), value: 'arrendatario'),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    try {
                      // Verificar si el usuario existe
                      final methods = await FirebaseAuth.instance
                          .fetchSignInMethodsForEmail(_email!);
                      if (methods.isNotEmpty) {
                        // Mostrar notificación de usuario existente
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('El usuario con ese correo electrónico ya existe'),
                          ),
                        );
                        return;
                      }

                      // Crear usuario en Firebase Authentication
                      final userCredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: _email!,
                        password: _password!,
                      );

                      // Agregar usuario a la colección de usuarios en Cloud Firestore
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userCredential.user!.uid)
                          .set({
                        'uid': userCredential.user!.uid,
                        'name': _name!,
                        'email': _email!,
                        'role': _role!,
                      }); // Agregué las llaves de cierre aquí

                      // Redirigir a la pantalla de inicio
                      Navigator.pushReplacementNamed(context, '/');
                    } catch (e) {
                      // Mostrar notificación de error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al registrar usuario: $e'),
                        ),
                      );
                    }
                  }
                },
                child: Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}