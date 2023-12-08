import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class TrainDataManager {
  //Lists to store the filtered trains
  List<Map> filteredSingleTrains = [];
  List<Map> filteredReturnTrains = [];
  List<Map> filteredSingleSeatsAvailability = [];
  List<Map> filteredReturnSeatsAvailability = [];

  final DatabaseReference reference = FirebaseDatabase.instance.ref().child('Train Schedule');

  //get the filtering criteria
  Future<void> fetchDataAndFilter({
    required String selectedStart,
    required String selectedEnd,
    required String selectedDepartureDate,
    required String selectedReturnDate,
    required int selectedPassengerCount,
  }) async {
    final event = await reference
        .orderByChild('Start Station') // Filter by Start Station
        .equalTo(selectedStart) // Match the selectedStart
        .once();

      // Handle the event
      if (event.snapshot.value != null &&
          event.snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> data = event.snapshot.value as Map<
            dynamic,
            dynamic>;
        List<Map<dynamic, dynamic>> matchingTrains = data.values.toList().cast<
            Map<dynamic, dynamic>>();

        //filter trains
        filteredSingleTrains = matchingTrains.where((train) {
          String date = train['Date'];
          String departTime = train['Departs'];

          DateFormat format = DateFormat('dd-MM-yyyy');
          DateTime scheduleDate = format.parse(date);

          String formattedDate = DateFormat('yyyy-MM-dd').format(scheduleDate);

          String dateTimeString = '$formattedDate $departTime';
          DateTime scheduleDateTime = DateTime.parse(dateTimeString);

          return train['End Station'] == selectedEnd &&
              train['Date'] == selectedDepartureDate.toString() &&
              DateTime.now().isBefore(scheduleDateTime) &&
              train['Seats Availability'] >= selectedPassengerCount;
        }).toList();
        print(selectedDepartureDate);
        print(filteredSingleTrains);

        //filter trains with less seat availability
        //compared to passenger count
        filteredSingleSeatsAvailability = matchingTrains.where((train) {
          String date = train['Date'];
          String departTime = train['Departs'];

          DateFormat format = DateFormat('dd-MM-yyyy');
          DateTime scheduleDate = format.parse(date);

          String formattedDate = DateFormat('yyyy-MM-dd').format(scheduleDate);

          String dateTimeString = '$formattedDate $departTime';
          DateTime scheduleDateTime = DateTime.parse(dateTimeString);

          return train['End Station'] == selectedEnd &&
              train['Date'] == selectedDepartureDate.toString() &&
              DateTime.now().isBefore(scheduleDateTime) &&
              train['Seats Availability'] < selectedPassengerCount;
        }).toList();


        final eventForReturn = await reference
            .orderByChild('Start Station') // Filter by End Station
            .equalTo(selectedEnd) // Match the selectedStart
            .once();

        // Handle the event
        if (eventForReturn.snapshot.value != null &&
            eventForReturn.snapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> dataForReturn = eventForReturn.snapshot.value as Map<
              dynamic,
              dynamic>;
          List<Map<dynamic, dynamic>> matchingTrainsForReturn = dataForReturn.values
              .toList().cast<
              Map<dynamic, dynamic>>();

          //filter return trains
          filteredReturnTrains = matchingTrainsForReturn.where((train) {
            String date = train['Date'];
            String departTime = train['Departs'];

            DateFormat format = DateFormat('dd-MM-yyyy');
            DateTime scheduleDate = format.parse(date);

            String formattedDate = DateFormat('yyyy-MM-dd').format(scheduleDate);

            String dateTimeString = '$formattedDate $departTime';
            DateTime scheduleDateTime = DateTime.parse(dateTimeString);

            return train['End Station'] == selectedStart &&
                train['Date'] == selectedReturnDate.toString() &&
                DateTime.now().isBefore(scheduleDateTime) &&
                train['Seats Availability'] >= selectedPassengerCount;
          }).toList();
          print('for return: $filteredReturnTrains');


          //filter return trains with less seat availability
          //compared to passenger count
          filteredReturnSeatsAvailability = matchingTrainsForReturn.where((train) {
            String date = train['Date'];
            String departTime = train['Departs'];

            DateFormat format = DateFormat('dd-MM-yyyy');
            DateTime scheduleDate = format.parse(date);

            String formattedDate = DateFormat('yyyy-MM-dd').format(scheduleDate);

            String dateTimeString = '$formattedDate $departTime';
            DateTime scheduleDateTime = DateTime.parse(dateTimeString);

            return train['End Station'] == selectedStart &&
                train['Date'] == selectedReturnDate.toString() &&
                DateTime.now().isBefore(scheduleDateTime) &&
                train['Seats Availability'] < selectedPassengerCount;
          }).toList();
        }
      }
    }
}

