import 'package:canineappadmin/utils/common_widgets/gradient_background.dart';
import 'package:canineappadmin/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/Profession.dart';
import '../utils/StockageKeys.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  GetStorage stockage = GetStorage();
  List<dynamic> results=[];
  final List<ProfessionModel> professionList = [
    ProfessionModel(id: 1, title: "Vétérinaire"),
    ProfessionModel(id: 2, title: "Eleveur"),
    ProfessionModel(id: 3, title: "Dresseur"),
    ProfessionModel(id: 4, title: "Educateur"),
    ProfessionModel(id: 5, title: "Toiletteur"),
    ProfessionModel(id: 6, title: "Dealeur"),
    ProfessionModel(id: 7, title: "Cynophile"),
  ];


   int totalUsers = 0;
   int veterinarians = 0;
   int breeders = 0;
   int trainers = 0;
   int educators = 0;
   int dealers = 0;
   int groomers = 0;
   int cynophiles = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserStatistics();
  }


  void _fetchUserStatistics() async {
    var localListUsers = await stockage.read(StockageKeys.allUsers);
    if (localListUsers != null) {
      List<dynamic> personnels = localListUsers['personnels'] as List;
      totalUsers = personnels.length; // Total users
      print("NOELLLLLLLLLLLLLLLLLLLL${totalUsers}");

      for (var user in personnels) {
        var professionId = user['profession_id'];
        switch (professionId) {
          case 1:
            veterinarians++;
            break;
          case 2:
            breeders++;
            break;
          case 3:
            trainers++;
            break;
          case 4:
            educators++;
            break;
          case 5:
            dealers++;
            break;
          case 6:
            groomers++;
            break;
          case 7:
            cynophiles++;
            break;
        }
      }

      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          GradientBackground(
            children: [
              Center(
                child: Text(
                  AppStrings.home,
                  style: GoogleFonts.roboto(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(AppStrings.appName, style: GoogleFonts.roboto(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                )),
              ),
              const SizedBox(height: 50),
              // Statistics Section
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Statistiques d'acyco",
                    style: GoogleFonts.lato(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 16.0, // Horizontal space between cards
                  runSpacing: 16.0, // Vertical space between rows
                  children: [
                    _buildStatisticCard('Utilisateurs', totalUsers.toString()),
                    _buildStatisticCard('Vétérinaires', veterinarians.toString()),
                    _buildStatisticCard('Eleveurs', breeders.toString()),
                    _buildStatisticCard('Dresseurs', trainers.toString()),
                    _buildStatisticCard('Educateurs', educators.toString()),
                    _buildStatisticCard('Dealeur', dealers.toString()),
                    _buildStatisticCard('Toiletteurs', groomers.toString()),
                    _buildStatisticCard('Cynophile', cynophiles.toString()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticCard(String title, String value) {
    return Container(
      width: (MediaQuery.of(context).size.width - 50) / 2,
      child: Card(
        color: Colors.white.withOpacity(0.8),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: GoogleFonts.lato(fontSize: 16)),
              Text(value, style: GoogleFonts.lato(fontSize: 17)),
            ],
          ),
        ),
      ),
    );
  }
}
