import 'package:canineappadmin/utils/Constantes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import '../../controllers/AuthentificationCtrl.dart';
import '../../utils/StockageKeys.dart';
import '../models/Profession.dart';
import '../models/user.dart';
import '../utils/Routes.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/numbers_widget.dart';
import '../widgets/profile_widget.dart';
import '../widgets/user_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GetStorage stockage = GetStorage();

  final List<ProfessionModel> professionList = [
    ProfessionModel(id: 1, title: "Vétérinaire"),
    ProfessionModel(id: 2, title: "Eleveur"),
    ProfessionModel(id: 3, title: "Dresseur"),
    ProfessionModel(id: 4, title: "Educateur"),
    ProfessionModel(id: 5, title: "Toiletteur"),
    ProfessionModel(id: 6, title: "Dealeur"),
    ProfessionModel(id: 7, title: "Cynophile"),
    ProfessionModel(id: 8, title: "Instructeur"),
  ];


  @override
  Widget build(BuildContext context) {

    final String baseUrl = Constantes.BASE_URL_IMAGE;
    final String? imageProfilPath =stockage.read(StockageKeys.userKey)['image_profil'];
    print("LIBOOOOOOOOOOOOOOOOOOOOOOOO++++++++++++++++++++++++++${imageProfilPath}");
    final String imageUrl = imageProfilPath != null ? "${baseUrl}storage/app/public/${imageProfilPath}" : "";
    print("-----------------OOOOOOOOOOOOOOOOOOOOOO++++++++++++++++++++++++++${imageUrl}");
    final user = UserPreferences.myUser;

    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imageUrl: imageUrl,
            onClicked: () {},
          ),
          const SizedBox(height: 24),
          buildName(user),
          const SizedBox(height: 20),
          buildMatriculeButton(),
          const Divider(), // Separator
          buildPersonalInfoButton(),
          const Divider(),
          buildProfessionButton(),
          const Divider(),
          buildGenreButton(),
          // const Divider(),
          // buildChangePasswordButton(),
          const Divider(),
          buildAddressButton(),
          const Divider(),
          buildPhoneButton(),
          const Divider(), // Separator
          buildLogoutButton(),
        ],
      ),
    );
  }

  Widget buildName(User user) =>
      Column(
        children: [
          Text(
            "${stockage.read(StockageKeys.userPreferenceKey)?['nom'] ?? 'Administrateur'} ${stockage.read(StockageKeys.userPreferenceKey)?['prenom'] ?? ''}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            "${stockage.read(StockageKeys.userKey)?['email'] ?? 'Email non spécifié'}",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      );

  Widget buildPersonalInfoButton() =>
      ListTile(
        title: Text(
            "User Name: ${stockage.read(StockageKeys.userKey)?['username'] ?? 'Nom d’utilisateur non spécifié'}"),
        leading: Icon(Icons.person),
        onTap: () {
          // Handle tap
        },
      );

  Widget buildMatriculeButton() =>
      ListTile(
        title: Text(
            "Matricule: ${stockage.read(StockageKeys.userPreferenceKey)?['matricule'] ?? 'Matricule non spécifié'}"),
        leading: Icon(Icons.badge),
        onTap: () {
          // Handle tap
        },
      );

  Widget buildAddressButton() =>
      ListTile(
        title: Text(
            "Adresse: ${stockage.read(StockageKeys.userPreferenceKey)?['adresse'] ?? 'Adresse non spécifiée'}"),
        leading: Icon(Icons.home),
        onTap: () {
          // Gérer l'action de tap
        },
      );

  Widget buildProfessionButton() {
    final professionId = stockage.read(StockageKeys.userPreferenceKey)?['profession_id'];

    final profession = professionList.firstWhere(
          (prof) => prof.id == professionId,
      orElse: () => ProfessionModel(id: 0, title: "Inconnu"),
    );

    return ListTile(
      title: Text("Profession: ${profession.title}"),
      leading: Icon(Icons.business_center),
      onTap: () {
        // Handle tap
      },
    );
  }

  Widget buildGenreButton() =>
      ListTile(
        title: Text(
            "Genre: ${stockage.read(StockageKeys.userPreferenceKey)?['genre'] ?? 'Genre non spécifié'}"),
        leading: Icon(Icons.transgender), // Updated icon for genre
        onTap: () {
          // Handle tap
        },
      );

  Widget buildPhoneButton() =>
      ListTile(
        title: Text(
            "Téléphone: ${stockage.read(StockageKeys.userPreferenceKey)?['telephone'] ?? 'Téléphone non spécifié'}"),
        leading: Icon(Icons.phone), // Updated icon for telephone
        onTap: () {
          // Handle tap
        },
      );

  Widget buildLogoutButton() =>
      ListTile(
        title: Text('Logout'),
        leading: Icon(Icons.logout, color: Colors.red),
        // Logout icon remains the same
        onTap: () {
          var auth = context.read<AuthentificationCtrl>();
          //auth.logout({});
          stockage.erase();
          Navigator.pushReplacementNamed(context, Routes.logInScreenRoute);
        },
      );

  Widget buildChangePasswordButton() {
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmNewPasswordController = TextEditingController();

    return ListTile(
      title: Text('Changer le mot de passe'),
      leading: Icon(Icons.lock_outline),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Changer le mot de passe'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: oldPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Ancien mot de passe',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Nouveau mot de passe',
                      prefixIcon: Icon(Icons.lock_open),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: confirmNewPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirmer le nouveau mot de passe',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validation et logique de changement de mot de passe

                  },
                  child: Text('Changer'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