// class TrainDataManager {
//   final DatabaseReference reference = FirebaseDatabase.instance.ref().child('Train Schedule');
//
//   Future<List<Map>> fetchDataAndFilter({
//     required String selectedStart,
//     required String selectedEnd,
//     required String selectedDepartureDate,
//     required String selectedReturnDate,
//     required int selectedPassengerCount,
//     required bool isSingleSelected,
//   }) async {
//     List<Map> filteredTrains= [];
//     List<Map> filteredSingleTrains = [];
//     List<Map> filteredReturnTrains = [];
//     List<Map> filteredSingleSeatsAvailability = [];
//     List<Map> filteredReturnSeatsAvailability = [];
//
//     DatabaseEvent event = await reference
//         .orderByChild('Start Station') // Filter by Start Station
//         .equalTo(selectedStart) // Match the selectedStart
//         .once();
//
//     if (event.snapshot.value != null && event.snapshot.value is Map<dynamic, dynamic>) {
//       Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
//       List<Map<dynamic, dynamic>> matchingTrains = data.values.toList().cast<Map<dynamic, dynamic>>();
//
//       filteredTrains = matchingTrains.where((train) {
//         return train['End Station'] == selectedEnd;
//       }).toList();
//
//       filteredSingleTrains = matchingTrains.where((train) {
//         return train['End Station'] == widget.selectedEnd &&
//             train['Date'] == widget.selectedDepartureDate.toString() &&
//             train['Seats Availability'] >= widget.selectedPassengerCount;
//       }).toList();
//       print(widget.selectedDepartureDate);
//       print(filteredSingleTrains);
//
//       filteredReturnTrains = matchingTrains.where((train) {
//         return train['End Station'] == widget.selectedEnd &&
//             train['Date'] == widget.selectedReturnDate.toString() &&
//             train['Seats Availability'] >= widget.selectedPassengerCount;
//       }).toList();
//       print(widget.selectedReturnDate);
//
//       filteredSingleSeatsAvailability = matchingTrains.where((train) {
//         return train['End Station'] == widget.selectedEnd  &&
//             train['Date'] == widget.selectedDepartureDate.toString() &&
//             train['Seats Availability'] < widget.selectedPassengerCount;
//       }).toList();
//
//       filteredReturnSeatsAvailability = matchingTrains.where((train) {
//         return train['End Station'] == widget.selectedEnd  &&
//             train['Date'] == widget.selectedReturnDate.toString() &&
//             train['Seats Availability'] < widget.selectedPassengerCount;
//       }).toList();
//
//
//       // filteredTrains = matchingTrains.where((train) {
//       //     return isSingleSelected
//       //         ? train['Date'] == selectedDepartureDate.toString()
//       //         : train['Date'] == selectedReturnDate.toString();
//       //   }).toList();
//       // filteredSingleTrains = matchingTrains.where((train) {
//       //         return train['End Station'] == selectedEnd &&
//       //             train['Date'] == selectedDepartureDate.toString() &&
//       //             train['Seats Availability'] >= selectedPassengerCount;
//       //       }).toList();
//       //       print(selectedDepartureDate);
//       //       print(filteredSingleTrains);
//       //
//       //       filteredReturnTrains = matchingTrains.where((train) {
//       //         return train['End Station'] == selectedEnd &&
//       //             train['Date'] == selectedReturnDate.toString() &&
//       //             train['Seats Availability'] >= selectedPassengerCount;
//       //       }).toList();
//       //       print(selectedReturnDate);
//       //
//       //       filteredSingleSeatsAvailability = matchingTrains.where((train) {
//       //         return train['End Station'] == selectedEnd  &&
//       //             train['Date'] == selectedDepartureDate.toString() &&
//       //             train['Seats Availability'] < selectedPassengerCount;
//       //       }).toList();
//       //
//       //       filteredReturnSeatsAvailability = matchingTrains.where((train) {
//       //         return train['End Station'] == selectedEnd  &&
//       //             train['Date'] == selectedReturnDate.toString() &&
//       //             train['Seats Availability'] < selectedPassengerCount;
//       //       }).toList();
//     }
//
//     return filteredTrains;
//   }
// }

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
//
// import 'SelectTrain.dart';
//
//
// class TrainFiltration {
//   final String selectedStart;
//   final String selectedEnd;
//   final String selectedDepartureDate;
//   final String selectedReturnDate;
//   final int selectedPassengerCount;
//
//   DatabaseReference reference = FirebaseDatabase.instance.ref().child('Train Schedule');
//
//   TrainFiltration({
//     required this.selectedStart,
//     required this.selectedEnd,
//     required this.selectedDepartureDate,
//     required this.selectedReturnDate,
//     required this.selectedPassengerCount,
//   });
//
//
//   void navigateToSelectTrain(BuildContext context){
//       reference
//       .orderByChild('Start Station')
//       .equalTo(selectedStart)
//       .once()
//       .then((DatabaseEvent event) {
//         if (event.snapshot.value != null && event.snapshot.value is Map<dynamic, dynamic>) {
//           Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
//           List<Map<dynamic, dynamic>> matchingTrains = data.values.toList().cast<Map<dynamic, dynamic>>();
//
//           List<Map> filteredSingleTrains = matchingTrains
//               .where((train) =>
//           train['End Station'] == selectedEnd &&
//               train['Date'] == selectedDepartureDate.toString() &&
//               train['Seats Availability'] >= selectedPassengerCount)
//               .toList();
//
//           List<Map> filteredReturnTrains = matchingTrains
//               .where((train) =>
//           train['End Station'] == selectedEnd &&
//               train['Date'] == selectedReturnDate.toString() &&
//               train['Seats Availability'] >= selectedPassengerCount)
//               .toList();
//
//           List<Map> filteredSingleSeatsAvailability = matchingTrains
//               .where((train) =>
//           train['End Station'] == selectedEnd &&
//               train['Date'] == selectedDepartureDate.toString() &&
//               train['Seats Availability'] < selectedPassengerCount)
//               .toList();
//
//           List<Map> filteredReturnSeatsAvailability = matchingTrains
//               .where((train) =>
//           train['End Station'] == selectedEnd &&
//               train['Date'] == selectedReturnDate.toString() &&
//               train['Seats Availability'] < selectedPassengerCount)
//               .toList();
//           {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) =>
//                     SelectTrain(
//                       filteredSingleTrains: filteredSingleTrains,
//                       filteredReturnTrains: filteredReturnTrains,
//                       filteredSingleSeatsAvailability: filteredSingleSeatsAvailability,
//                       filteredReturnSeatsAvailability: filteredReturnSeatsAvailability,
//                     ),
//               ),
//             );
//           }
//         }
//       }
//       );
//           }
// }