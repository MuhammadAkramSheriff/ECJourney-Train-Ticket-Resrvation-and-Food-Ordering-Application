import 'dart:ui';
import 'package:flutter/material.dart';
import '../PassengerDetailsConfirmationScreen/PassengerDetailsConfirmationScreen.dart';

class popUpMessage {
  static Future<bool?> showConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            title: Text('Food Order'),
            content: Text('Do you wish to order some food?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // No, don't navigate
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Yes, navigate
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );
      },
    );
  }
}
