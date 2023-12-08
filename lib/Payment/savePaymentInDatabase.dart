import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../FoodOrderingScreen/FoodItemsModel.dart';
import '../Models/Journey Model/JourneyDetailsProvider.dart';
import 'PaymentModel.dart';



//DatabaseReference _trainscheduledbReference = FirebaseDatabase.instance.ref().child('Train Schedule');
DatabaseReference _paymentdbReference = FirebaseDatabase.instance.ref().child('Payments');

  Future<void> savePayment(BuildContext context) async {
    //Retrieve the the Payment details stored in the provider
    final paymentDetailsProvider = Provider.of<PaymentDetailsProvider>(context, listen: false);
    String InvoiceNo = paymentDetailsProvider.paymentid;
    double servicecharge = paymentDetailsProvider.servicecharge;
    double totalamount = paymentDetailsProvider.totalamount;

    //Calculate the total amounts
    int? totalticketamount;
    int? returntotalticketamount;
    int? totalfoodprice;
    if (paymentDetailsProvider.totalticketamount > 0){
      totalticketamount =  paymentDetailsProvider.totalticketamount;
    }
    if (paymentDetailsProvider.returntotalticketamount > 0){
      returntotalticketamount =  paymentDetailsProvider.returntotalticketamount;
    }
    if (paymentDetailsProvider.totalfoodprice > 0){
      totalfoodprice = paymentDetailsProvider.totalfoodprice;
    }

    //Get the current reservation ID
    final prefs = await SharedPreferences.getInstance();
    String? reservationid = prefs.getString('Reservation ID');

    final returnjourneydetailsprovider = Provider.of<ReturnJourneyDetailsProvider>(context, listen: false);
    String? trainno = returnjourneydetailsprovider.trainno;
    String? returnReservationId;

    //Check if there is return ticket reservation
    if (trainno!= null){
      returnReservationId = returnjourneydetailsprovider.reservationid;
    }

    final foodDetailsProvider = Provider.of<FoodItemsDetailsProvider>(context, listen: false);
    String foodorderstatus = foodDetailsProvider.foodorderstatus;
    String? foodorderid;

    if (foodorderstatus != 'No Order') {
      foodorderid = foodDetailsProvider.foodorderid;
    }

    //Store the retreived data from the provider into the Food Order database
    DatabaseReference paymentF = _paymentdbReference;

    //Save the details under generated Invoice No as child node
    paymentF.child(InvoiceNo).set({
      'Reservation ID' : reservationid,
      'Reservation ID (Return)' : returnReservationId,
      'Food Order ID': foodorderid,
      'Total Ticket Amount' : totalticketamount,
      'Total Ticket Amount(Return)': returntotalticketamount,
      'Service Charge' : servicecharge,
      'Total Amount' : totalamount,
      'Total Food Price' : totalfoodprice
    }).then((value) async {

      //After successfully saving the payment details into the database

      print('Invoice Saved');

    }).onError((error, stackTrace){
      print((error, stackTrace));
    });

}