import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart'; // Asegúrate de que este archivo exista y contenga el widget LoginPage

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/splash_image.png',
          height: 250, // Altura del logo
          fit: BoxFit.cover, // Ajustar la imagen para que quepa dentro del espacio asignado
        ), // Asegúrate de tener esta imagen en tu carpeta assets
      ),
    );
  }
}
