import 'package:canineappadmin/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:canineappadmin/controllers/AuthentificationCtrl.dart';
import 'package:canineappadmin/utils/Routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override

  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var ctrl = context.read<AuthentificationCtrl>();
      Future.delayed(Duration(seconds: 4), () {
        var _tkn = ctrl.token;
        print("Token trouvé : $_tkn");

        if (_tkn.isNotEmpty) {
          Navigator.pushReplacementNamed(context, Routes.navRoute);
        } else {
          Navigator.pushReplacementNamed(context, Routes.logInScreenRoute);
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFF72F3F8),
      body:SizedBox(
        width: double.infinity,
        child: Container(
          margin: EdgeInsets.only(top:250),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius:  BorderRadius.circular(15.0),
                  child: Image.asset(
                    Vectors.asyco,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                "ASYCO",
                style: GoogleFonts.lato(
                  color:Colors.yellow, fontWeight: FontWeight.bold,fontSize: 25,
              ),),

            ],
          ),
        ),

      ),

    );
  }
}
