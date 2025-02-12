import 'dart:convert';
import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:canineappadmin/controllers/AuthentificationCtrl.dart';
import 'package:canineappadmin/models/Profession.dart';
import 'package:canineappadmin/utils/Constantes.dart';
import 'package:canineappadmin/utils/Endpoints.dart';
import 'package:canineappadmin/widgets/showMsg.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import '../components/app_text_form_field.dart';
import '../utils/common_widgets/gradient_background.dart';
import '../values/app_constants.dart';
import '../values/app_strings.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  static const List<String> _sexe = [
    'Masculin',
    'Féminin'
  ];
  int? professionId;
  File? _image;
  final picker = ImagePicker();


  late final TextEditingController nameController;
  late final TextEditingController postnomController;
  late final TextEditingController prenomController;
  late final TextEditingController adresseController;
  late final TextEditingController professionController;
  late final TextEditingController genreController;
  late final TextEditingController dateNaissanceontroller;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController specialiteController;
  late final TextEditingController structureController;

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  void initializeControllers() {
    nameController = TextEditingController()..addListener(controllerListener);
    postnomController = TextEditingController()..addListener(controllerListener);
    prenomController = TextEditingController()..addListener(controllerListener);
    adresseController = TextEditingController()..addListener(controllerListener);
    professionController = TextEditingController()..addListener(controllerListener);
    dateNaissanceontroller = TextEditingController()..addListener(controllerListener);
    phoneController = TextEditingController()..addListener(controllerListener);
    genreController = TextEditingController()..addListener(controllerListener);
    emailController = TextEditingController()..addListener(controllerListener);
    structureController=TextEditingController()..addListener(controllerListener);
    specialiteController=TextEditingController()..addListener(controllerListener);
    passwordController = TextEditingController()..addListener(controllerListener);
  }

  void disposeControllers() {
    nameController.dispose();
    postnomController.dispose();
    prenomController.dispose();
    adresseController.dispose();
    professionController.dispose();
    dateNaissanceontroller.dispose();
    emailController.dispose();
    phoneController.dispose();
    genreController.dispose();
    passwordController.dispose();
    structureController.dispose();
    specialiteController.dispose();
  }

  void controllerListener() {
    final name = nameController.text;
    final postnom = postnomController.text;
    final prenom= prenomController.text;
    final adresse= adresseController.text;
    final profession= professionController.text;
    final dateNaissance=professionController.text;
    final email=emailController.text;
    final phone=phoneController.text;
    final genre=genreController.text;
    final password = passwordController.text;
    final structure=structureController.text;
    final specialite=specialiteController.text;

    if (name.isEmpty && postnom.isEmpty && prenom.isEmpty && adresse.isEmpty &&
        password.isEmpty && profession.isEmpty &&
        genre.isEmpty && structure.isEmpty && specialite.isEmpty
    )
      return;

    bool allFieldsFilled = name.isNotEmpty &&
        postnom.isNotEmpty &&
        prenom.isNotEmpty && structure.isNotEmpty && specialite.isNotEmpty &&
        adresse.isNotEmpty  && genreController.text.isNotEmpty;

    bool isNameValid = name.length >= 4;
    bool isPostnomValid = postnom.length >= 2;
    bool isPrenomValid = prenom.length >= 2;
    bool isEmailValid = AppConstants.emailRegex.hasMatch(email);
    bool isPhoneValid = phone.length <= 14;
    bool isAdresseValid = adresse.length >= 2;
    bool isPasswordValid = AppConstants.passwordRegex.hasMatch(password);

    fieldValidNotifier.value =
       allFieldsFilled && isNameValid && isPrenomValid &&
        isAdresseValid && isPostnomValid && isPasswordValid;

  }

  Future<void> selectImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        print('Image sélectionnée : ${_image!.path}');
        showMsg(context, true, "Image sélectionnée avec succès");
      } else {
        showMsg(context, false, "Aucune image sélectionnée");
      }
    } catch (e) {
      print('Erreur lors de la sélection de l\'image : $e');
      showMsg(context, false, "Erreur lors de la sélection de l'image");
    }
  }

  Future<void> uploadFile() async {
    if (_image == null) {
      showMsg(context, false, "Veuillez sélectionner une image");
      return;
    }

    // Vérification du type MIME
    final mimeType = lookupMimeType(_image!.path);
    if (mimeType == null || !mimeType.startsWith('image/')) {
      showMsg(context, false, "Le fichier doit être une image (jpeg, png, jpg");
      return;
    }

    // Lire l'image et la convertir en base64
    final bytes = File(_image!.path).readAsBytesSync();
    String base64Image = base64Encode(bytes);
    print("makaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa${base64Image}");

    // Création de la requête multipart
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("${Constantes.BASE_URL}${Endpoints.signUpEndpoint}"),
    );

    // Ajouter les autres champs utilisateur, y compris l'image encodée
    Map<String, dynamic> userData = {
      "nom": nameController.text,
      "prenom": prenomController.text,
      "postnom": postnomController.text,
      "telephone": phoneController.text.isNotEmpty ? phoneController.text:"+243-----",
      "adresse": adresseController.text,
      "password": passwordController.text,
      "genre": genreController.text,
      "email": emailController.text.isNotEmpty ? emailController.text : "@", // Envoyer "" si email est vide
      "date_naissance": dateNaissanceontroller.text.isNotEmpty ? dateNaissanceontroller.text : "1900-01-01",
      "structure": structureController.text,
      "specialite": specialiteController.text,
      "user_type_id": "2",
      "profession_id": professionId.toString(),
      "image": base64Image,
    };


    // Ajouter les données utilisateur à la requête
    userData.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    print("***********************---------------------------------${userData}");
    print("***********************---------------------------------${request.fields}");

    try {
      // Envoi de la requête
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Fichier envoyé avec succès !');
        showMsg(context, true, "Enregistrement réussi");
        Navigator.pop(context);
      } else {
        print('Erreur lors de l\'envoi : ${response.statusCode}');
        print(await response.stream.bytesToString());
        showMsg(context, false, "Erreur lors de l'enregistrement.");
      }
    } catch (e) {
      print('Erreur lors de l\'envoi : $e');
      showMsg(context, false, "Une erreur s'est produite. Veuillez réessayer.");
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      showMsg(context, false, "Veuillez remplir tous les champs obligatoires.");
      return;
    }

    if (_image == null) {
      showMsg(context, false, "Veuillez sélectionner une image.");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const Center(child: CircularProgressIndicator()),
    );

    await uploadFile();

    Navigator.of(context).pop(); // Fermer le dialogue après soumission
  }


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
  int _currentStep=0;

  @override
  void initState() {
    initializeControllers();
    super.initState();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }


  List<dynamic> results = [];
  Future<void> _searchAllUsersViaAPI() async {
    var ctrl = context.read<AuthentificationCtrl>();
    var res = await ctrl.getListUsers();

    if (res.status == true) {
      results = res.data;
      print("MATAMAAAEE");
    } else {
      print("Erreur lors de la recherche : ${res.errorMsg}");
      showMsg(context, false, "${res.errorMsg}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GradientBackground(
            children: [
              Center(
                child: Text(
                  AppStrings.registerApp,
                  style: GoogleFonts.roboto(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(AppStrings.appName,  style: GoogleFonts.roboto(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ), ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _currentStep == 0
                  ? "Étape 1 : Informations Personnelles"
                  : _currentStep == 1
                  ? "Étape 2 : Informations de Contact"
                  : "Étape 3 : Création du Compte",
              style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),

          // Form steps with animations
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 5000),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0.1, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: SingleChildScrollView(child: _buildStep()),
            ),
          ),

          // Navigation Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  ElevatedButton(
                    onPressed: _previousStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text("Retour"),
                  ),
                if (_currentStep < 2)
                  ElevatedButton(
                    onPressed: _currentStep == 2 ? _submitForm : _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                    ),
                    child: const Text("Suivant"),
                  ),
              ],

            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0:
        return _buildStepOne();
      case 1:
        return _buildStepTwo();
      case 2:
        return _buildStepThree();
      default:
        return Container();
    }
  }

  Widget _buildStepOne() {
    return Padding(
      key: ValueKey(0),
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            AppTextFormField(
              autofocus: true,
              labelText: AppStrings.name,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              onChanged: (value) => _formKey.currentState?.validate(),
              validator: (value) {
                return value!.isEmpty
                    ? AppStrings.pleaseEnterName
                    : value.length < 4
                    ? AppStrings.invalidName
                    : null;
              },
              controller: nameController,
            ),
            AppTextFormField(
              labelText: AppStrings.postnom,
              controller: postnomController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              onChanged: (_) => _formKey.currentState?.validate(),
              validator: (value) {
                return value!.length < 2
                    ? AppStrings.invalidPostnom
                    : null;
              },
            ),
            AppTextFormField(
              labelText: AppStrings.prenom,
              controller: prenomController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              onChanged: (_) => _formKey.currentState?.validate(),
              validator: (value) {
                return value!.isEmpty
                    ? AppStrings.pleaseEnterPrenom
                    : value.length < 2
                    ? AppStrings.invalidPrenom
                    : null;
              },
            ),
            AppTextFormField(
              labelText: AppStrings.email,
              controller: emailController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              onChanged: (_) => _formKey.currentState?.validate(),
              validator:  null,
            ),
            GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Sélectionner une source",style: TextStyle(fontSize: 20),),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.image),
                              title: Text("Galerie"),
                              onTap: ()  {
                                 selectImage(ImageSource.gallery);
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text("Appareil photo"),
                              onTap: ()  {
                                 selectImage(ImageSource.camera);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt),
                        Text("Choisir une photo de profil")
                      ],
                    )
                )
            ),
            SizedBox(height: 10,),
            if(_image!=null)
              Stack(
                children: [
                  Center(
                    child: SizedBox(
                      height: 100,
                      width: 300,
                      child: Image.file(_image!, fit: BoxFit.cover,),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _image = null;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, color: Colors.white, size: 15),
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 15,),
          ],
        ),
      ),
    );
  }

  Widget _buildStepTwo() {
    return Padding(
      key: ValueKey(1),
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextFormField(
              labelText: AppStrings.phone,
              controller: phoneController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
              onChanged: (_) => _formKey.currentState?.validate(),
              validator: null
            ),
            TextFormField(
              controller: dateNaissanceontroller,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        locale: const Locale('fr', 'FR')
                    );
                    if (pickedDate != null) {
                      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                      dateNaissanceontroller.text = formattedDate;
                    }
                  },
                ),
                labelText: "Date de naissance",
                contentPadding: const EdgeInsets.symmetric(vertical: 17),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onTap: () => _selectDate(context),
              readOnly: true,
            ),
            SizedBox(height: 20,),
            AppTextFormField(
              labelText: AppStrings.adresse,
              controller: adresseController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              onChanged: (_) => _formKey.currentState?.validate(),
              validator: (value) {
                return value!.isEmpty
                    ? AppStrings.pleaseEnterAdresse
                    : value.length < 2
                    ? AppStrings.invalidAdresse
                    : null;
              },
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.grey,
                  width: 2.0,
                ),

              ),
              child: CustomDropdown<String>(
                hintText: 'Genre',
                items: _sexe,
                decoration: CustomDropdownDecoration(
                  expandedBorder: Border.all(
                    color: Colors.grey,
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    genreController.text = value;
                    print('changing value to: $value');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepThree() {
    return Padding(
      key: ValueKey(2),
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextFormField(
              autofocus: true,
              labelText: "Structure",
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              onChanged: (value) => _formKey.currentState?.validate(),
              validator: (value) {
                return value!.isEmpty
                    ? "Entrer votre structure"
                    : value.length < 1
                    ? "Structure invalid"
                    : null;
              },
              controller: structureController,
            ),
            AppTextFormField(
              autofocus: true,
              labelText: "Specialité",
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              onChanged: (value) => _formKey.currentState?.validate(),
              validator: (value) {
                return value!.isEmpty
                    ? "Entrer votre specialité"
                    : value.length < 1
                    ? "Structure invalid"
                    : null;
              },
              controller: specialiteController,
            ),
            Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.5),
                  //     spreadRadius: 2,
                  //     blurRadius: 2,
                  //     offset: Offset(0, 3),
                  //   ),
                  // ],
                ),
                child: CustomDropdown<ProfessionModel>(
                  hintText: 'Profession',
                  items: professionList,
                  decoration: CustomDropdownDecoration(
                    expandedBorder: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  onChanged: (selectedProfession) {
                    if (selectedProfession != null) {
                      professionId=selectedProfession.id;
                      print('ID de la profession sélectionnée : ${professionId}');
                      print('Titre de la profession : ${selectedProfession.title}');
                    }
                  },
                )
            ),
            SizedBox(height: 20,),
            ValueListenableBuilder<bool>(
              valueListenable: passwordNotifier,
              builder: (_, passwordObscure, __) {
                return AppTextFormField(
                  obscureText: passwordObscure,
                  controller: passwordController,
                  labelText: AppStrings.password,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (_) => _formKey.currentState?.validate(),
                  validator: (value) {
                    return value!.isEmpty
                        ? AppStrings.pleaseEnterPassword
                        : AppConstants.passwordRegex.hasMatch(value)
                        ? null
                        : AppStrings.invalidPassword;
                  },
                  suffixIcon: Focus(
                    /// If false,
                    ///
                    /// disable focus for all of this node's descendants
                    descendantsAreFocusable: false,

                    /// If false,
                    ///
                    /// make this widget's descendants un-traversable.
                    // descendantsAreTraversable: false,
                    child: IconButton(
                      onPressed: () =>
                      passwordNotifier.value = !passwordObscure,
                      style: IconButton.styleFrom(
                        minimumSize: const Size.square(48),
                      ),
                      icon: Icon(
                        passwordObscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: fieldValidNotifier,
              builder: (_, isValid, __) {
                return FilledButton(
                  onPressed: isValid
                      ? () {
                    _submitForm();
                    passwordController.clear();
                    print("voici pesaaaaaaaaaaaa ${fieldValidNotifier.value}");

                  }
                      : null,
                  child: Text("Enregistrer"),
                );
              },
            ),

          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      // Format the date to display in the TextFormField
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      dateNaissanceontroller.text = formattedDate;
    }
  }
}
