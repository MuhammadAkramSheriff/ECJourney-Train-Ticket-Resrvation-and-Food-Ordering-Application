import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'FoodOrderingScreen/FoodItemsModel.dart';
import 'Models/Journey Model/JourneyDetailsProvider.dart';
import 'Payment/PaymentModel.dart';

class SessionTracking {
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('Reservations');

  Future<void> fetchData(BuildContext context,
      {required String reservationid}) async {
    print('Inside fetchdata function');
    //Fetch the train details for the Reservation ID from the database
    final event =
        await reference.child(reservationid).child('Train Details').once();

    // Handle the event
    if (event.snapshot.value != null &&
        event.snapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> data =
          event.snapshot.value as Map<dynamic, dynamic>;

      print('initial data check: ${data['Train No']}');
      //Store the fetched data in the proivder
      final journeyDetailsProvider =
          Provider.of<JourneyDetailsProvider>(context, listen: false);
      journeyDetailsProvider.addTrainno(data['Train No']);
      journeyDetailsProvider.addFrom(data['From']);
      journeyDetailsProvider.addTo(data['To']);
      journeyDetailsProvider.addDate(data['Date']);
      journeyDetailsProvider.addDepart(data['Depart Time']);
      journeyDetailsProvider.addArrive(data['Arrive Time']);
      journeyDetailsProvider.addPassengercount(data['Passenger Count']);
      journeyDetailsProvider.addTicketPrice(data['Each Ticket Price']);

      final fooditemsdetailsprovider =
          Provider.of<FoodItemsDetailsProvider>(context, listen: false);
      fooditemsdetailsprovider.addTrainno(data['Train No']);
      print('from fooddetailprovider: ${fooditemsdetailsprovider.trainno}');

      print('trainno: ${journeyDetailsProvider.trainno}');
      print(journeyDetailsProvider.from);
      print(data['From']);
    } else {
      print('no data found fetchdata');
    }
  }

