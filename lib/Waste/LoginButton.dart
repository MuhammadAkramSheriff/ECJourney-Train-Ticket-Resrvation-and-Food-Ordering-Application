import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Common/Helper.dart';
import '../SearchTrainScreen/SearchTrain.dart';
import 'UserModel.dart';
import 'db.dart';
import 'LoginInputField.dart';

/*class LoginButton extends StatefulWidget {
  //const LoginButton({Key key}) : super(key: key);

  @override
  //_LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginButton>{
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _formKey = new GlobalKey<FormState>();

  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

  login() async {
    String uemail = conUserEmail.text;
    String passwd = conPassword.text;

    if (uemail.isEmpty) {
      //alertDialog(context, "Please Enter User Email");
      print("email empty");
    } else if (passwd.isEmpty) {
      //alertDialog(context, "Please Enter Password");
      print("pass empty");
    } else {
      await dbHelper.getLoginUser(uemail, passwd).then((userData) {
        if (userData != null) {
          setSP(userData).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => HomeForm()),
                    (Route<dynamic> route) => false);
          });
        } else {
          //alertDialog(context, "Error: User Not Found");
          print("failed");
        }
      }).catchError((error) {
        print(error);
        alertDialog(context, "Error: Login Fail");
      });
    }
  }

  Future setSP(UserModel user) async {
    final SharedPreferences sp = await _pref;

    //sp.setString("user_id", user.user_id);
    sp.setString("user_name", user.user_name);
    sp.setString("email", user.email);
    sp.setString("password", user.password);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        color: Colors.cyan[500],
        borderRadius: BorderRadius.circular(10),
      ),
      /*child: Center(
        child: Text("Login",style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold
        ),),
      ),*/

      child: Center(
        child: ElevatedButton(
          onPressed: login,
          child: Text(
            "Login",
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.cyan[500],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
          )
        ),
      ),
    );
  }
}*/