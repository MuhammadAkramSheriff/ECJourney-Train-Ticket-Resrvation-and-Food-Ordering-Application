// import 'package:flutter/material.dart';
//
// class dropdownList extends StatefulWidget {
//
//   final List<String> items;
//   final String selectedItem;
//   final void Function(String?) onChanged;
//
//   const dropdownList({
//     required this.items,
//     required this.selectedItem,
//     required this.onChanged,
//   });
//
//   @override
//   _dropdownList createState() => _dropdownList();
// }
//
// class _dropdownList extends State<dropdownList> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 16.0),
//       child: DropdownButton<String>(
//         value: widget.selectedItem,
//         onChanged: widget.onChanged,
//         underline: Container(),
//         items: widget.items.map((String item) {
//           return DropdownMenuItem<String>(
//             value: item,
//             child: Text(item),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }