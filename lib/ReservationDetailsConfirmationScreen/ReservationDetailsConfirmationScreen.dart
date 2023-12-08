import 'package:ecjourney/SeatSelectionScreen/SelectSeatFunctions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/scheduler.dart';

import '../FinalInsertionIntoDatabase/FoodOrderConfirmation.dart';
import '../FoodOrderingScreen/FoodItemsModel.dart';
import '../Models/Journey Model/JourneyDetailsProvider.dart';
import '../Payment/PayPalCheckout.dart';
import '../Payment/PaymentModel.dart';
import '../Payment/RecieptScreen/recieptScreenForFoodOrder.dart';
import '../Payment/RecieptScreen/recieptScreenForReservation.dart';
import '../Payment/savePaymentInDatabase.dart';
import '../SearchTrainScreen/SearchTrain.dart';
import '../SeatSelectionScreen/SelectSeat.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

import '../callSaveInDatabase.dart';
import '../generateDatabaseIDs.dart';
import '../main.dart';

class ReservationDetailsConfirmation extends StatefulWidget {
  @override
  State<ReservationDetailsConfirmation> createState() =>
      _ReservationDetailsConfirmationState();
}

class _ReservationDetailsConfirmationState
    extends State<ReservationDetailsConfirmation> {
  // Future<Map<String, dynamic>?> fetchData() async {
  //   JourneyDataStorage journeyDataStorage = JourneyDataStorage();
  //   Map<String, dynamic>? journeyData = await journeyDataStorage.getJourneyDetails();
  //   return journeyData;
  // }

  NavigatorService doPayment = NavigatorService();

  double totalAmount = 0;
  int totalAmountForTicket = 0;

  Future<void> finalAmountCalculate(BuildContext context) async {
    final paymentdetailsprovider =
        Provider.of<PaymentDetailsProvider>(context, listen: false);
    final int totalticketamount = paymentdetailsprovider.totalticketamount;
    final int returntotalticketamount =
        paymentdetailsprovider.returntotalticketamount;
    final int totalfoodprice = paymentdetailsprovider.totalfoodprice;
    double serviceCharge = 0;

    final fooditemdetailsprovider =
        Provider.of<FoodItemsDetailsProvider>(context, listen: false);
    String? foodorderstatus = fooditemdetailsprovider.foodorderstatus;

    if (foodorderstatus != 'Order') {
      serviceCharge =
          ((totalticketamount + returntotalticketamount + totalfoodprice) *
              8 /
              100);
    } else {
      serviceCharge =
          ((totalticketamount + returntotalticketamount + totalfoodprice) *
              4 /
              100);
    }

    totalAmountForTicket =
        (totalticketamount + returntotalticketamount + totalfoodprice);
    totalAmount =
        ((totalticketamount + returntotalticketamount + totalfoodprice) +
            serviceCharge);

    paymentdetailsprovider.addServiceCharge(serviceCharge);
    paymentdetailsprovider.addTotalAmount(totalAmount);
  }

  @override
  void initState() {
    super.initState();
    finalAmountCalculate(context);
  }

  @override
  Widget build(BuildContext context) {
    final paymentdetailsprovider =
        Provider.of<PaymentDetailsProvider>(context, listen: false);
    final fooddetailsdetailsprovider =
        Provider.of<FoodItemsDetailsProvider>(context, listen: false);
    final returndetailsprovider =
        Provider.of<ReturnJourneyDetailsProvider>(context, listen: false);
    String foodorderstatus = fooddetailsdetailsprovider.foodorderstatus;
    String? trainno = returndetailsprovider.trainno;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Confirm",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.cyan[500],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        //height: double.infinity,
        child: Column(children: [
          //Display Train Details
          Consumer<JourneyDetailsProvider>(
            builder: (context, journeyProvider, _) {
              if (journeyProvider == null) {
                return CircularProgressIndicator();
              } else {
                return Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Journey Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              'From:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const Spacer(),
                            Text(
                              journeyProvider.from,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'To:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const Spacer(),
                            Text(
                              journeyProvider.to,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'Departure Date:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const Spacer(),
                            Text(
                              journeyProvider.date,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        //Display return train details
                        //if return train no is not null
                        if (trainno != null)
                          Row(
                            children: [
                              Text(
                                'Return Date:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              const Spacer(),
                              Text(
                                returndetailsprovider.date,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Passenger Count:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const Spacer(),
                            Text(
                              journeyProvider.passengercount.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ],
                    ));
              }
            },
          ),

          //Display Train and price details
          Visibility(
            visible: foodorderstatus != 'Order',
            child: Consumer<JourneyDetailsProvider>(
              builder: (context, journeyProvider, _) {
                if (journeyProvider == null) {
                  return CircularProgressIndicator();
                } else {
                  return Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Departure: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                '  ${journeyProvider.date}  ${journeyProvider.depart}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                journeyProvider.trainno,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                ' ${journeyProvider.from} - ${journeyProvider.to} ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                          Divider(),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                journeyProvider.ticketprice.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              const Spacer(),
                              Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                              Text(
                                journeyProvider.passengercount.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.end,
                              ),
                              const Spacer(),
                              Text(
                                paymentdetailsprovider.totalticketamount
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        ],
                      ));
                }
              },
            ),
          ),

          //Display Return train details (if aplicable)
          Visibility(
            visible: trainno != null,
            child: Consumer<ReturnJourneyDetailsProvider>(
              builder: (context, journeyProvider, _) {
                if (journeyProvider == null) {
                  return CircularProgressIndicator();
                } else {
                  return Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Return: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                '  ${journeyProvider.date}  ${journeyProvider.depart}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                journeyProvider.trainno.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                ' ${journeyProvider.from} - ${journeyProvider.to} ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                          Divider(),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                journeyProvider.ticketprice.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              const Spacer(),
                              Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                              Text(
                                journeyProvider.passengercount.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.end,
                              ),
                              const Spacer(),
                              Text(
                                paymentdetailsprovider.returntotalticketamount
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        ],
                      ));
                }
              },
            ),
          ),

          //Display Food order details (if applicable)
          Visibility(
            visible: foodorderstatus != 'No Order',
            child: Consumer<FoodItemsDetailsProvider>(
              builder: (context, foodProvider, _) {
                if (foodProvider == null) {
                  return CircularProgressIndicator();
                } else {
                  return Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Food',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Your Items',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            for (Map<String, dynamic> item
                                in foodProvider.items)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Text(
                                        '${item['Item no'].toString()}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                      Text(
                                        ' ${item['Item Name'].toString()}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                      Text(
                                        ' x ${item['Count'].toString()}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                      const Spacer(),
                                      Text(
                                        'LKR ${item['Item Price'].toString()}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            Divider(),
                            Row(
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                                const Spacer(),
                                Text(
                                  'LKR ${paymentdetailsprovider.totalfoodprice}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                          ]));
                }
              },
            ),
          ),

          //Display payment details
          Consumer<PaymentDetailsProvider>(
            builder: (context, paymentProvider, _) {
              if (paymentProvider == null) {
                return CircularProgressIndicator();
              } else {
                return Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            if (foodorderstatus != 'Making Order')
                              Text(
                                'Sub Total',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            const Spacer(),
                            if (foodorderstatus != 'Order')
                              Text(
                                totalAmountForTicket.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            if (foodorderstatus == 'Order')
                              Text(
                                paymentProvider.totalfoodprice.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.end,
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              'Service Charge%',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const Spacer(),
                            if (foodorderstatus != 'Order')
                              Text(
                                '8',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            if (foodorderstatus == 'Order')
                              Text(
                                '4',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.end,
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              'Service Charge',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const Spacer(),
                            Text(
                              paymentProvider.servicecharge.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              'Total Amount',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const Spacer(),
                            Text(
                              paymentProvider.totalamount.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ],
                    ));
              }
            },
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () async {
                  // Future<void> saveInDatabase() async {
                  //   await savePayment(context);
                  //   await saveSelectedSeats(context);
                  //
                  //   final fooditemsdetailsprovider = Provider.of<FoodItemsDetailsProvider>(context, listen: false);
                  //   String? foodorderstatus = fooditemsdetailsprovider.foodorderstatus;
                  //
                  //   if (foodorderstatus != null){
                  //     await saveFoodOrder(context);
                  //     await savePayment(context);
                  //   }
                  //
                  // }
                  // saveInDatabase();

                  await finalAmountCalculate(context);

                  // //try {
                  // final fooditemsdetailsprovider =
                  //     Provider.of<FoodItemsDetailsProvider>(context,
                  //         listen: false);
                  // String? foodorderstatus =
                  //     fooditemsdetailsprovider.foodorderstatus;
                  // if (foodorderstatus == 'Order') {
                  //   print('inside foodorderstatus condition in checkout');
                  //   await saveInDatabaseForFoodOrder(context);
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (_) => RecieptScreenForFoodOrder()));
                  // } else {
                  //   await saveInDatabaseForReservation(context);
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (_) =>
                  //               RecieptScreenForReservation(newReciept: true)));
                  // }

                  // Navigator.push(context,
                  //   MaterialPageRoute(builder: (BuildContext context) => RecieptScreen()),
                  // );
                  //Navigator.pushNamed(context, '/recieptScreen');
                  // } catch (e) {
                  //   print('Error navigating to SearchTrain: $e');
                  // }
                  doPayment.navigatetoPayPalScreen(context, totalAmount);

                  // Map<String, dynamic>? journeyData = await fetchData();
                  // print(journeyData?['trainNo']);
                  // print(journeyData?['index']);
                  // final journeyDetailsProvider = Provider.of<JourneyDetailsProvider>(context, listen: false);
                  // String trainno = journeyDetailsProvider.trainno;

                  // final prefs = await SharedPreferences.getInstance();
                  // final reservationid = prefs.getString('Reservation ID');
                  //
                  // if (reservationid != null){
                  //   savefoodorder.saveFoodOrder(context);
                  // }else{
                  //   savereservation.saveSelectedSeats(context);
                  //   savefoodorder.saveFoodOrder(context);
                  // }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan[500],
                  minimumSize: Size(MediaQuery.of(context).size.width, 50),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
                child: Text(
                  "Confirm",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
// static final String tokenizationKey = 'sandbox_8hxpnkht_kzdtzv2btm4p7s5j';
//
// void showNonce(context, BraintreePaymentMethodNonce nonce) {
//   showDialog(
//     context: context,
//     builder: (_) => AlertDialog(
//       title: Text('Payment method nonce:'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           Text('Nonce: ${nonce.nonce}'),
//           SizedBox(height: 16),
//           Text('Type label: ${nonce.typeLabel}'),
//           SizedBox(height: 16),
//           Text('Description: ${nonce.description}'),
//         ],
//       ),
//     ),
//   );
// }
//
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: const Text('Braintree example app'),
//     ),
//     body: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           ElevatedButton(
//             onPressed: () async {
//               var request = BraintreeDropInRequest(
//                 tokenizationKey: tokenizationKey,
//                 collectDeviceData: true,
//                 googlePaymentRequest: BraintreeGooglePaymentRequest(
//                   totalPrice: '4.20',
//                   currencyCode: 'USD',
//                   billingAddressRequired: false,
//                 ),
//                 applePayRequest: BraintreeApplePayRequest(
//                     currencyCode: 'USD',
//                     supportedNetworks: [
//                       ApplePaySupportedNetworks.visa,
//                       ApplePaySupportedNetworks.masterCard,
//                       // ApplePaySupportedNetworks.amex,
//                       // ApplePaySupportedNetworks.discover,
//                     ],
//                     countryCode: 'US',
//                     merchantIdentifier: '',
//                     displayName: '',
//                     paymentSummaryItems: []
//                 ),
//                 paypalRequest: BraintreePayPalRequest(
//                   amount: '4.20',
//                   displayName: 'Example company',
//                 ),
//                 cardEnabled: true,
//               );
//               final result = await BraintreeDropIn.start(request);
//               if (result != null) {
//                 showNonce(context, result.paymentMethodNonce);
//               }
//             },
//             child: Text('LAUNCH NATIVE DROP-IN'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final request = BraintreeCreditCardRequest(
//                 cardNumber: '4111111111111111',
//                 expirationMonth: '12',
//                 expirationYear: '2021',
//                 cvv: '123',
//               );
//               final result = await Braintree.tokenizeCreditCard(
//                 tokenizationKey,
//                 request,
//               );
//               if (result != null) {
//                 showNonce(context, result);
//               }
//             },
//             child: Text('TOKENIZE CREDIT CARD'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final request = BraintreePayPalRequest(
//                 amount: null,
//                 billingAgreementDescription:
//                 'I hereby agree that flutter_braintree is great.',
//                 displayName: 'Your Company',
//               );
//               final result = await Braintree.requestPaypalNonce(
//                 tokenizationKey,
//                 request,
//               );
//               if (result != null) {
//                 showNonce(context, result);
//               }
//             },
//             child: Text('PAYPAL VAULT FLOW'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final request = BraintreePayPalRequest(amount: '13.37');
//               final result = await Braintree.requestPaypalNonce(
//                 tokenizationKey,
//                 request,
//               );
//               if (result != null) {
//                 showNonce(context, result);
//               }
//             },
//             child: Text('PAYPAL CHECKOUT FLOW'),
//           ),
//         ],
//       ),
//     ),
//   );
// }
}
