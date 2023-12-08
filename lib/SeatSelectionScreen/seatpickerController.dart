// import 'package:flutter/material.dart';
//
// import 'SelectSeat.dart';
//
//
// class SeatPickerController extends State<SelectSeat>
//     {
//   static late SeatPickerController instance;
//   late SelectSeat view;
//
//   @override
//   void initState() {
//     instance = this;
//     super.initState();
//   }
//
//   @override
//   void dispose() => super.dispose();
//
//   @override
//   Widget build(BuildContext context) => widget.build(context, this);
//
//   List<int> usedSeats = [11];
//   List<int> selectedSeats = [
//     0,
//     1,
//     2,
//     3,
//     4,
//     7,
//     8,
//     9,
//     12,
//     16,
//     18,
//     19,
//     20,
//     21,
//     23,
//     24,
//     27
//   ];
//
//   updateSeat(int index) {
//     if (selectedSeats.contains(index)) return;
//
//     if (!usedSeats.contains(index)) {
//       usedSeats.add(index);
//     } else {
//       usedSeats.remove(index);
//     }
//     setState(() {});
//   }
// }