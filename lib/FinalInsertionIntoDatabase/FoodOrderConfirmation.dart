import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../FoodOrderingScreen/FoodItemsModel.dart';
import '../Models/Journey Model/JourneyDetailsProvider.dart';
import '../Payment/PaymentModel.dart';



DatabaseReference _foodorderdbReference = FirebaseDatabase.instance.ref().child('Food Orders');

 Future<void> saveFoodOrder(BuildContext context) async {
      //Get the current Reservation ID
      final prefs = await SharedPreferences.getInstance();
      String? reservationid = prefs.getString('Reservation ID');

      //Get the payment invoice no
      final paymentDetailsProvider = Provider.of<PaymentDetailsProvider>(context, listen: false);
      String invoiceno = paymentDetailsProvider.paymentid;

      //Retrieve the the Food order details stored in the provider
      final foodDetailsProvider = Provider.of<FoodItemsDetailsProvider>(context, listen: false);
      String FoodOrderId = foodDetailsProvider.foodorderid;
      String trainNo = foodDetailsProvider.trainno;
      List<String> itemnameandno = [];
      int totalamount = foodDetailsProvider.totalamount;

      //Iterate each food items in the List
      for (Map<String, dynamic> itemMap in foodDetailsProvider.items) {
        itemnameandno.add('${itemMap['Item no']} ${itemMap['Item Name']}(LKR ${itemMap['Item Price']}) x '
            '${itemMap['Count']} = LKR ${itemMap['Total Amount']}');
      }

      //Store the retreived data from the provider into the Food Order database
      DatabaseReference foodorderF = _foodorderdbReference;

      //Save the order under the Food Order Id as child node
      foodorderF.child(FoodOrderId).set({
        'Reservation ID' : reservationid,
        'Invoice No': invoiceno,
        'Train No': trainNo,
        'Item' : itemnameandno,
        'Total Amount' : totalamount
      }).then((value) async {

        //After successfully saving the food details into the database

        print(' food order Success');

      }).onError((error, stackTrace){
        print((error, stackTrace));
      });

  }
