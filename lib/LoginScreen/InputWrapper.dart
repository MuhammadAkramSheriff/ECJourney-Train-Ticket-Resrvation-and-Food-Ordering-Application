import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Common/Helper.dart';
import '../Waste/LocalDatabase.dart';
import '../Models/UserModel/UserDetailsModel.dart';
import '../SearchTrainScreen/SearchTrain.dart';
import 'package:ecjourney/SingUpScreen/RegistrationPage.dart';

import '../firebase_auth_services.dart';

class InputWrapper extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<InputWrapper>{
  //Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _formKey = new GlobalKey<FormState>();

  final FirebaseAuthService _auth = FirebaseAuthService();

  final _conUserEmail = TextEditingController();
  final _conPassword = TextEditingController();
  //var dbHelper;

  @override
  void dispose() {
    _conUserEmail.dispose();
    _conPassword.dispose();
    super.dispose();
    //dbHelper = DbHelper();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   //dbHelper = DbHelper();
  // }

  //Method to perfrom Sign-in
  login() async {
    String email = _conUserEmail.text;
    String password = _conPassword.text;

    if (email.isEmpty) {
      showToast('Please Enter Email');
    } else if (password.isEmpty) {
      showToast('Please Enter Password');
    } else {
      //Authenticate user entered email and password
      User? userFromFirebase =
          await _auth.signInWithEmailAndPassword(email, password);

      //If user authentication is valid, get the user details
      // from the database and save it in the user model
      if (userFromFirebase != null) {
        UserDetailsModel? userdetails = await _auth.getUserDetails(email);
        if (userdetails != null) {
          // UserDetailsModel userDetailsModel = UserDetailsModel(
          //   firstName: userdetails!.firstName,
          //   lastName: userdetails.lastName,
          //   Email: userdetails.Email,
          //   mobileNum: userdetails.mobileNum,
          //   NICNo: userdetails.NICNo,
          //   passportNo: userdetails.passportNo,
          // );
          print('user modes ${userdetails.firstName}');

          //await insertUser(userdetails);

          //UserDetailsModel? userFromLocalDatabase = await getUserByEmail(email);

          //if (userFromLocalDatabase != null) {
          //Store the user details in the shared preference
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('FirstName', userdetails.firstName);
          prefs.setString('LastName', userdetails.lastName);
          prefs.setString('EmailAddress', userdetails.Email);
          prefs.setString('MobileNumber', userdetails.mobileNum);
          prefs.setString('NICNumber', userdetails.NICNo ?? '');
          prefs.setString('PassportNumber', userdetails.passportNo ?? '');

          //   print('User found: ${userFromLocalDatabase.firstName} ${userFromLocalDatabase.lastName}');
          // } else {
          //   // User was not found
          //   print('User not found');
          // }
        } else {
          print("User details not found");
        }

        print("User is successfully signedIn");
        await _auth.getUserReservationStatus(email);
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => SearchTrain()));

        // getUserByEmail(email).then((user) {
        //   print('Users $user');
        // }).catchError((error) {
        //   print('Error: $error');
        // });
      } else {
        print("Some error happend");
      }

      // await DbHelper.instance.getLoginUser(uemail, upasswd).then((userData) {
      //   if (userData != null) {
      //     setSP(userData).whenComplete(() {
      //       Navigator.pushAndRemoveUntil(
      //           context,
      //           MaterialPageRoute(builder: (_) => SearchTrain()),
      //               (Route<dynamic> route) => false);
      //     });
      //   } else {
      //     showToast('User not found');
      //   }
      // }).catchError((error) {
      //   print(error);
      //   showToast('Login Fail');
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            TextFormField(    //TextFormField for email address
                controller: _conUserEmail,
                style: TextStyle(
                    color: Colors.black87
                ),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(
                        Icons.person,
                        color: Color(0xff5ac18e)
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(
                        color: Colors.black38
                    )
                ),
              ),
            SizedBox(height: 20.0),
            TextFormField(    //TextFormField for password
                controller: _conPassword,
                obscureText: true,
                style: TextStyle(
                    color: Colors.black87
                ),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(
                        Icons.lock,
                        color: Color(0xff5ac18e)
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                        color: Colors.black38
                    )
                ),
              ),
            SizedBox(height: 20.0),
            TextButton(
              onPressed: login,//when user press Log in butten, login method will be called
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan[500],
                minimumSize: Size(MediaQuery.of(context).size.width, 50),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              child: Text(
                "Log in",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            /*ElevatedButton(
                onPressed: DbHelper.instance.deleteUser,
                child: Text(
                  "delete",
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
            ElevatedButton(
                onPressed: () async{
                  List<Map<String,dynamic>> queryRows = await DbHelper.instance.queryAll();
                  print(queryRows);
                },
                child: Text(
                  "search",
                  style: TextStyle(
                      color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.cyan[500],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                )
            ),*/
            SizedBox(height: 20.0),
            Text(
              "Forgot Password?",
              style: TextStyle(color: Colors.grey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account"),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupForm()));
                    },
                    child: Text("Sign-up?", style: TextStyle(color: Colors.cyan[700])))
              ],
            )
          ],
        ),
      ),
      ),
    );
  }
}
