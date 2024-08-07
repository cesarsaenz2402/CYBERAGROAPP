// login_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_conect/recuperar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa firebase_auth
import 'view/HomeView2.dart';
import 'view/home_view.dart';

import 'registrar.dart'; // Importa la página RegistrarUsuario
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

import 'viewmodel/HomeViewModel2.dart';
import 'viewmodel/home_viewmodel.dart';


void main() {
  runApp(const LoginPage());
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Agrega una clave global para el formulario

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Get the user's role from Firestore
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();
        final role = userDoc.get('role');

        // Navigate to the correct home page based on the user's role
        if (role == 'arrendatario') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeView_arrend(viewModel: HomeViewModel())),
          );
        } else if (role == 'arrendador') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeView_arrendatario(viewModel: HomeViewModelar())), // Navega a HomeScreen
          );
        } else {
          // Handle unknown role
          print('Unknown role: $role');
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _signInWithGoogle() async {
    try {
      // Solicitar la autenticación con cuenta de Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Verificar si la autenticación fue exitosa
      if (googleUser!= null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Iniciar sesión con la credencial de Google
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        // Get the user's role from Firestore
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();
        final role = userDoc.get('role');

        // Navigate to the correct home page based on the user's role
        if (role == 'arrendador') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeView_arrend(viewModel: HomeViewModel())), // Navega a HomeScreen2
          );
        } else if (role == 'arrendatario') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeView_arrendatario(viewModel: HomeViewModelar())), // Navega a HomeScreen
          );
        } else {
          // Handle unknown role
          print('Unknown role: $role');
        }
      } else {
        // El usuario canceló la autenticación con Google
        print('Autenticación con Google cancelada');
      }
    } catch (e) {
      // Manejar errores de autenticación con Google
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error al iniciar sesión con cuenta de Google: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _goToRegistrar() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterUserForm()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                Image.asset(
                  'assets/images/splash_image.png',
                  height: 250, // Altura del logo
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Correo electrónico requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Contraseña requerida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent, // Color de fondo del botón
                    minimumSize: Size(double.infinity, 50), // Tamaño mínimo del botón
                  ),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white, // Color del texto
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RecuperarPage()),
                    );
                  },
                  child: const Text('Recuperar contraseña'),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: _goToRegistrar,
                  child: const Text('¿No tienes cuenta? Regístrate aquí'),
                ),

                //...
              ],
            ),
          ),
        ),
      ),
    );
  }
}

