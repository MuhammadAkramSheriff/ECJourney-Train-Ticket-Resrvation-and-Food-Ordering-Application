import 'package:flutter/material.dart';
//import 'package:toast/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';


/*alertDialog(BuildContext context, String msg) {
  Toast.show(msg, context, duration: Toast.lengthLong, gravity: Toast.bottom);
}*/
void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
  );
}

void showToastError(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 0,
    backgroundColor: Colors.red,
    textColor: Colors.white,
  );
}

void showToastWeb(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 3,
    backgroundColor: Colors.transparent,
    textColor: Colors.white,
  );
}

validateEmail(String email) {
  final emailReg = new RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  return emailReg.hasMatch(email);
}
/*import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

alertDialog(BuildContext context, String msg) {
  //Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  Toast.show("Toast plugin app", duration: Toast.lengthShort, gravity:  Toast.bottom);
}

validateEmail(String email) {
  final emailReg = new RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  return emailReg.hasMatch(email);
}*/