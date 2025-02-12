import 'package:canineappadmin/controllers/SearchController.dart';
import 'package:canineappadmin/utils/helpers/snackbar_helper.dart';
import 'package:canineappadmin/values/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/AuthentificationCtrl.dart';
import 'package:provider/provider.dart';
import '../utils/Routes.dart';
import '../utils/RoutesManager.dart';
import '../utils/StockageKeys.dart';

class MonApplication extends StatelessWidget {
  var _stockage = GetStorage();

  @override
  Widget build(BuildContext context) {
    bool isFirstLaunch = _stockage.read(StockageKeys.firstLaunchKey) ?? true;
    var token = _stockage.read(StockageKeys.tokenKey);

    if (isFirstLaunch) {
      _stockage.write(StockageKeys.firstLaunchKey, false);
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthentificationCtrl(stockage: _stockage)),
        ChangeNotifierProvider(create: (_) => RechercheController(stockage: _stockage)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeData,
        onGenerateRoute: RoutesManager.route,
        themeMode: ThemeMode.light,
        scaffoldMessengerKey: SnackbarHelper.key,
        initialRoute: _determineInitialRoute(token)
      ),
    );
  }
  String _determineInitialRoute(String? token) {
    if (token != null && token.isNotEmpty) {
      return Routes.navRoute;
    } else {
      return Routes.logInScreenRoute;
    }
  }
}