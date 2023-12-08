import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecjourney/FoodOrderingScreen/FoodItemsModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/Journey Model/JourneyDetailsProvider.dart';
import '../Models/UserModel/UserDetailsProvider.dart';
import '../PassengerDetailsConfirmationScreen/PassengerDetailsProvider.dart';
import '../Payment/PaymentModel.dart';



  DatabaseReference _trainscheduledbReference = FirebaseDatabase.instance.ref().child('Train Schedule');
  DatabaseReference _reservationdbReference = FirebaseDatabase.instance.ref().child('Reservations');
  DatabaseReference _totalreservationcountdbReference = FirebaseDatabase.instance.ref().child('Total No Of Reservations');

  final firestore = FirebaseFirestore.instance.collection('UserReservations');

  // void loadSelectedSeats(String singletrainNo) {
  //   _ssdatabaseReference
  //       .child(singletrainNo)
  //       .child('Used Seat')
  //       .once()
  //       .then((DatabaseEvent event) {
  //     if (event.snapshot.value != null) {
  //       final List<dynamic> usedseatList = (event.snapshot.value as List<dynamic>);
  //
  //         selectedSeats.clear();
  //         usedSeats.addAll(usedseatList.cast<int>());
  //
  //     }
  //   }).catchError((error) {
  //     // Handle any errors here
  //     print('Error loading selected seats: $error');
  //   });
  // }
  //
  // void updateSeat(int index) {
  //   if (selectedSeats.contains(index)) return;
  //
  //   if (!usedSeats.contains(index)) {
  //     usedSeats.add(index);
  //     selectedSeats.add(index);
  //   } else {
  //     usedSeats.remove(index);
  //     selectedSeats.add(index);
  //   }
  //
  //   //selectedSeats.clear();
  //   //selectedSeats.addAll(usedSeats);
  //
  //   print('selectedseats in updateseat function: $selectedSeats');
  //   print('$usedSeats');
  //
  //   //saveSelectedSeats(trainNo);
  //
  //   //setState(() {});
  // }

  // void generateReservationId() async {
  //   DatabaseReference _totalreservationcountdbReference = FirebaseDatabase.instance.ref().child('Total No Of Reservations');
  //
  //   String ReservationId = 'R0';
  //
  //   DatabaseEvent event = await _totalreservationcountdbReference.once();
  //
  //   if (event.snapshot.value != null) {
  //     int currentCounterValue = event.snapshot.value as int;
  //     int newCounterValue = currentCounterValue + 1;
  //
  //     ReservationId = 'R$newCounterValue';
  //
  //     await _totalreservationcountdbReference.set(newCounterValue);
  //   }
  // }
  //
  // void saveReservation(context, String trainNo) {
  //   DatabaseReference reservationF = _reservationdbReference.child(trainNo);
  //
  //   final journeyDetailsProvider = Provider.of<JourneyDetailsProvider>(context, listen: false);
  //   String date = journeyDetailsProvider.date;
  //   String from = journeyDetailsProvider.from;
  //   String to = journeyDetailsProvider.to;
  //   String departtime = journeyDetailsProvider.depart;
  //   String arrivetime = journeyDetailsProvider.arrive;
  //   int passengercount = journeyDetailsProvider.passengercount;
  //   String price = journeyDetailsProvider.price;
  //   List<int> selectedseats = journeyDetailsProvider.selectedSeats;
  //   print('sele $selectedseats');
  //
  //
  //   reservationF.child(ReservationId).set({
  //     'Date' : date,
  //     'From' : from,
  //     'To' : to,
  //     'Depart Time' : departtime,
  //     'Arrive Time' : arrivetime,
  //     'Passenger Count' : passengercount,
  //     'Seat No' : selectedseats,
  //     'Price' : price
  //   }).then((value){
  //     print('Success');
  //   }).onError((error, stackTrace){
  //     print((error, stackTrace));
  //   });
  // }
  //
  // void updateSeatAvailability(String trainNo) {
  //   //int usedSeatsCount = usedSeats.length;
  //   int selectedSeatsCount = selectedseats.length;
  //   print('$selectedSeatsCount');
  //   //int recentlyReservedSeatsCount = usedSeatsCount - selectedSeats.length;
  //
  //   _trainscheduledbReference
  //       .child(trainNo)
  //       .child('Seats Availability')
  //       .once()
  //       .then((DatabaseEvent event) {
  //     if (event.snapshot.value != null) {
  //       int currentSeatsAvailability = event.snapshot.value as int;
  //
  //       int newSeatsAvailability = currentSeatsAvailability - selectedSeatsCount;
  //
  //       _trainscheduledbReference
  //           .child(trainNo)
  //           .update({
  //         'Seats Availability': newSeatsAvailability,
  //       }).then((_) {
  //         print('Seats Availability Updated Successfully');
  //       }).catchError((error) {
  //         print('Error updating Seats Availability: $error');
  //       });
  //     }
  //   }).catchError((error) {
  //     // Handle any errors here
  //     print('Error fetching current seats availability: $error');
  //   });
  // }



  Future<void> saveReservation(BuildContext context) async {
      //get the user email address
      UserDataStorage userDataStorage = UserDataStorage();
      Map<String, dynamic>? userData = await userDataStorage.getUserDetails();

      String userEmail = userData?['Email'];

      final passengerdetailsprovider = Provider.of<PassengerDetailsProvider>(context, listen: false);
      String firstname = passengerdetailsprovider.firstname;
      String lastname = passengerdetailsprovider.lastname;
      String mobilenum = passengerdetailsprovider.mobilenum;
      String? nicORpassport = passengerdetailsprovider.nicno;
      String nicorpassportnamefield = 'NIC Number';

      if (nicORpassport == null){
        nicorpassportnamefield = 'Passport Number';
        nicORpassport = passengerdetailsprovider.passportno;
      }

      //Retrieve the the reservation details stored in the provider
      final journeyDetailsProvider = Provider.of<JourneyDetailsProvider>(context, listen: false);
      String? ReservationId = journeyDetailsProvider.reservationid;
      String trainNo = journeyDetailsProvider.trainno;
      String date = journeyDetailsProvider.date;
      String from = journeyDetailsProvider.from;
      String to = journeyDetailsProvider.to;
      String departtime = journeyDetailsProvider.depart;
      String arrivetime = journeyDetailsProvider.arrive;
      int passengercount = journeyDetailsProvider.passengercount;
      int price = journeyDetailsProvider.ticketprice;
      List<int> selectedseats = journeyDetailsProvider.selectedSeats;

      final paymentDetailsProvider = Provider.of<PaymentDetailsProvider>(context, listen: false);
      String invoiceno = paymentDetailsProvider.paymentid;
      int? totalticketprice = paymentDetailsProvider.totalticketamount;
      double servicecharge = paymentDetailsProvider.servicecharge;

      int foodprice = 0;

      //Store the retreived data from the provider into the Reservation database
      DatabaseReference reservationF = _reservationdbReference;


      //Create child Node as Passenger details
      reservationF.child(ReservationId!).child('Passenger Details').set({
        'First Name': firstname,
        'Last Name': lastname,
        'Email': userEmail,
        'Mobile Number': mobilenum,
        '$nicorpassportnamefield': nicORpassport,
      });

      //Create a child node as Train Details
      reservationF.child(ReservationId).child('Train Details').set({
        'Train No': trainNo,
        'Date' : date,
        'From' : from,
        'To' : to,
        'Depart Time' : departtime,
        'Arrive Time' : arrivetime,
        'Passenger Count' : passengercount,
        'Seat No' : selectedseats,
        'Each Ticket Price' : price,
      });

      final foodDetailsProvider = Provider.of<FoodItemsDetailsProvider>(context, listen: false);
      String? foodorderstatus = foodDetailsProvider.foodorderstatus;
      if (foodorderstatus != 'No Order'){
        String foodorderid = foodDetailsProvider.foodorderid;
        List<String> item = [];
        foodprice = foodDetailsProvider.totalamount;

        //Iterate each food item in the List
        for (Map<String, dynamic> itemMap in foodDetailsProvider.items) {
          item.add('${itemMap['Item no']} ${itemMap['Item Name']}(LKR ${itemMap['Item Price']}) x '
              '${itemMap['Count']} = LKR ${itemMap['Total Amount']}');
        }

        //Create child node as food order
        reservationF.child(ReservationId).child('Food Order').set({
          'Order No': foodorderid,
          'Item': item,
          'Total Amount For Food': foodprice,
        });
      }

      //Create child node as Payment
      reservationF.child(ReservationId).child('Payment').set({
        'Invoice No': invoiceno,
        'Total Ticket Price': totalticketprice,
        'Total Food Amount': foodprice,
        'Service Charge': servicecharge,
        'Total Amount': (totalticketprice + foodprice),
      }).then((value) async {

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('Reservation ID', ReservationId);

        //Save in firestore
        firestore.doc(userEmail).set({
          'Reservation ID' : ReservationId,
        }).then((value){
          print('Successfully saved in firestore');
        }).onError((error, stackTrace){
          print('stroing in firestore failed');
          print((error, stackTrace));
        });

        //After successfully saving the reservation details into the database

        //Update the Seat Availability count in the Train Schedule database
        int selectedSeatsCount = selectedseats.length;
        print('$selectedSeatsCount');

        //Retrieve the current seat count from the database
        _trainscheduledbReference
            .child(trainNo)
            .child('Seats Availability')
            .once()
            .then((DatabaseEvent event) {
          if (event.snapshot.value != null) {
            int currentSeatsAvailability = event.snapshot.value as int;

            //Get the new count after subracting the recent reservation
            int newSeatsAvailability = currentSeatsAvailability - selectedSeatsCount;

            //Update the new count to the Database
            _trainscheduledbReference
                .child(trainNo)
                .update({
              'Seats Availability': newSeatsAvailability,

            }).then((_) async {
              print('Seats Availability Updated Successfully');

              //After Successfully saving the Single Train Reservation details
              //Save the Return Train Reservation details
              final ReturnjourneyDetailsProvider = Provider.of<ReturnJourneyDetailsProvider>(context, listen: false);

              if (ReturnjourneyDetailsProvider.trainno != null) {

                  //Retrieve the the reservation details stored in the provider
                String? ReservationId =  ReturnjourneyDetailsProvider.reservationid;
                  String? trainNo = ReturnjourneyDetailsProvider.trainno;
                  String date = ReturnjourneyDetailsProvider.date;
                  String from = ReturnjourneyDetailsProvider.from;
                  String to = ReturnjourneyDetailsProvider.to;
                  String departtime = ReturnjourneyDetailsProvider.depart;
                  String arrivetime = ReturnjourneyDetailsProvider.arrive;
                  int passengercount = ReturnjourneyDetailsProvider.passengercount;
                  int price = ReturnjourneyDetailsProvider.ticketprice;
                  List<int> selectedseats = ReturnjourneyDetailsProvider.selectedSeats;

                  int? returntotalticketprice = paymentDetailsProvider.returntotalticketamount;

                  //Store the retreived data from the provider into the Reservation database
                  DatabaseReference reservationF = _reservationdbReference;

                  //Create child node as passenger details
                  reservationF.child(ReservationId!).child('Passenger Details').set({
                    'First Name': firstname,
                    'Last Name': lastname,
                    'Email': userEmail,
                    'Mobile Number': mobilenum,
                    '$nicorpassportnamefield': nicORpassport,
                  });

                  //Create child node as train details
                  reservationF.child(ReservationId).child('Train Details').set({
                    'Train No': trainNo,
                    'Date' : date,
                    'From' : from,
                    'To' : to,
                    'Depart Time' : departtime,
                    'Arrive Time' : arrivetime,
                    'Passenger Count' : passengercount,
                    'Seat No' : selectedseats,
                    'Each Ticket Price' : price,
                  });

                  //Create child node as Payment
                  reservationF.child(ReservationId).child('Payment').set({
                    'Invoice No': invoiceno,
                    'Total Ticket Price': returntotalticketprice,
                    'Service Charge': servicecharge,
                    'Total Amount': returntotalticketprice,
                  }).then((value) async {


                    //Save in firestore
                    firestore.doc(userEmail).update({
                      'Reservation ID (Return)' : ReservationId,
                    }).then((value){
                      print('Successfully saved in firestore');
                    }).onError((error, stackTrace){
                      print('stroing in firestore failed');
                      print((error, stackTrace));
                    });

                    //prefs.setString('Reservation ID (Return) For Reciept', ReservationId);

                    //After successfully saving the reservation details into the database

                    //Update the Seat Availability count in the Train Schedule database
                    int selectedSeatsCount = selectedseats.length;
                    print('$selectedSeatsCount');

                    //Retrieve the current seat count from the database
                    _trainscheduledbReference
                        .child(trainNo!)
                        .child('Seats Availability')
                        .once()
                        .then((DatabaseEvent event) {
                      if (event.snapshot.value != null) {
                        int currentSeatsAvailability = event.snapshot.value as int;

                        //Get the new count after subracting the recent reservation
                        int newSeatsAvailability = currentSeatsAvailability - selectedSeatsCount;

                        //Update the new count to the Database
                        _trainscheduledbReference
                            .child(trainNo)
                            .update({
                          'Seats Availability': newSeatsAvailability,
                        }).then((_) async {
                          print('Seats Availability Updated Successfully');
                        }).catchError((error) {
                          print('Error updating Seats Availability: $error');
                        });
                      }
                    }).catchError((error) {
                      print('Error fetching current seats availability: $error');
                    });
                    print('Success');
                  }).onError((error, stackTrace){
                    print((error, stackTrace));
                  });
                }

            }).catchError((error) {
              print('Error updating Seats Availability: $error');
            });
          }
        }).catchError((error) {
          print('Error fetching current seats availability: $error');
        });
        print('Success');
      }).onError((error, stackTrace){
        print((error, stackTrace));
      });

    }

