import 'package:ecjourney/Payment/sendEmail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../FinalInsertionIntoDatabase/FoodOrderConfirmation.dart';
import '../FoodOrderingScreen/FoodItemsModel.dart';
import '../SeatSelectionScreen/SelectSeatFunctions.dart';
import '../callSaveInDatabase.dart';
import 'RecieptScreen/recieptScreenForFoodOrder.dart';
import 'RecieptScreen/recieptScreenForReservation.dart';

class NavigatorService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // static GlobalKey<NavigatorState> getGlobalKey() {
  //   return navigatorKey;
  // }


  void navigatetoPayPalScreen(BuildContext context, double totalamount) {

    //convert the total amount in USD
    double totalamountinUSD = double.parse((totalamount / 183.69).toStringAsFixed(2));

    final fooditemsdetailsprovider = Provider.of<FoodItemsDetailsProvider>(context, listen: false);
    String? foodorderstatus = fooditemsdetailsprovider.foodorderstatus;

    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) =>
          PaypalCheckout(
            sandboxMode:
            true,
            clientId: "AbNKip4PM3RnMMvvRbBejmUPdy8Nk__khHsac5iH0te-Cr6H18nREOv1HN86RpXrQ9TjDn5jaahQfNUS",
            secretKey: "EB62C1HO2mNQRrk_gTqjvK5taJn9PuRW74uhcBeb6zN_s5BZvZfc5mGz5zVHVT5gX9yUy5uO98yOhkpS",
            returnURL: "www.paypal.com", //https://b2b-go.com/successpaypaltest.php
            cancelURL: "www.paypal.com",
            transactions: [
              {
                "amount": {
                  "total": '$totalamountinUSD',
                  "currency": "USD",
                  "details": {
                    "subtotal": '0',
                    "shipping": '0',
                    "shipping_discount": 0
                  }
                },
                "description": "The payment transaction description.",
                "note_to_payer": "Short note to the payer.",
                "payment_options": {
                  "allowed_payment_method":
                      "INSTANT_FUNDING_SOURCE"
                },
                // "item_list": {
                //   "items": [
                //     {
                //       "name": "Apple",
                //       "quantity": 4,
                //       "price": '200',
                //       "currency": "USD"
                //     },
                //     {
                //       "name": "Pineapple",
                //       "quantity": 2,
                //       "price": '200',
                //       "currency": "USD"
                //     }
                //   ],
                // }
              }
            ],
            note: "Contact us for any questions on your order.",
            //If the payment is success
            onSuccess: (Map params) async {
              print("onSuccess: $params");
              try {
                if (foodorderstatus == 'Order'){
                  print('inside foodorderstatus condition in checkout');
                  navigatorKey.currentState?.pushNamed('/recieptScreenForFoodOrder');
                }else{
                  navigatorKey.currentState?.pushNamed('/recieptScreenForReservation');
                  // sendEmail(name: 'Muhammad', fromemail: 'muhammedakram2003@gmail.com', toemail: 'decoffins@gmail.com',
                  //     subject: 'Reservation Success', message: 'Your reservation is success');
                }


                // Navigator.push(context,
                //   MaterialPageRoute(builder: (BuildContext context) => RecieptScreen()),
                // );
                //Navigator.pushNamed(context, '/recieptScreen');
              } catch (e) {
                print('Error navigating to SearchTrain: $e');
              }
            },
            //If any error
            onError: (error) {
              print("onError: $error");
              Navigator.pop(context);
            },
            //When cancelled
            onCancel: () {
              print('cancelled:');
            },
          ),
    ));
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //       builder: (BuildContext context) =>
    //           UsePaypal(
    //               sandboxMode: true,
    //               clientId:
    //               "AQc6B8TQ6tZU7PNfOn9OuAs1sF-11Equ8yzwgXQNmeUGIl-ot2RtcbbhPVI0k58Gye6XWAooJS8OBe_1",
    //               secretKey:
    //               "EOyfrYoMHB1KoczepDh_P2p1Ymw_aUYwZmpLdKiNqpAAQGd0KGehZKXEU9oXmERYd2C-k2g1FV0K7cCe",
    //               returnURL: "https://samplesite.com/return",
    //               cancelURL: "https://samplesite.com/cancel",
    //               transactions: const [
    //                 {
    //                   "amount": {
    //                     "total": '10.12',
    //                     "currency": "USD",
    //                     "details": {
    //                       "subtotal": '10.12',
    //                       "shipping": '0',
    //                       "shipping_discount": 0
    //                     }
    //                   },
    //                   "description":
    //                   "The payment transaction description.",
    //                   // "payment_options": {
    //                   //   "allowed_payment_method":
    //                   //       "INSTANT_FUNDING_SOURCE"
    //                   // },
    //                   "item_list": {
    //                     "items": [
    //                       {
    //                         "name": "A demo product",
    //                         "quantity": 1,
    //                         "price": '10.12',
    //                         "currency": "USD"
    //                       }
    //                     ],
    //
    //                     // shipping address is not required though
    //                     // "shipping_address": {
    //                     //   "recipient_name": "Jane Foster",
    //                     //   "line1": "Travis County",
    //                     //   "line2": "",
    //                     //   "city": "Austin",
    //                     //   "country_code": "US",
    //                     //   "postal_code": "73301",
    //                     //   "phone": "+00000000",
    //                     //   "state": "Texas"
    //                     // },
    //                   }
    //                 }
    //               ],
    //               note: "Contact us for any questions on your order.",
    //               onSuccess: (Map params) async {
    //                 print("onSuccess: $params");
    //                 Navigator.pop(context);
    //                 // if (navigatorKey.currentContext != null) {
    //                 //   navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => ReceiptScreen()));
    //                 // }
    //                 // SchedulerBinding.instance.addPostFrameCallback((_) {
    //                 //   Navigator.push(
    //                 //       context,
    //                 //       MaterialPageRoute(builder: (_) => RecieptScreen()));
    //                 // });
    //               },
    //               onError: (error) {
    //                 print("onError: $error");
    //               },
    //               onCancel: (params) {
    //                 print('cancelled: $params');
    //               }),
    //     ),
    //   );

  }
}

