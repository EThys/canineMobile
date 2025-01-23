import 'package:flutter/material.dart';
import 'package:canineappadmin/models/UserModel.dart';
import 'package:canineappadmin/utils/Endpoints.dart';
import 'package:get_storage/get_storage.dart';
import '../utils/requetes.dart';

class RechercheController with ChangeNotifier {
  RechercheController({this.stockage});
  List<UserModel> _searchResults = [];
  bool _loading = false;

  var stockage;

  List<UserModel> get searchResults => _searchResults;
  bool get loading => _loading;

  Future<HttpResponse> searchMembers(Map<String, dynamic> data) async {
    try {
      final url = Endpoints.searchEndpoint;
      print("Request URL: $url");

      HttpResponse response = await postDataList(url, data);
      print("Response data: ${response.data}");

      if (response.status == true) {

        List<Map<String, dynamic>> memberDataList = (response.data as List<dynamic>)
            .map((item) => item as Map<String, dynamic>)
            .toList();

        List<UserModel> members = memberDataList.map<UserModel>((memberData) {
          return UserModel.fromJson(memberData);
        }).toList();

        print("Search successful: ${members.length} members found.");


        notifyListeners();

        return response;
      } else {
        print("Search failed: ${response.errorMsg}");
        return response;
      }

    } catch (e) {
      print("Exception during search: $e");

      return HttpResponse(
        status: false,
        errorMsg: "An error occurred during the search.",
        isException: true,
      );
    }
  }




}
void main(){
  var ctrl=RechercheController();
  ctrl.searchMembers({
    "matricule": "0006"

  });
}
