// import 'package:flutter/material.dart';
// import '../Common/PopUpMessage.dart';
// import '../PassengerDetailsConfirmationScreen/PassengerDetailsConfirmationScreen.dart';
// import 'FoodMenuScreen.dart';
//
// class NavigationScreen extends StatefulWidget {
//   @override
//   _NavigationScreenState createState() => _NavigationScreenState();
// }
//
// class _NavigationScreenState extends State<NavigationScreen> {
//   @override
//
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance?.addPostFrameCallback((_) async {
//       bool? confirmed = await popUpMessage.showConfirmationDialog(context);
//       if (confirmed == true) {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => FoodMenuScreen()));
//       } else{
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => PassengerDetailsConfirmation()));
//       }
//       });
//     }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text('Navigation Screen'),
//       ),
//     );
//   }
// }