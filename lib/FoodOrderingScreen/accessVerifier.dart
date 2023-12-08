// import 'package:flutter/material.dart';
//
// import '../Common/textfield.dart';
// import '../FoodOrderingScreen/FoodMenuScreen.dart';
// import '../SessionTracking.dart';
//
// class accessVerifierScreen extends StatefulWidget {
//
//   @override
//   _accessVerifierScreen createState() => _accessVerifierScreen();
// }
//
//
// class _accessVerifierScreen extends State<accessVerifierScreen> {
//   final _conReservationID = TextEditingController();
//
//   SessionTracking sessiontracking = SessionTracking();
//
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Confirm Details",
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Colors.cyan[500],
//       ),
//       body: Form(
//         //key: _formKey,
//         child: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: Container(
//             margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//             child: Center(
//               child: Column(
//                 //mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   getTextFormField(
//                       controller: _conReservationID,
//                       icon: Icons.person,
//                       inputType: TextInputType.name,
//                       hintName: 'Reservation ID'),
//                   SizedBox(height: 10.0),
//                   SizedBox(height: 10.0),
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: TextButton(
//                       onPressed: () {
//                         String _textFieldValue = _conReservationID.text;
//                         print(_textFieldValue);
//                         sessiontracking.fetchData(context, reservationid: _textFieldValue);
//
//                         Navigator.push(
//                             context, MaterialPageRoute(builder: (_) => FoodMenuScreen()));
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         minimumSize: Size(MediaQuery.of(context).size.width, 50),
//                         elevation: 2,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5.0)),
//                       ),
//                       child: Text(
//                         "Confirm",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }