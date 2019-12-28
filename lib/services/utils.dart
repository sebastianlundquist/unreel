import 'package:flutter/material.dart';

class Utils {
  static void showSnackBar(String text, BuildContext context) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context)
        .showSnackBar(
          SnackBar(
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.amber,
              onPressed: () {
                Scaffold.of(context).hideCurrentSnackBar();
              },
            ),
            backgroundColor: Color(0xFF1D2733),
            content: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
        .closed
        .then((SnackBarClosedReason reason) {});
  }
}
