import 'package:ecjourney/generateDatabaseIDs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../FinalInsertionIntoDatabase/FoodOrderConfirmation.dart';
import '../../FoodOrderingScreen/FoodItemsModel.dart';
import '../../Models/Journey Model/JourneyDetailsProvider.dart';
import '../../SearchTrainScreen/SearchTrainScreenResources/executeOverLay.dart';
import '../../SeatSelectionScreen/SelectSeatFunctions.dart';
import '../../callSaveInDatabase.dart';
import '../savePaymentInDatabase.dart';

// class RecieptScreenForReservation extends StatefulWidget {
//   const RecieptScreenForReservation({super.key});
//
//   @override
//   State<RecieptScreenForReservation> createState() =>
//       _RecieptScreenForReservationState();
// }
//
// class _RecieptScreenForReservationState extends State<RecieptScreenForReservation> {
//
//   List<String?> ReservationId = [];
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final reservationDetailsProvider = Provider.of<JourneyDetailsProvider>(context, listen: false);
//     ReservationId.add(reservationDetailsProvider.reservationid);
//
//     final returnjourneydetailsprovider = Provider.of<ReturnJourneyDetailsProvider>(context, listen: false);
//     String? trainno = returnjourneydetailsprovider.trainno;
//     String? returnReservationID;
//
//     if (trainno!= null){
//       returnReservationID = returnjourneydetailsprovider.reservationid;
//       ReservationId.add('${returnReservationID} (Return)');
//     }
//
//     return PopScope(
//               canPop: false,
//               child: Scaffold(
//                 body: Container(
//                   padding:
//                       EdgeInsets.symmetric(vertical: 50.0, horizontal: 25.0),
//                   child: Column(
//                     children: [
//                       Container(
//                         height: 50,
//                         decoration: BoxDecoration(
//                           border: Border.all(width: 1, color: Colors.green),
//                           color: Colors.green[200],
//                         ),
//                         child: Center(
//                           child: Row(
//                             children: [
//                               SizedBox(width: 10),
//                               Icon(
//                                 Icons.check_circle,
//                               ),
//                               SizedBox(width: 10),
//                               Text(
//                                 'Your Reservation is Confirmed!',
//                                 style: TextStyle(
//                                     fontSize: 16, color: Colors.green),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Container(
//                         height: 500,
//                         decoration: BoxDecoration(
//                           border: Border.all(width: 1, color: Colors.grey),
//                         ),
//                         child: Column(
//                           children: [
//                             SizedBox(height: 10),
//                             QrImageView(
//                               data: ReservationId.join(' , '),
//                               version: QrVersions.auto,
//                               size: 150,
//                               gapless: false,
//                             ),
//                             SizedBox(height: 10),
//                             Center(
//                               child: Text(
//                                 'RESERVATION ID',
//                                 style: TextStyle(
//                                     fontSize: 12, fontWeight: FontWeight.w200),
//                               ),
//                             ),
//                             SizedBox(height: 10),
//                             Center(
//                               child: Text(
//                                 '$ReservationId',
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//   }
// }

class RecieptScreenForReservation extends StatefulWidget {
  //const RecieptScreenForReservation({super.key});

  final bool newReciept;

  RecieptScreenForReservation({required this.newReciept});

  @override
  State<RecieptScreenForReservation> createState() =>
      _RecieptScreenForReservationState();
}

