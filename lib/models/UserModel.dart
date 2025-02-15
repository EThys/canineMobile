import 'dart:convert';
import 'dart:ffi';

// Function to parse JSON data into UserModel
UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String registerModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? username;
  String? nom;
  String? matricule;
  String? postnom;
  String? prenom;
  String? adresse;
  int? profession_id;
  int? user_type_id;
  String? genre;
  String? password;
  String? telephone;
  String? email;
  String? date_naissance;
  String? structure;
  String? specialite;
  String? image_profil;
  int? is_admin;
  User? user;

  UserModel({
    this.username,
    this.nom,
    this.matricule,
    this.postnom,
    this.prenom,
    this.adresse,
    this.profession_id,
    this.user_type_id,
    this.genre,
    this.password,
    this.telephone,
    this.email,
    this.date_naissance,
    this.structure,
    this.specialite,
    this.image_profil,
    this.is_admin,
    this.user,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    nom: json["nom"],
    username: json["username"],
    matricule: json["matricule"],
    postnom: json["postnom"],
    prenom: json["prenom"],
    user_type_id: json["user_type_id"],
    adresse: json["adresse"],
    profession_id: json["profession_id"],
    genre: json["genre"],
    password: json["password"],
    telephone: json["telephone"],
    email: json["email"],
    date_naissance: json["date_naissance"],
    structure: json["structure"],
    specialite: json["specialite"],
    image_profil: json["image_profil"],
    is_admin: json["is_admin"],
    user: json["user"] != null ? User.fromJson(json["user"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "nom": nom,
    "username": username,
    "matricule": matricule,
    "postnom": postnom,
    "prenom": prenom,
    "adresse": adresse,
    "profession_id": profession_id,
    "user_type_id": user_type_id,
    "genre": genre,
    "password": password,
    "telephone": telephone,
    "email": email,
    "date_naissance": date_naissance,
    "structure": structure,
    "specialite": specialite,
    "image_profil": image_profil,
    "is_admin": is_admin,
    "user": user?.toJson(),
  };
}

class User {
  int id;
  String username;
  int user_type_id;
  String email;
  dynamic email_verified_at;
  DateTime created_at;
  DateTime updated_at;
  int? is_admin;

  User({
    required this.id,
    required this.username,
    required this.user_type_id,
    required this.email,
    this.email_verified_at,
    required this.created_at,
    required this.updated_at,
    required this.is_admin
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    user_type_id: json["user_type_id"],
    email: json["email"],
    email_verified_at: json["email_verified_at"],
    created_at: DateTime.parse(json["created_at"]),
    updated_at: DateTime.parse(json["updated_at"]),
    is_admin: json["is_admin"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "user_type_id": user_type_id,
    "email": email,
    "email_verified_at": email_verified_at,
    "is_admin":is_admin,
    "created_at": created_at.toIso8601String(),
    "updated_at": updated_at.toIso8601String(),
  };
}
