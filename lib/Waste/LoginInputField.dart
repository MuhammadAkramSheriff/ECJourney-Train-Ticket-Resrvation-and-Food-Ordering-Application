// import 'package:flutter/material.dart';
// import 'package:wc_form_validators/wc_form_validators.dart';
//
// import '../Common/Helper.dart';
//
// class InputField extends StatelessWidget {
//   TextEditingController controller;
//   String hinttext;
//   IconData icon;
//   bool isObscureText;
//   TextInputType inputType;
//   bool isEnable;
//
//   InputField(
//       {required this.controller,
//         required this.hinttext,
//         required this.icon,
//         this.isObscureText = false,
//         this.inputType = TextInputType.text,
//         this.isEnable = true});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Container(
//           alignment: Alignment.centerLeft,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             boxShadow:[
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 6,
//                 offset: Offset(0,2)
//               )
//             ]
//           ),
//           height: 60,
//           child: TextFormField(
//             controller: controller,
//             obscureText: isObscureText,
//             enabled: isEnable,
//             keyboardType: inputType,
//             style: TextStyle(
//               color: Colors.black87
//             ),
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.only(top: 14),
//               prefixIcon: Icon(
//                 icon,
//                 color: Color(0xff5ac18e)
//               ),
//               hintText: hinttext,
//               labelText: hinttext,
//               hintStyle: TextStyle(
//                 color: Colors.black38
//               )
//             ),
//             /*validator: Validators.compose([
//               Validators.required('Email is Required'),
//               Validators.email('Invalid email address')],
//             ),*/
//           ),
//         ),
//         /*Container(
//           padding: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             border: Border(
//               bottom: BorderSide(color: Colors.grey.shade200)
//             )
//           ),
//           child: TextField(
//             decoration: InputDecoration(
//               hintText: "Enter your email",
//               hintStyle: TextStyle(color: Colors.grey),
//               border: InputBorder.none
//             ),
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//               border: Border(
//                   bottom: BorderSide(color: Colors.grey.shade200)
//               )
//           ),
//           child: TextField(
//             decoration: InputDecoration(
//                 hintText: "Enter your password",
//                 hintStyle: TextStyle(color: Colors.grey),
//                 border: InputBorder.none
//             ),
//           ),
//         ),*/
//       ],
//     );
//   }
// }