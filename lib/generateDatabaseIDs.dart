
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import 'FoodOrderingScreen/FoodItemsModel.dart';
import 'Models/Journey Model/JourneyDetailsProvider.dart';
import 'Payment/PaymentModel.dart';



DatabaseReference _totalreservationcountdbReference = FirebaseDatabase.instance.ref().child('Total No Of Reservations');
DatabaseReference _totalfoodorderscountdbReference = FirebaseDatabase.instance.ref().child('Total No Of Food Orders');
DatabaseReference _totalpaymentscountdbReference = FirebaseDatabase.instance.ref().child('Total No Of Payments');

  Future<void> generatePaymentinvoiceno(BuildContext context) async {
    //generate payment INVOICE NO
    DatabaseEvent event = await _totalpaymentscountdbReference.once();

    //String InvoiceNo = 'ECI1';

    if (event.snapshot.value != null) {
      int currentCounterValue = event.snapshot.value as int;
      int newCounterValue = currentCounterValue + 1;

      String InvoiceNo = 'ECI$newCounterValue';
      final paymentDetailsProvider = Provider.of<PaymentDetailsProvider>(
          context, listen: false);
      paymentDetailsProvider.addPaymentID(InvoiceNo);

      //Save the new Total number of payment count to the database
      await _totalpaymentscountdbReference.set(newCounterValue);
    }
  }

  Future<void> generateFoodOrderNo(BuildContext context) async {
    DatabaseEvent event = await _totalfoodorderscountdbReference.once();

    //String FoodOrderId = 'FO0';

    if (event.snapshot.value != null) {
      int currentCounterValue = event.snapshot.value as int;
      int newCounterValue = currentCounterValue + 1;

      String FoodOrderId = 'FO$newCounterValue';
      final foodDetailsProvider = Provider.of<FoodItemsDetailsProvider>(
          context, listen: false);
      foodDetailsProvider.addFoodOrderID(FoodOrderId);

      //Save the new Total number of food order count to the database
      await _totalfoodorderscountdbReference.set(newCounterValue);
    }
  }

  Future<void> generateReservationId(BuildContext context) async {
    //Get the Total No Of Reservation count from the database and generate the new reservation ID
    DatabaseEvent event = await _totalreservationcountdbReference.once();

    //String ReservationId = 'R0';

    if (event.snapshot.value != null) {
      int currentCounterValue = event.snapshot.value as int;
      int newCounterValue = currentCounterValue + 1;

      String ReservationId = 'R$newCounterValue';
      final reservationDetailsProvider = Provider.of<JourneyDetailsProvider>(context, listen: false);
      reservationDetailsProvider.addReservationID(ReservationId);
      print(reservationDetailsProvider.reservationid);

      //Save the new Total number of reservation count to the database
      await _totalreservationcountdbReference.set(newCounterValue);
    }
  }
//Generate return reservation id
Future<void> generateReturnReservationId(BuildContext context) async {
  //Get the Total No Of Reservation count from the database and generate the new reservation ID
  DatabaseEvent event = await _totalreservationcountdbReference.once();

  //String ReservationId = 'R0';

  if (event.snapshot.value != null) {
    int currentCounterValue = event.snapshot.value as int;
    int newCounterValue = currentCounterValue + 1;

    String ReservationId = 'R$newCounterValue';
    final reservationDetailsProvider = Provider.of<ReturnJourneyDetailsProvider>(context, listen: false);
    reservationDetailsProvider.addReservationID(ReservationId);

    //Save the new Total number of reservation count to the database
    await _totalreservationcountdbReference.set(newCounterValue);
  }
}

  // final fooditemsdetailsprovider = Provider.of<FoodItemsDetailsProvider>(context, listen: false);
  // String? foodorderstatus = fooditemsdetailsprovider.foodorderstatus;
  //
  // await generatePaymentinvoiceno(context);
  // await generateReservationId(context);
  //
  // if (foodorderstatus != null){
  //   await generateFoodOrderNo(context);
  // }
