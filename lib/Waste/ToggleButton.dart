// import 'package:ecjourney/Common/textfield.dart';
// import 'package:flutter/material.dart';
//
// class ToggleButton extends StatefulWidget {
//   @override
//   State<ToggleButton> createState() => _ToggleButtonState();
// }
//
// class _ToggleButtonState extends State<ToggleButton> {
//   bool _toggleValue = false;
//
//   @override
//   Widget build(BuildContext context) {
//     /*return Scaffold(
//       body: Center(
//         child: ToggleButtons(
//           isSelected: toggle_status,
//           borderWidth: 2,
//           borderRadius: BorderRadius.circular(8),
//           borderColor: Colors.orange,
//           selectedBorderColor: Colors.red,
//           fillColor: Colors.greenAccent,
//           color: Colors.orange,
//           splashColor: Colors.greenAccent,
//           selectedColor: Colors.green,
//           onPressed: (int index) {
//             setState(() {
//               toggle_status[index] = !toggle_status[index];
//             });
//           },
//           children: const [
//             Icon(Icons.account_circle),
//             Icon(Icons.add_a_photo),
//             //Text("NIC"),
//             //Text("Passport"),
//           ],
//         ),
//       ),*/
//     /*return ToggleButtons(
//       children: [
//         Text('NIC'),
//         Text('Passport'),
//       ],
//       isSelected: [
//         _Option1Selected,
//         !_Option1Selected,
//       ],
//       onPressed: (index) {
//         setState(() {
//           _Option1Selected = index == 0;
//         });
//       },
//     );*/
//     return Column(
//     children: [
//     Row(
//       children: [
//         Text(
//         _toggleValue ? 'Passport' : 'NIC',
//         style: TextStyle(fontSize: 18),
//         ),
//         Switch(
//           value: _toggleValue,
//           onChanged: (value) {
//             setState(() {
//               _toggleValue = value;
//             });
//           },
//         ),
//       ],
//     ),
//     ],
//     );
//   }
// }
/*return ToggleButtons(
children: [
Text('NIC'),
Text('Passport'),
],
isSelected: [
_Option1Selected,
!_Option1Selected,
],
onPressed: (index) {
setState(() {
_Option1Selected = index == 0;
});
},
);*/