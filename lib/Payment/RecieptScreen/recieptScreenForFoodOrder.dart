import 'package:ecjourney/generateDatabaseIDs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../FinalInsertionIntoDatabase/FoodOrderConfirmation.dart';
import '../../FoodOrderingScreen/FoodItemsModel.dart';
import '../../SeatSelectionScreen/SelectSeatFunctions.dart';
import '../savePaymentInDatabase.dart';


class RecieptScreenForFoodOrder extends StatefulWidget {

  @override
  State<RecieptScreenForFoodOrder> createState() => _RecieptScreenForFoodOrderState();
}

class _RecieptScreenForFoodOrderState extends State<RecieptScreenForFoodOrder> {

  String? FoodOrderID;
  List<Map<String, dynamic>> items = [];

  //Get the required details from the provider
  Future<void> getData() async {
    print('inside getData in food order');
    final foodDetailsProvider =
    Provider.of<FoodItemsDetailsProvider>(context, listen: false);
    FoodOrderID = foodDetailsProvider.foodorderid;
    items = foodDetailsProvider.items;
    print('id: $FoodOrderID items in: ${foodDetailsProvider.items}');

    //Get the food order details
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 25.0),
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.green),
                color: Colors.green[200],
              ),
              child: Center(
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(
                      Icons.check_circle,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Thank You For Ordering!',
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.grey.withOpacity(0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      'FOOD ORDER NO',
                      style:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Consumer<FoodItemsDetailsProvider>(
                      builder: (context, foodDetailsProvider, child) {
                        return Text(
                          //Display food order no
                          '${foodDetailsProvider.foodorderid}',
                          style: TextStyle(fontSize: 16),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 10),
                  Consumer<FoodItemsDetailsProvider>(
                    builder: (context, foodDetailsProvider, child) {
                      return Column(
                        children: [
                          //Iterate through each order items
                          for (Map<String, dynamic> item
                          in foodDetailsProvider.items)
                            Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${item['Count']}x',//Display quantity
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(//Display Item no and anme
                                      ' ${item['Item no']} ${item['Item Name']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text( //Display item price
                                      ' LKR ${item['Item Price']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          Divider(),
                          Row(
                            children: [
                              Text(
                                'Total Amount',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              Text( //Display total amount
                                'LKR ${foodDetailsProvider.totalamount.toString()}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}