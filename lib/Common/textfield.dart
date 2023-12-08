import 'package:flutter/material.dart';
import 'helper.dart';
import 'package:ecjourney/SingUpScreen/RegistrationPage.dart';


class getTextFormField extends StatelessWidget {
  TextEditingController controller;
  String hintName;
  IconData? icon;
  bool isObscureText;
  TextInputType inputType;
  bool isEnable;

  getTextFormField(
      {required this.controller,
        required this.hintName,
        this.icon,
        this.isObscureText = false,
        this.inputType = TextInputType.text,
        this.isEnable = true
      });


  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: controller,
        obscureText: isObscureText,
        enabled: isEnable,
        keyboardType: inputType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $hintName';
          }
          if (hintName == "Email" && !validateEmail(value)) {
            return 'Please Enter Valid Email';
          }
          return null;
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Colors.cyan),
          ),
          prefixIcon: Icon(icon, size: 20.0, color: Colors.blueGrey ),
          hintText: hintName,
          //labelText: hintName,
          fillColor: Colors.grey[200],
          filled: true,
        ),
      ),
    );
  }
}

/*class textfield extends StatelessWidget {
  TextEditingController controller;
  TextInputType inputtype;
  IconData icon;
  bool obsecuretext;
  String hinttext;
  //double width;

  textfield(
      {required this.controller,
        this.inputtype = TextInputType.text,
        required this.icon,
        this.obsecuretext = false,
        required this.hinttext,
      //this.width = 1110,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
          ]),
      height: 60,
      //width: width,
      child: TextField(
        controller: controller,
        obscureText: obsecuretext,
        keyboardType: inputtype,
        /*validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $hinttext';
          }
          if (hinttext == "Email" && !validateEmail(value)) {
            return 'Please Enter Valid Email';
          }
          return null;
        },*/
        style: TextStyle(color: Colors.black87),
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(icon, color: Color(0xff5ac18e)),
            hintText: hinttext,
            hintStyle: TextStyle(color: Colors.black38)),
      ),
    );
  }
}*/
