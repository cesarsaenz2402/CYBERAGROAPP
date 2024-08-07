// models/user_model.dart
class UserModel {
  String? id;
  String name;
  String email;
  String phone;
  String role;
  String profilePictureUrl;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.profilePictureUrl,
  });

  // Método para convertir el modelo a un mapa para Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  // Método para crear un modelo desde un mapa de Firebase
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      role: map['role'],
      profilePictureUrl: map['profilePictureUrl'],
    );
  }
}
