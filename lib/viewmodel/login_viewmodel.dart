import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoginViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _username = '';
  String _password = '';

  void setUsername(String username) {
    _username = username;
  }

  void setPassword(String password) {
    _password = password;
  }

  Future<void> login(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _username,
        password: _password,
      );
      // Login exitoso, puedes navegar a la pantalla principal
      print('Login exitoso: ${userCredential.user}');
    } catch (e) {
      // Manejo de errores
      print('Error de login: $e');
    }
  }
}
