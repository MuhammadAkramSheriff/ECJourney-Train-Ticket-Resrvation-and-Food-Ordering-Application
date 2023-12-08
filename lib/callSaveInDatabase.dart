import 'package:ecjourney/generateDatabaseIDs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../FinalInsertionIntoDatabase/FoodOrderConfirmation.dart';
import '../../FoodOrderingScreen/FoodItemsModel.dart';
import '../../Models/Journey Model/JourneyDetailsProvider.dart';
import '../../SeatSelectionScreen/SelectSeatFunctions.dart';
import 'Payment/savePaymentInDatabase.dart';


Future<void> saveInDatabaseForReservation(BuildContext context) async {

  final fooditemsdetailsprovider = Provider.of<FoodItemsDetailsProvider>(context, listen: false);
  String? foodstatus = fooditemsdetailsprovider.foodorderstatus;

  await generateReservationId(context);
  await generatePaymentinvoiceno(context);

  final returnjourneydetailsprovider = Provider.of<ReturnJourneyDetailsProvider>(context, listen: false);
  String? trainno = returnjourneydetailsprovider.trainno;

  if (trainno!= null){
    await generateReturnReservationId(context);
  }

  if (foodstatus == 'Pre Order') {
    await generateFoodOrderNo(context);
    await saveFoodOrder(context);
  }

  await savePayment(context);
    await saveReservation(context);
  // }
}

Future<void> saveInDatabaseForFoodOrder(BuildContext context) async {
  await generatePaymentinvoiceno(context);
  await generateFoodOrderNo(context);
  await saveFoodOrder(context);
  await savePayment(context);

}