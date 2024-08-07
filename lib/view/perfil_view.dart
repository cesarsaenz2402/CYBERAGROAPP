import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioPage extends StatelessWidget {
  const UsuarioPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            return Center(child: Text('No hay usuario autenticado'));
          } else {
            final user = snapshot.data!;
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('No se encontraron datos de usuario'));
                } else {
                  final userData = snapshot.data!.data() as Map<String, dynamic>;
                  final photoUrl = userData['photoUrl'] ?? 'assets/images/avatar.png';

                  return ListView(
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImagePage(imageUrl: photoUrl),
                              ),
                            );
                          },
                          child: ClipOval(
                            child: Image(
                              image: photoUrl.startsWith('http')
                                  ? NetworkImage(photoUrl)
                                  : AssetImage(photoUrl) as ImageProvider,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text(
                          'Nombre',
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          userData['name'].toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text(
                          'Correo',
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          userData['email'].toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text(
                          'Teléfono',
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          userData['phone'].toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.supervisor_account),
                        title: Text(
                          'Rol',
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          userData['role'].toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      body: Center(
        child: Text('Aquí puedes implementar la edición del perfil.'),
      ),
    );
  }
}

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImagePage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Imagen de Perfil'),
      ),
      body: Center(
        child: Hero(
          tag: 'profileImage',
          child: Image(
            image: imageUrl.startsWith('http')
                ? NetworkImage(imageUrl)
                : AssetImage(imageUrl) as ImageProvider,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
