// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String ? userName;
  String ? password;
  String ? token;

  LoginModel({
    this.userName,
    this.password,
    this.token,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    userName: json["userName"],
    password: json["password"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "userName": userName,
    "password": password,
    "token": token,
  };
}