  //Method to delete the reservation from the firestore if the reservation is expired
  Future<void> deleteReservation(context,
      {required String? reservationid}) async {
    print('reservation id passed inside session track: $reservationid');
    final event =
        await reference.child(reservationid!).child('Train Details').once();

    // Handle the event
    if (event.snapshot.value != null &&
        event.snapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> data =
          event.snapshot.value as Map<dynamic, dynamic>;

      //fetch the data and arrive time of the reservation
      //that user has reserved
      String date = data['Date'];
      String arriveTime = data['Arrive Time'];

      DateTime now = DateTime.now(); //get the current datetime

      //formate the reservation date into readable
      DateFormat format = DateFormat('dd-MM-yyyy');
      DateTime reservationDate = format.parse(date);

      String formattedDate = DateFormat('yyyy-MM-dd').format(reservationDate);

      //format the reservation data and arrive time into readable
      String dateTimeString = '$formattedDate $arriveTime';
      DateTime reservationDateTime = DateTime.parse(dateTimeString);
      print('Reservation Date: $reservationDateTime');

      //fetch the user email which he/she has sign-in with
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('EmailAddress');

      final dReference = FirebaseFirestore.instance
          .collection('UserReservations')
          .doc(userEmail);

      //Validate if the user has a reservation on the current reservation id
      dReference.get().then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          print('document exist');
          Map<String, dynamic> dataofFirestore =
              documentSnapshot.data() as Map<String, dynamic>;
          if (dataofFirestore.containsKey('Reservation ID')) {
            print('contains reservation ID');
            String reservationID = dataofFirestore['Reservation ID'];
            //Check if the reseervation date and arrive time is after the current datetime
            if (now.isAfter(reservationDateTime)) {
              print('reservation id after depart time');
              try {
                //If it is after the current datetime
                //check if the user has a return reservation
                if (dataofFirestore.containsKey('Reservation ID (Return)')) {
                  //if the user has a return reservation, assign the current reservation id
                  //to the return reservation id
                  String reservationId =
                      dataofFirestore['Reservation ID (Return)'];
                  //delete the reservation id
                  await dReference.update({
                    'Reservation ID': FieldValue.delete(),
                  });
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setString('Reservation ID', reservationId);
                  // prefs.remove('Reservation ID For Reciept');
                } else {
                  //if the user doenst have a return reservation
                  //delete the document that holds the reservation id with user email
                  await dReference.delete();
                  final prefs = await SharedPreferences.getInstance();
                  prefs.remove('Reservation ID');
                  // prefs.remove('Reservation ID For Reciept');
                  print('Reservation ID deleted successfully due to expire');
                }
              } catch (e) {
                print('Error deleting document');
              }
            } else {
              //if the current reservation id is not after the current dateTime
              //fetch the train details and store it in the proivder
              final journeydetailsprovider =
                  Provider.of<JourneyDetailsProvider>(context, listen: false);
              journeydetailsprovider.addReservationID(reservationID);
              journeydetailsprovider.addTrainno(data['Train No']);
              journeydetailsprovider.addDate(data['Date']);
              journeydetailsprovider.addFrom(data['From']);
              journeydetailsprovider.addTo(data['To']);
              journeydetailsprovider.addDepart(data['Depart Time']);
              journeydetailsprovider.addArrive(data['Arrive Time']);
              journeydetailsprovider.addPassengercount(data['Passenger Count']);
              for (int seatNumber in data['Seat No']) {
                journeydetailsprovider.addSelectedSeat(seatNumber);
              }
            }
          }
          //If the user doesnt have a reservation id (due to expired)
          //check if the user has a return reservation id
          else if (dataofFirestore.containsKey('Reservation ID (Return)')) {
            print('reservation id is not available but return id available');

            //Assign the return reservation id to the current reservation id
            String reservationId = dataofFirestore['Reservation ID (Return)'];
            final prefs = await SharedPreferences.getInstance();
            prefs.setString('Reservation ID', reservationId);

            // String date = data['Date'];
            // String arriveTime = data['Arrive Time'];
            //
            // DateTime now = DateTime.now();
            //
            // DateFormat format = DateFormat('dd-MM-yyyy');
            // DateTime reservationDate = format.parse(date);
            //
            // String formattedDate = DateFormat('yyyy-MM-dd').format(
            //     reservationDate);
            //
            // String dateTimeString = '$formattedDate $arriveTime';
            // DateTime reservationDateTime = DateTime.parse(dateTimeString);
            //
            //
            // print('Reservation Date: $reservationDateTime');

            // final prefs = await SharedPreferences.getInstance();
            // final userEmail = prefs.getString('EmailAddress');

            // final dReference = FirebaseFirestore.instance.collection(
            //     'UserReservations').doc(userEmail);

            //if the retrun reservation Date and arrive time is after the current datetime
            if (now.isAfter(reservationDateTime)) {
              print('return id is after arrive time');
              try {
                //delete the document that holds the reservation id with user email
                await dReference.delete();
                final prefs = await SharedPreferences.getInstance();
                prefs.remove('Reservation ID');
                // prefs.remove('Reservation ID (Return) For Reciept');
                print('Reservation ID deleted successfully due to expire');
              } catch (e) {
                print('Error deleting document');
              }
            } else {
              print('Reservation ID valid');
            }

            // try {
            //   await dReference.update({
            //     'Reservation ID': FieldValue.delete(),
            //   });
            //   if (!data.containsKey('Reservation ID (Return)')) {
            //     prefs.remove('Reservation ID');
            //     print('Reservation ID manually deleted');
            //   }else{
            //     String reservationId = data['Reservation ID (Return)'];
            //     final prefs = await SharedPreferences.getInstance();
            //     prefs.setString('Reservation ID', reservationId);
            //   }
            // } catch (e) {
            //   print('Error deleting document: $e');
            // }
          }
          //if the return reservation id is not available in the document
          //delete the document
          else {
            print('document dont have either ID');
            try {
              await dReference.delete();
              final prefs = await SharedPreferences.getInstance();
              prefs.remove('Reservation ID');
              // prefs.remove('Reservation ID For Reciept');
              // prefs.remove('Reservation ID (Return) For Reciept');
              print('Reservation ID manually deleted');
            } catch (e) {
              print('Error deleting document: $e');
            }
          }
          //check if the user has a return reservation id during the session tracking
          if (dataofFirestore.containsKey('Reservation ID (Return)')) {
            print('inside return reservation sstr');
            String reservationID = dataofFirestore['Reservation ID (Return)'];

            final event = await reference
                .child(reservationID)
                .child('Train Details')
                .once();

            // Handle the event
            if (event.snapshot.value != null &&
                event.snapshot.value is Map<dynamic, dynamic>) {
              Map<dynamic, dynamic> data =
                  event.snapshot.value as Map<dynamic, dynamic>;

              //Store the return reservation train details into the provider
              final returnjourneydetailsprovider =
                  Provider.of<ReturnJourneyDetailsProvider>(context,
                      listen: false);
              returnjourneydetailsprovider.addReservationID(reservationID);
              returnjourneydetailsprovider.addTrainno(data['Train No']);
              returnjourneydetailsprovider.addDate(data['Date']);
              returnjourneydetailsprovider.addFrom(data['From']);
              returnjourneydetailsprovider.addTo(data['To']);
              returnjourneydetailsprovider.addDepart(data['Depart Time']);
              returnjourneydetailsprovider.addArrive(data['Arrive Time']);
              returnjourneydetailsprovider
                  .addPassengercount(data['Passenger Count']);
              for (int seatNumber in data['Seat No']) {
                returnjourneydetailsprovider.addSelectedSeat(seatNumber);
              }
              returnjourneydetailsprovider
                  .addTicketPrice(data['Each Ticket Price']);
            }
          }
          //if document with the user email doesnt exist
          //remove the reservation id in the shared preference
        } else {
          final prefs = await SharedPreferences.getInstance();
          prefs.remove('Reservation ID');
        }
        final prefs = await SharedPreferences.getInstance();
        final ridBeforeCheck = prefs.getString('Reservation ID');
        print('reservation id at final of sesst: $ridBeforeCheck');
      }).catchError((error) {
        print('Error getting document: $error');
      });
    } else {
      print('no data');
    }
  }