class _RecieptScreenForReservationState
    extends State<RecieptScreenForReservation> {
  String? ReservationId;
  String? returnReservationId;

  String? trainNo;
  String? date;
  String? from;
  String? to;
  String? depart;
  String? arrive;
  int? count;
  String? seatno;

  String? returnTrainNo;
  String? returnDate;
  String? returnFrom;
  String? returnTo;
  String? returnDepart;
  String? returnArrive;
  int? returnCount;
  String? returnSeatno;

  //Get the required details from the provider
  Future<void> getData() async {
    final reservationDetailsProvider =
        Provider.of<JourneyDetailsProvider>(context, listen: false);
    ReservationId = reservationDetailsProvider.reservationid;

    final returnjourneydetailsprovider =
        Provider.of<ReturnJourneyDetailsProvider>(context, listen: false);
    returnReservationId = returnjourneydetailsprovider.reservationid;

    //Get the return reservation details(if applicable)
    if (returnReservationId != null) {
      returnReservationId = '${returnReservationId} (Return)';
      returnTrainNo = returnjourneydetailsprovider.trainno;
      returnDate = returnjourneydetailsprovider.date;
      returnFrom = returnjourneydetailsprovider.from;
      returnTo = returnjourneydetailsprovider.to;
      returnDepart = returnjourneydetailsprovider.depart;
      returnArrive = returnjourneydetailsprovider.arrive;
      returnCount = returnjourneydetailsprovider.passengercount;
      returnSeatno = returnjourneydetailsprovider.selectedSeats.join(' ,');
    }
    //Get the reservation details
    trainNo = reservationDetailsProvider.trainno;
    date = reservationDetailsProvider.date;
    from = reservationDetailsProvider.from;
    to = reservationDetailsProvider.to;
    depart = reservationDetailsProvider.depart;
    arrive = reservationDetailsProvider.arrive;
    count = reservationDetailsProvider.passengercount;
    seatno = reservationDetailsProvider.selectedSeats.join(' ,');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.newReciept ? false : true,
      child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                appBar: widget.newReciept
                    ? null
                    : AppBar(
                        leading: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);

                            if (ReservationId != null) {
                              showOverlay(context);
                            }
                          },
                          child: Icon(Icons.arrow_back),
                        ),
                        title: const Text(
                          "Reservation",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.cyan,
                      ),
                body: SingleChildScrollView(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
                    color: Colors.white60,
                    child: Column(
                      children: [
                        //If the reciept is new
                        if (widget.newReciept)
                        Center(
                          child: Container(
                            color: Colors.green.withOpacity(0.2),
                            height: 50,
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Icon(
                                  Icons.check_circle,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Your Reservation is Confirmed!',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ),

                        //If there is no reservation
                        if (ReservationId == null && returnReservationId == null)
                          Column(children: [
                            Center(
                              child: Text(
                                'No Reservations!',
                                style: TextStyle(
                                  fontSize: 26,
                                ),
                              ),
                            ),
                          ]),
                        SizedBox(height: 20),

                        //If there is reservation
                        if (ReservationId != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.2)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.lightGreen.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Center(
                                  child: QrImageView(
                                    data: ReservationId!,
                                    version: QrVersions.auto,
                                    size: 150,
                                    gapless: false,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Center(
                                  child: Text(
                                    'RESERVATION ID',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w200),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Center(
                                  child: Text(
                                    '$ReservationId',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Divider(),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      trainNo.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    Text(
                                      '  $from - $to',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Text(
                                  '$depart - $arrive | $date',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                                Text(
                                  'Passenger Count: $count',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.airline_seat_recline_extra,
                                        size: 24, color: Colors.black),
                                    Text(
                                      '  $seatno',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightGreen,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),

                        SizedBox(height: 20),
                        Divider(),
                        SizedBox(height: 20),

                        //If there is return ticket reservation
                        if (returnReservationId != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.2)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.lightGreen.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Center(
                                  child: QrImageView(
                                    data: returnReservationId!,
                                    version: QrVersions.auto,
                                    size: 150,
                                    gapless: false,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Center(
                                  child: Text(
                                    'RESERVATION ID',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w200),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Center(
                                  child: Text(
                                    '$returnReservationId',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Divider(),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      returnTrainNo.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    Text(
                                      '  $returnFrom - $returnTo',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Text(
                                  '$returnDepart - $returnArrive | $returnDate',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                                Text(
                                  'Passenger Count: $returnCount',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.airline_seat_recline_extra,
                                        size: 24, color: Colors.black),
                                    Text(
                                      '  $returnSeatno',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightGreen,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Scaffold(
                body: Container(),
              );
            }
          }),
    );
  }
}
