import 'dart:math';

import 'package:canineappadmin/controllers/AuthentificationCtrl.dart';
import 'package:canineappadmin/utils/Routes.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../controllers/SearchController.dart';
import '../models/Profession.dart';
import '../models/UserModel.dart';
import '../utils/StockageKeys.dart';
import '../utils/common_widgets/gradient_background.dart';
import '../utils/helpers/snackbar_helper.dart';
import '../values/app_strings.dart';

class Membrespage extends StatefulWidget {
  const Membrespage({super.key});

  @override
  State<Membrespage> createState() => _MembrespageState();
}

class _MembrespageState extends State<Membrespage> {
  bool _showFloatingActionButton = false;
  GetStorage stockage = GetStorage();
  final List<ProfessionModel> professionList = [
    ProfessionModel(id: 1, title: "Vétérinaire"),
    ProfessionModel(id: 2, title: "Eleveur"),
    ProfessionModel(id: 3, title: "Dresseur"),
    ProfessionModel(id: 4, title: "Educateur"),
    ProfessionModel(id: 5, title: "Toiletteur"),
    ProfessionModel(id: 6, title: "Dealeur"),
    ProfessionModel(id: 7, title: "Cynophile"),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var authCtrl = context.read<AuthentificationCtrl>();
      authCtrl.getListUsers();
    });
    _checkUserType();
  }

  Future<void> _checkUserType() async {
    GetStorage stockage = GetStorage();
    final userTypeId = stockage.read(StockageKeys.userKey)['user_type_id']?? 0;
    setState(() {
      _showFloatingActionButton = userTypeId == 1;
    });
  }

  String? getProfessionTitle(int professionId) {
    final profession = professionList.firstWhere(
          (prof) => prof.id == professionId,
      orElse: () => ProfessionModel(id: -1, title: 'Inconnu'),
    );
    return profession.title;
  }


  final TextEditingController _searchController = TextEditingController();
  List<dynamic> results = [];
  bool _hasSearched = false;


  void _showDetailsDialog(BuildContext context, Map<String, dynamic> result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Détails supplementaires", style: GoogleFonts.lato()),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Username: ${result['user']['username']}', style: GoogleFonts.lato()),
                Text('Postnom: ${result['postnom']}', style: GoogleFonts.lato()),
                Text('Prenom: ${result['prenom']}', style: GoogleFonts.lato()),
                Text('Adresse: ${result['adresse']}', style: GoogleFonts.lato()),
                Text('Téléphone: ${result['telephone']}', style: GoogleFonts.lato()),
                Text('Email: ${result['user']['email']}', style: GoogleFonts.lato()),
                Text('Genre: ${result['genre']}', style: GoogleFonts.lato()),
                Text('Date de Naissance: ${result['date_naissance']}', style: GoogleFonts.lato()),
                // Add more fields as necessary
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Fermer', style: GoogleFonts.lato()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _search() async {
    String query = _searchController.text;
    bool isConnected = await checkInternetConnectivity();

    if (query.isEmpty) {
      _searchAllUsers();
      if(isConnected){
          print("MAMAMAMAMMAMAMAMAMA ${isConnected}");
          await _searchAllUsersViaAPI();
      }
      return;
    }

    setState(() {
      _hasSearched = true;
      results = [];
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    if (isConnected) {
      print("MAMAMAMAMMAMAMAMAMA ${isConnected}");
      await _searchViaAPI(query);
    }
    else {
      print("BIBIBIIIEEEEEEEEEEEE ${isConnected}");
      _searchLocally(query);
    }

    Navigator.of(context).pop(); // Ferme le dialogue de chargement
    setState(() {}); // Rafraîchit l'affichage
  }

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      return await InternetConnectionChecker.instance.hasConnection;
    }
    return false;
  }

  void _searchAllUsers() {
    var localListUsers = stockage.read(StockageKeys.allUsers);
    if (localListUsers != null) {
      results = (localListUsers['personnels'] as List)
          .map<Map<String, dynamic>>((e) => UserModel.fromJson(e).toJson())
          .toList();
    } else {
      results = [];
    }
    _hasSearched = true;
    setState(() {});
  }

  Future<void> _searchAllUsersViaAPI() async {
    var ctrl = context.read<AuthentificationCtrl>();
    var res = await ctrl.getListUsers();

    if (res.status == true) {
      results = res.data;
      print("MATAMAAAEE");
    } else {
      print("Erreur lors de la recherche : ${res.errorMsg}");
      SnackbarHelper.showSnackBar(res.errorMsg, isError: true);
    }
  }

  Future<void> _searchViaAPI(String query) async {
    Map<String, dynamic> querySearch = {"matricule": query};
    var ctrl = context.read<RechercheController>();
    var res = await ctrl.searchMembers(querySearch);

    if (res.status == true) {
      results = res.data;
    } else {
      print("Erreur lors de la recherche : ${res.errorMsg}");
      SnackbarHelper.showSnackBar(res.errorMsg, isError: true);
    }
  }

  void _searchLocally(String query) {
    var localListUsers = stockage.read(StockageKeys.allUsers);
    if (localListUsers != null) {
      results = (localListUsers['personnels'] as List)
          .where((user) => UserModel.fromJson(user).matricule?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .map<Map<String, dynamic>>((e) => UserModel.fromJson(e).toJson())
          .toList();
    } else {
      results = [];
      SnackbarHelper.showSnackBar("Aucune donnée locale disponible", isError: true);
    }
  }



@override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: GradientBackground(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5,bottom: 15),
                    child: Center(
                      child: Text(
                        'Rechercher un Membre',
                        style: GoogleFonts.roboto(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 250,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded,color: Colors.white,),
                        labelText: 'Rechercher par matricule',
                        labelStyle: GoogleFonts.lato(color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      ),
                      style: GoogleFonts.lato(color: Colors.white,fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 8), // Espacement vertical
                  Container(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: _search,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellowAccent,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Rechercher', style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            Container(
              height: 300,
              child: Column(
                children: [
                  if (!_hasSearched)
                    Padding(
                    padding: EdgeInsets.only(left: 0),
                      child: Text(
                        'Veuillez effectuer une recherche.',
                        style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else if (results.isNotEmpty)
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverPersistentHeader(
                            delegate: _SliverAppBarDelegate(
                              minHeight: 50,
                              maxHeight: 50,
                              child: Container(
                                color: Colors.blueAccent,
                                child: Row(
                                  children: [
                                    Expanded(child: Center(child: Text('Matricule', style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.bold)))),
                                    Expanded(child: Center(child: Text('Nom', style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.bold)))),
                                    Expanded(child: Center(child: Text('Profession', style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.bold)))),
                                  ],
                                ),
                              ),
                            ),
                            pinned: true,
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                final result = results[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    color: index.isEven ? Colors.grey[100] : Colors.white,
                                    border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => _showDetailsDialog(context, result),
                                          child: Padding(
                                            padding: EdgeInsets.all(12),
                                            child: Text(result['matricule']!, style: GoogleFonts.lato()),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => _showDetailsDialog(context, result),
                                          child: Padding(
                                            padding: EdgeInsets.all(12),
                                            child: Text(result['nom']!, style: GoogleFonts.lato()),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => _showDetailsDialog(context, result),
                                          child: Padding(
                                            padding: EdgeInsets.all(12),
                                            child: Text(getProfessionTitle(result['profession_id']!) ?? 'Inconnu', style: GoogleFonts.lato()),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              childCount: results.length,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: Text(
                        'Ce membre n\'existe pas.',
                        style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            )





          ],
        ),
      ),
      floatingActionButton: _showFloatingActionButton
          ? FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.signUpScreenRoute);
          print("Floating Action Button Pressed");
        },
        backgroundColor: Colors.yellowAccent,
        child: Icon(Icons.add, color: Colors.black),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,// Position it at bottom right
    );
  }

}
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}


