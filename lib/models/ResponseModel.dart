// To parse this JSON data, do
//
//     final responseModel = responseModelFromJson(jsonString);

import 'dart:convert';

ResponseModel responseModelFromJson(String str) => ResponseModel.fromJson(json.decode(str));

String responseModelToJson(ResponseModel data) => json.encode(data.toJson());

class ResponseModel {
  bool? status;
  String? errorMsg;
  dynamic data;

  ResponseModel({
    this.status,
    this.errorMsg,
    this.data,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
    status: json["status"],
    errorMsg: json["errorMsg"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorMsg": errorMsg,
    "data": data,
  };
}
