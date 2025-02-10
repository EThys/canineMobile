import 'package:flutter/material.dart';
import 'package:canineappadmin/models/LoginModel.dart';
import 'package:canineappadmin/models/UserModel.dart';
import 'package:canineappadmin/utils/Endpoints.dart';
import '../models/PersonelModel.dart';
import '../models/ResponseModel.dart';
import '../utils/requetes.dart';
import 'package:get_storage/get_storage.dart';
import '../utils/StockageKeys.dart';

class AuthentificationCtrl with ChangeNotifier {
  AuthentificationCtrl({this.stockage});

  String _token = "";

  String get token {
    var locale = stockage?.read<String>(StockageKeys.tokenKey);
    return locale ?? "";
  }

  set token(String value) {
    stockage?.write(StockageKeys.tokenKey, value);
    _token = value;
  }

  UserModel _user = UserModel();
  List <UserModel> listUsers = [];
  UserModel _userAuth=UserModel();
  GetStorage? stockage;

  List<UserModel> Listregister = [];
  List<UserModel> Listlogin = [];
  bool loading = false;

  UserModel get user {
    var locale = stockage?.read(StockageKeys.userKey);
    _user = UserModel?.fromJson(locale);
    return _user;
  }
  set user(UserModel value) {
    stockage?.write(StockageKeys.userKey, value.toJson());
    _user = value;
  }

  UserModel get userPreference {
    var locale = stockage?.read(StockageKeys.userPreferenceKey);
    _user = UserModel?.fromJson(locale);
    return _user;
  }

  set userPreference(UserModel value) {
    stockage?.write(StockageKeys.userPreferenceKey, value.toJson());
    _user = value;
  }

  Future<ResponseModel> getListUsers() async {
    var url = "${Endpoints.userAll}";
    loading = true;
    notifyListeners();
    print("VOICIIIIIIIIII ${url} ");
    var tkn = stockage?.read(StockageKeys.tokenKey);
    print("VOICIIIIIIIIII ${tkn} ");
    var reponse = await getData(url, token: tkn);

    print("Résultat de la récupération ${reponse}");

    if (reponse != null) {
      List userAll = reponse['personnels'];
      List<UserModel> myUser = userAll.map<UserModel>((e) =>
          UserModel.fromJson(e)).toList();
      listUsers = myUser;
      stockage?.write(StockageKeys.allUsers, reponse);
      loading = false;
      notifyListeners();
      return ResponseModel(status: true, data: userAll);
    } else {
      var localListUsers = stockage?.read(StockageKeys.allUsers);
      if (localListUsers != null) {
        var temp = (localListUsers['personnels'] as List)
            .map<UserModel>((e) => UserModel.fromJson(e))
            .toList();
        listUsers = temp;
        print("data stockee :${temp}");
        loading = false;
        notifyListeners();
        return ResponseModel(status: true, data: localListUsers['personnels']);
      } else {
        loading = false;
        notifyListeners();
        return ResponseModel(status: false, errorMsg: "Aucune donnée disponible");
      }
    }
  }

  Future<HttpResponse> login(Map data) async {
    var url = "${Endpoints.loginEndpoint}";
    print("ethberg${url}");

    HttpResponse response = await postData(url, data);

    if (response.status == true) {
      var temp_userPreference = response.data?["user"] ?? {};
      var temp_personnel = response.data?["personnel"];

      user = UserModel.fromJson(temp_userPreference);
      Personnel? personnel;

      if (temp_personnel != null) {
        userPreference= UserModel.fromJson(temp_personnel);
      }

      print("User Info: ${user}");
      print("Personnel Info: ${personnel}");

      stockage?.write(StockageKeys.tokenKey, response.data?['token'] ?? "");

      notifyListeners();

      var _token = stockage?.read(StockageKeys.tokenKey);
      print("Token stored: ${_token}");

      getListUsers();
      print("${getListUsers.toString()}");
    }

    print(response.data);
    return response;
  }

  Future<HttpResponse> register(Map<String, dynamic> userData) async {
    try {
      final url = Endpoints.signUpEndpoint;
      print("urlllllllllll: $url");
      HttpResponse response = await postData(url, userData);
      print("urlllllllllll: ${response.data}");

      if (response.status==true) {
        print("Inscription reussie: ${response.data}");
        notifyListeners();
      } else {
        print("Registration failed: ${response.errorMsg}");
      }

      return response;
    } catch (e) {
      print("Exception during registration: $e");
      return HttpResponse(
          status: false,
          errorMsg: "Une erreur est survenue lors de l'inscription",
          isException: true
      );
    }
  }

  Future<HttpResponse> logout(Map data) async {
    var url = "${Endpoints.logout}";
    var tkn = stockage?.read(StockageKeys.tokenKey);
    HttpResponse response = await postData(url, data, token: tkn);
    if (response.status) {
      print("${response.status}");
      notifyListeners();
    }
    print(response.data);

    return response;
  }

// "identifiant": "jean.dupont@example.com",
// "password": "12345678"
}
void main(){
  var ctrl=AuthentificationCtrl();
  ctrl.getListUsers();
}

