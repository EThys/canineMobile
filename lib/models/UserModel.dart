// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String registerModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String ? username;
  String ? nom;
  String ? matricule;
  String ? postnom;
  String ? prenom;
  String ? adresse;
  int ? profession_id;
  int ? user_type_id;
  String ? genre;
  String ? password;
  String ? telephone;
  String ? email;

  UserModel({
    this.username,
    this.nom,
    this.matricule,
    this.postnom,
    this.prenom,
    this.user_type_id,
    this.adresse,
    this.profession_id,
    this.genre,
    this.password,
    this.telephone,
    this.email
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
    email:json["email"]
  );

  Map<String, dynamic> toJson()  => {
    "nom": nom,
    "username":username,
    "matricule":matricule,
    "postnom": postnom,
    "user_type_id":user_type_id,
    "prenom": prenom,
    "adresse": adresse,
    "profession_id": profession_id,
    "genre": genre,
    "password": password,
    "telephone": telephone,
    "email":email
  };
}
