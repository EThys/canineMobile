// void _search() async {
//   String query = _searchController.text;
//   print("Muzolaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
//   bool isConnected = await checkInternetConnectivity();
//   print("blesiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiing");
//
//   setState(() {
//     _hasSearched = true;
//     _isLoading=true;
//     results = [];
//   });
//   print("candyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
//   // Show loading indicator immediately
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return Center(child: CircularProgressIndicator());
//     },
//   );
//
//   try {
//     if (query.isEmpty) {
//       _searchAllUsers();
//       if (isConnected) {
//         print("MAMAMAMAMMAMAMAMAMA ${isConnected}");
//         await _searchAllUsersViaAPI();
//       }
//       return;
//     }
//
//     if (isConnected) {
//       print("MAMAMAMAMMAMAMAMAMA ${isConnected}");
//       try {
//         await _searchViaAPI(query);
//       } catch (e) {
//         showMsg(context, false, "Erreur de connexion");;
//       }
//
//     } else {
//       print("BIBIBIIEEEEEEEEEEEEE ${isConnected}");
//       try {
//         _searchLocally(query);
//       } catch (e) {
//         showMsg(context, false, "Erreur");
//       }
//       print("luzoolooooooooooooooooooooooooooooooooooooooooooooooo");
//
//     }
//   } finally {
//     Navigator.of(context).pop();
//     setState(() {_isLoading=false;});
//   }
// }
//
// Future<bool> checkInternetConnectivity() async {
//   var connectivityResult = await (Connectivity().checkConnectivity());
//   if (connectivityResult != ConnectivityResult.none) {
//     return await InternetConnectionChecker.instance.hasConnection;
//   }
//   return false;
// }
//
// void _searchAllUsers() {
//   var localListUsers = stockage.read(StockageKeys.allUsers);
//   if (localListUsers != null) {
//     results = (localListUsers['personnels'] as List)
//         .map<Map<String, dynamic>>((e) => UserModel.fromJson(e).toJson())
//         .toList();
//   } else {
//     results = [];
//   }
//   _hasSearched = true;
//   setState(() {  });
// }
//
// Future<void> _searchAllUsersViaAPI() async {
//   var ctrl = context.read<AuthentificationCtrl>();
//   var res = await ctrl.getListUsers();
//
//   if (res.status == true) {
//     results = res.data;
//     print("MATAMAAAEE");
//   } else {
//     print("Erreur lors de la recherche : ${res.errorMsg}");
//     SnackbarHelper.showSnackBar(res.errorMsg, isError: true);
//   }
// }
//
// Future<void> _searchViaAPI(String query) async {
//   Map<String, dynamic> querySearch = {"matricule": query};
//   var ctrl = context.read<RechercheController>();
//   var res = await ctrl.searchMembers(querySearch);
//
//   if (res.status == true) {
//     results = res.data;
//   } else {
//     print("Erreur lors de la recherche : ${res.errorMsg}");
//     SnackbarHelper.showSnackBar(res.errorMsg, isError: true);
//   }
// }
//
// void _searchLocally(String query) {
//   var localListUsers = stockage.read(StockageKeys.allUsers);
//   if (localListUsers != null) {
//     results = (localListUsers['personnels'] as List)
//         .where((user) => UserModel.fromJson(user).matricule?.toLowerCase().contains(query.toLowerCase()) ?? false)
//         .map<Map<String, dynamic>>((e) => UserModel.fromJson(e).toJson())
//         .toList();
//   } else {
//     results = [];
//     SnackbarHelper.showSnackBar("Aucune donnée locale disponible", isError: true);
//   }c'est le check de la connexion qui prend trop du temsp avant de lancer ma requette de la recherche comment mieux le faire
// }