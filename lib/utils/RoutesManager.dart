import 'package:canineappadmin/screens/homePage.dart';
import 'package:canineappadmin/screens/login_screen.dart';
import 'package:canineappadmin/screens/mainNav.dart';
import 'package:canineappadmin/screens/profilePage.dart';
import 'package:canineappadmin/screens/register_screen.dart';
import 'package:canineappadmin/screens/splashScrenn.dart';
import 'package:canineappadmin/screens/splashscreen/app_loader.dart';
import 'package:flutter/material.dart';
import 'Routes.dart';

class RoutesManager {
  static Route route(RouteSettings r) {
    switch (r.name) {
        case Routes.logInScreenRoute:
      return MaterialPageRoute(builder: (_)=>LoginPage());
      case Routes.signUpScreenRoute:
        return MaterialPageRoute(builder: (_)=>RegisterPage());
      case Routes.splashscreenRoute:
        return MaterialPageRoute(builder: (_)=>SplashScreen());
      case Routes.loaderRoute:
        return MaterialPageRoute(builder: (_)=>AppLoader());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_)=>Homepage());
      case Routes.membreRoute:
        return MaterialPageRoute(builder: (_)=>Homepage());
      case Routes.profileRoute:
        return MaterialPageRoute(builder: (_)=>ProfilePage());
      case Routes.navRoute:
        return MaterialPageRoute(builder: (_)=>MainNav());
      default:
        return MaterialPageRoute(builder: (_) =>LoginPage());
    }
  }
}
