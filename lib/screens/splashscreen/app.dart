import 'package:canineappadmin/utils/Routes.dart';
import 'package:flutter/material.dart';
import 'package:canineappadmin/screens/splashscreen/app_data.dart';

class App extends StatefulWidget {
  const App({
    required this.data,
    super.key,
  });

  final AppData data;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    // Navigate to the next page after a short delay
    Future.delayed(Duration.zero, () {
      Navigator.pushNamed(context, Routes.logInScreenRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(), // Empty container as requested
        ),
      ),
    );
  }
}
