// To parse this JSON data, do
//
//     final professionModel = professionModelFromJson(jsonString);

import 'dart:convert';

ProfessionModel professionModelFromJson(String str) => ProfessionModel.fromJson(json.decode(str));

String professionModelToJson(ProfessionModel data) => json.encode(data.toJson());

class ProfessionModel {
  int ? id;
  String ? title;

  ProfessionModel({
    this.id,
    this.title,
  });

  factory ProfessionModel.fromJson(Map<String, dynamic> json) => ProfessionModel(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
  @override
  String toString() {
    return title ?? 'Unknown Profession';
  }
}
