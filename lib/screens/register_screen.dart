import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:canineappadmin/controllers/AuthentificationCtrl.dart';
import 'package:canineappadmin/models/Profession.dart';
import 'package:canineappadmin/routes.dart';
import 'package:canineappadmin/utils/Routes.dart';
import 'package:flutter/material.dart';
import 'package:canineappadmin/utils/helpers/snackbar_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../components/app_text_form_field.dart';
import '../utils/common_widgets/gradient_background.dart';
import '../utils/helpers/navigation_helper.dart';
import '../values/app_constants.dart';
import '../values/app_regex.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';

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
    passwordController = TextEditingController()
      ..addListener(controllerListener);
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

    if (name.isEmpty && postnom.isEmpty && prenom.isEmpty && adresse.isEmpty &&
        password.isEmpty && profession.isEmpty && dateNaissance.isEmpty && phone.isEmpty &&
        genre.isEmpty && email.isEmpty
    )
      return;

    bool allFieldsFilled = name.isNotEmpty &&
        postnom.isNotEmpty &&
        prenom.isNotEmpty &&
        adresse.isNotEmpty && dateNaissanceontroller.text.isNotEmpty && genreController.text.isNotEmpty;

    bool isNameValid = name.length >= 4;
    bool isPostnomValid = postnom.length >= 2;
    bool isPrenomValid = prenom.length >= 2;
    bool isEmailValid = AppConstants.emailRegex.hasMatch(email);
    bool isPhoneValid = phone.length <= 14;
    bool isAdresseValid = adresse.length >= 2;
    bool isPasswordValid = AppConstants.passwordRegex.hasMatch(password);

    fieldValidNotifier.value =
        isEmailValid && allFieldsFilled &&
        isPhoneValid && isNameValid && isPrenomValid &&
        isAdresseValid && isPostnomValid &&
        isPasswordValid;

  }

  Future<void> _submitForm() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    // if (!formKey.currentState!.validate()) {
    //   return;
    // }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    Map<String, dynamic> userData = {
      "nom":nameController.text,
      "prenom": prenomController.text,
      "postnom": postnomController.text,
      "telephone": phoneController.text,
      "adresse":adresseController.text,
      "password": passwordController.text,
      "genre":genreController.text,
      "email":emailController.text,
      "date_naissance": dateNaissanceontroller.text,
      "user_type_id": 2,
      "profession_id":professionId

    };
    var ctrl = context.read<AuthentificationCtrl>();
    print("Voici les donnees $userData");
    var res = await ctrl.register(userData);
    await Future.delayed(Duration(seconds: 2));

    Navigator.of(context).pop();

    print("MAMADOUUUUU ${res.status}");
    print("MAMADOUUUUU ${res.status.runtimeType}");

    if (res.status == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blue,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.thumb_up, color: Colors.white, size: 60),
                SizedBox(height: 20),
                Text(
                  "Enregistrement réussi !",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          );
        },
      );

      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, Routes.navRoute );
      });
    } else {
      passwordController.clear();

      setState(() {

      });


    }
  }

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
    initializeControllers();
    super.initState();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
              const SizedBox(height: 30),
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
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
                      return value!.isEmpty
                          ? AppStrings.pleaseEnterPostnom
                          : value.length < 2
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
                    validator: (value) {
                      return value!.isEmpty
                          ? AppStrings.pleaseEnterEmailAddress
                          : AppConstants.emailRegex.hasMatch(value)
                          ? null
                          : AppStrings.invalidEmailAddress;
                    },
                  ),
                  TextFormField(
                    controller: dateNaissanceontroller,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
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
                  AppTextFormField(
                    labelText: AppStrings.phone,
                    controller: phoneController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    onChanged: (_) => _formKey.currentState?.validate(),
                    validator: (value) {
                      return value!.isEmpty
                          ? AppStrings.pleaseEnterPhone
                          : value.length >14
                          ? AppStrings.invalidPhone
                          : null;
                    },
                  ),
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
                                 nameController.clear();
                                 postnomController.clear();
                                 prenomController.clear();
                                 adresseController.clear();
                                 professionController.clear();
                                 dateNaissanceontroller.clear();
                                 phoneController.clear();
                                 genreController.clear();
                                 emailController.clear();
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
          ),
        ],
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
