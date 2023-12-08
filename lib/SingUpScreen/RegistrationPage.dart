import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecjourney/Common/Helper.dart';
import 'package:ecjourney/Common/textfield.dart';
import '../Waste/ToggleButton.dart';
import '../LoginScreen/LoginPage.dart';
import '../firebase_auth_services.dart';

class SignupForm extends StatefulWidget {

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = new GlobalKey<FormState>();

  final FirebaseAuthService _auth = FirebaseAuthService();
  final firestore = FirebaseFirestore.instance.collection('Users');

  final _conUserFname = TextEditingController();
  final _conUserLname = TextEditingController();
  final _conEmail = TextEditingController();
  final _conMobileNum = TextEditingController();
  final _conNICorPassport = TextEditingController();
  final _conPassword = TextEditingController();
  final _conCPassword = TextEditingController();

  bool _toggleValue = false;

  @override
  void dispose() {
    _conUserFname.dispose();
    _conUserLname.dispose();
    _conEmail.dispose();
    _conMobileNum.dispose();
    _conNICorPassport.dispose();
    _conPassword.dispose();
    _conCPassword.dispose();
    super.dispose();
  }

  // Method for signUp
  signUp() async {
    String fname = _conUserFname.text;
    String lname = _conUserLname.text;
    String email = _conEmail.text;
    String mobileno = _conMobileNum.text;
    String? nicno;
    String? passportno;
    String password = _conPassword.text;
    String cpassword = _conCPassword.text;

    //To find if the user has selected NIC or Passport from the ToggleButton
    if (_toggleValue){
      passportno = _conNICorPassport.text;
    }else{
      nicno = _conNICorPassport.text;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      //To check if the user entered password match with the confirm password
      if (password != cpassword) {
        showToast('Password Mismatch');

      } else {
        _formKey.currentState?.save();
        //Authentical user entered email and password
        User? user = await _auth.signUpWithEmailAndPassword(email, password);

          if (user != null) {
            //Save user information into the database
            firestore.doc(email).set({
              'First Name' : fname,
              'Last Name' : lname,
              'Email Address' : email,
              'Mobile Number' : mobileno,
              'NIC NO' : nicno,
              'Passport Number' : passportno,

            }).then((value){
              showToast('Successfully Registered');
            }).onError((error, stackTrace){
              showToast('Registering User Details Failed');
              print((error, stackTrace));
            });

            //showToast('Successfully Registered');
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => LoginPage()));
          }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.cyan[700],
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Center(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getTextFormField(   //TextFormField for firstname
                        controller: _conUserFname,
                        icon: Icons.person_outlined,
                        inputType: TextInputType.name,
                        hintName: 'First Name'),
                    SizedBox(height: 10.0),
                    getTextFormField(   //TextFormField for last name
                        controller: _conUserLname,
                        icon: Icons.person_outline,
                        inputType: TextInputType.name,
                        hintName: 'Last Name'),
                    SizedBox(height: 10.0),
                    getTextFormField(   //TextFormField for email
                        controller: _conEmail,
                        icon: Icons.email_outlined,
                        inputType: TextInputType.emailAddress,
                        hintName: 'Email'),
                    SizedBox(height: 10.0),
                    getTextFormField(   //TextFormField for mobile number
                        controller: _conMobileNum,
                        icon: Icons.phone_android_outlined,
                        inputType: TextInputType.phone,
                        hintName: 'Mobile Number'),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Text('NIC'),
                        Switch(   //Toggle button for NIC/Passport
                          value: _toggleValue,
                          onChanged: (value) {
                            //If switch value is True it read the input as Passport
                            //if switch value is false, it read the input as NIC
                            setState(() {
                              _toggleValue = value;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                        Text('Passport'),
                      ],
                    ),
                    getTextFormField(   //TextFormField for Nic/Passport
                      controller: _conNICorPassport,
                      icon: Icons.person_outline,
                      hintName: _toggleValue ? 'Passport' : 'NIC',
                    ),
                    SizedBox(height: 10.0),
                    getTextFormField(   //TextFormField for password
                      controller: _conPassword,
                      icon: Icons.lock_outline,
                      hintName: 'Password',
                      isObscureText: true,
                    ),
                    SizedBox(height: 10.0),
                    getTextFormField(   //TextFormField for confirm password
                      controller: _conCPassword,
                      icon: Icons.lock_outline,
                      hintName: 'Confirm Password',
                      isObscureText: true,
                    ),
                    SizedBox(height: 20.0),
                    TextButton(
                      onPressed: signUp,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan[500],
                        minimumSize: Size(MediaQuery.of(context).size.width, 50),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                      child: Text(
                        "Sign-up",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?'),
                        TextButton(
                          //textColor: Colors.blue,
                          child: Text('Sign-in', style: TextStyle(color: Colors.cyan[700])),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => LoginPage()),
                                    (Route<dynamic> route) => false);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
