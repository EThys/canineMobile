import 'package:flutter/material.dart';


void showMsg(BuildContext context, bool success, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 0,
      content: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(right: 5,left: 5,top: 10),
            height: 50,
            decoration: BoxDecoration(
              color: success ? Colors.green : Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              children: [
                Icon(
                  success ? Icons.check_circle_outline : Icons.error_outline_outlined,
                  size: 40,
                  color: Colors.white,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      message,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.fixed,
      backgroundColor: Colors.transparent,
    ),
  );
}