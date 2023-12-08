// import 'dart:html';
//
// import 'package:ecjourney/AdminPanel/Train%20Info/AddSchedule.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
//
// import '../../Common/textfield.dart';
//
// class TrainSchedule extends StatefulWidget {
//   static const String id = "trainschedule-screen";
//
//   @override
//   _TrainSchedule createState() => _TrainSchedule();
// }
//
// class _TrainSchedule extends State<TrainSchedule> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Center(
//             child: Text(
//               'Train Schedule',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left: 8.0),
//           child: Row(
//             children: [
//               ElevatedButton(
//                 child: Text('Add Schedule'),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => AddTrain()),
//                   );
//                 },
//               ),
//               SizedBox(width: 700),
//               Text(
//                 'Search',
//               ),
//               SizedBox(width: 10.0),
//               Expanded(
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Train No/Name',
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 10.0),
//         TSDataTableWidget(),
//       ],
//     );
//   }
// }
//
// class TSDataTableWidget extends StatefulWidget {
//   @override
//   _TSDataTableWidgetState createState() => _TSDataTableWidgetState();
// }
//
// class _TSDataTableWidgetState extends State<TSDataTableWidget> {
//
//   DatabaseReference _dbReference =
//   FirebaseDatabase.instance.ref().child('Users');
//
//   @override
//   Widget build(BuildContext context) {
//             return StreamBuilder<Event> (
//               stream: _dbReference.onValue,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 }
//
//                 var dataMap = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
//                 if (dataMap == null || dataMap.isEmpty) {
//                   return Center(child: Text('No data available.'));
//                 }
//
//                 var rows = dataMap.entries.map((entry) {
//                   var data = entry.value as Map<String, dynamic>;
//                   return DataRow(cells: [
//                     DataCell(Text(data['Train No & Name'] ?? '')),
//                     DataCell(Text(data['Departs'] ?? '')),
//                     DataCell(Text(data['Arrives'] ?? '')),
//                     DataCell(Text(data['Seat Available'] ?? '')),
//                     DataCell(Text(data['Price'] ?? '')),
//                     DataCell(Row(
//                       children: [
//                         ElevatedButton(
//                           child: Text('Update'),
//                           onPressed: () {
//                             // Handle update button press
//                           },
//                         ),
//                         SizedBox(width: 5.0),
//                         ElevatedButton(
//                           child: Text('Delete'),
//                           onPressed: () {
//                             // Handle delete button press
//                           },
//                         ),
//                       ],
//                     )),
//                   ]);
//                 }).toList();
//
//                 return DataTable(
//                   columns: [
//                     DataColumn(label: Text('Train No & Name')),
//                     DataColumn(label: Text('Departs')),
//                     DataColumn(label: Text('Arrives')),
//                     DataColumn(label: Text('Seat Available')),
//                     DataColumn(label: Text('Price')),
//                     DataColumn(label: Center(child: Text('Operation', textAlign: TextAlign.center))),
//                   ],
//                   rows: rows,
//                 );
//               },
//             ),
//             //return DataTable(
//             //   columns: [
//             //     DataColumn(label: Text('Train No & Name')),
//             //     DataColumn(label: Text('Departs')),
//             //     DataColumn(label: Text('Arrives')),
//             //     DataColumn(label: Text('Seat Available')),
//             //     DataColumn(label: Text('Price')),
//             //     DataColumn(label: Center(child: Text('Operation', textAlign: TextAlign.center))),
//             //   ],
//             //   rows: [
//             //     DataRow(cells: [
//             //       DataCell(Text('1005 Galle-Kandy')),
//             //       DataCell(Text('7:00')),
//             //       DataCell(Text('9:30')),
//             //       DataCell(Text('50')),
//             //       DataCell(Text('1000 Rs')),
//             //       DataCell(Row(
//             //         children: [
//             //           ElevatedButton(
//             //             child: Text('Update'),
//             //             onPressed: () {
//             //               // Handle button press
//             //             },
//             //           ),
//             //           SizedBox(width: 5.0),
//             //           ElevatedButton(
//             //             child: Text('Delete'),
//             //             onPressed: () {
//             //               // Handle button press
//             //             },
//             //           ),
//             //         ],
//             //       )),
//             //     ]),
//             //   ],
//             // ),
//           ),
//         );
//       },
//     );
//   }
// }