// Future<void> deleteReservationReturn({required String? reservationid}) async {
//   final event = await reference
//       .child(reservationid!)
//       .child('Train Details')
//       .once();
//
//   // Handle the event
//   if (event.snapshot.value != null &&
//       event.snapshot.value is Map<dynamic, dynamic>) {
//     Map<dynamic, dynamic> data = event.snapshot.value as Map<
//         dynamic,
//         dynamic>;
//
//     String date = data['Date'];
//     String arriveTime = data['Arrive Time'];
//
//     DateTime now = DateTime.now();
//
//     DateFormat format = DateFormat('dd-MM-yyyy');
//     DateTime reservationDate = format.parse(date);
//
//     String formattedDate = DateFormat('yyyy-MM-dd').format(reservationDate);
//
//     String dateTimeString = '$formattedDate $arriveTime';
//     DateTime reservationDateTime = DateTime.parse(dateTimeString);
//
//
//     print('Reservation Date: $reservationDateTime');
//
//     final prefs = await SharedPreferences.getInstance();
//     final userEmail = prefs.getString('EmailAddress');
//
//     final dReference = FirebaseFirestore.instance.collection('UserReservations').doc(userEmail);
//
//     dReference.get().then((DocumentSnapshot documentSnapshot) async {
//       if (documentSnapshot.exists) {
//         if (data != null && data.containsKey('Reservation ID (Return)') && !data.containsKey('Reservation ID')) {
//           String reservationId = data['Reservation ID (Return)'];
//           final prefs = await SharedPreferences.getInstance();
//           prefs.setString('Reservation ID', reservationId);
//
//           print('Document data: ${documentSnapshot.data()}');
//         if (now.isAfter(reservationDateTime)) {
//           try {
//             await dReference.delete();
//             prefs.remove('Reservation ID');
//             print('Reservation ID deleted successfully due to expire');
//           } catch (e) {
//             print('Error deleting document');
//           }
//         }
//         else {
//           print('Reservation ID valid');
//         }
//       }
//       } else {
//         try {
//           await dReference.delete();
//           prefs.remove('Reservation ID');
//           print('Reservation ID manually deleted');
//         } catch (e) {
//           print('Error deleting document: $e');
//         }
//       }
//
//     }).catchError((error) {
//       print('Error getting document: $error');
//     });
//
//
//   }else{
//     print('no data');
//   }
// }
}
