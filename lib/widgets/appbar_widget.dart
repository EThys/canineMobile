import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/Routes.dart';

AppBar buildAppBar(BuildContext context) {
  final icon = CupertinoIcons.moon_stars;

  return AppBar(
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pushNamed(context, Routes.navRoute);
      },
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        icon: Icon(icon),
        onPressed: () {

        },
      ),
    ],
  );
}
