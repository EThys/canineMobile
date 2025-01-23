import 'package:canineappadmin/controllers/AuthentificationCtrl.dart';
import 'package:canineappadmin/utils/Routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:canineappadmin/utils/helpers/snackbar_helper.dart';
import 'package:canineappadmin/values/app_regex.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../components/app_text_form_field.dart';
import '../resources/resources.dart';
import '../utils/common_widgets/gradient_background.dart';
import '../utils/helpers/navigation_helper.dart';
import '../values/app_constants.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? msg;

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController userNameController;
  late final TextEditingController passwordController;

  void initializeControllers() {
    userNameController = TextEditingController()..addListener(controllerListener);
    passwordController = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    userNameController.dispose();
    passwordController.dispose();
  }

  void controllerListener() {
    final userName = userNameController.text;
    final password = passwordController.text;

    if (userName.isEmpty && password.isEmpty) return;

    if (AppRegex.passwordRegex.hasMatch(password)) {
      fieldValidNotifier.value = true;
    } else {
      fieldValidNotifier.value = false;
    }
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    // if (formKey.currentState?.validate() ?? false) {
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
      "username": userNameController.text,
      "password": passwordController.text,
    };
    var ctrl = context.read<AuthentificationCtrl>();
    print("Voici les donnees $userData");
    var res = await ctrl.login(userData);
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
            backgroundColor: Colors.yellow,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.thumb_up, color: Colors.white, size: 60),
                SizedBox(height: 20),
                Text(
                  "Connexion réussie !",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          );
        },
      );

      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
        Navigator.pushReplacementNamed(context, Routes.navRoute);
      });
    } else {
      SnackbarHelper.showSnackBar(res.data?['message'],isError: true);

    }
  }


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
        padding: EdgeInsets.zero,
        children: [
          GradientBackground(
            children: [
              Center(
                child: Text(
                  AppStrings.signInToYourNAccount,
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
          SizedBox(height: 20,),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppTextFormField(
                    controller: userNameController,
                    labelText: AppStrings.userName,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => _formKey.currentState?.validate(),
                    validator: (value) {
                      return value!.isEmpty
                          ? AppStrings.pleaseEmterUserName
                          : null;
                    },
                  ),
                  SizedBox(height: 7,),
                  ValueListenableBuilder(
                    valueListenable: passwordNotifier,
                    builder: (_, passwordObscure, __) {
                      return AppTextFormField(
                        obscureText: passwordObscure,
                        controller: passwordController,
                        labelText: AppStrings.password,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (_) => _formKey.currentState?.validate(),
                        validator: (value) {
                          return value!.isEmpty
                              ? AppStrings.pleaseEnterPassword
                              : AppConstants.passwordRegex.hasMatch(value)
                              ? null
                              : AppStrings.invalidPassword;
                        },
                        suffixIcon: IconButton(
                          onPressed: () =>
                          passwordNotifier.value = !passwordObscure,
                          style: IconButton.styleFrom(
                            minimumSize: const Size.square(48),
                          ),
                          icon: Icon(
                            passwordObscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(AppStrings.forgotPassword,style:TextStyle(  color: Colors.black,)
                    ),),
                  const SizedBox(height: 20),
                  ValueListenableBuilder(
                    valueListenable: fieldValidNotifier,
                    builder: (_, isValid, __) {
                      return FilledButton(
                        onPressed: isValid
                            ? () {
                          _submitForm();

                          passwordController.clear();
                        }
                            : null,
                        child: const Text(AppStrings.login),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       AppStrings.doNotHaveAnAccount,
          //       style: AppTheme.bodySmall.copyWith(color: Colors.black),
          //     ),
          //     const SizedBox(width: 4),
          //     TextButton(
          //       onPressed: () => Navigator.pushNamed(context,Routes.signUpScreenRoute),
          //       child: const Text(AppStrings.register),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}