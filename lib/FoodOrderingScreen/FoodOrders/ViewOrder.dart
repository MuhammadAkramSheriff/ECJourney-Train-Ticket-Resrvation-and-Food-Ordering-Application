import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/Journey Model/JourneyDetailsProvider.dart';
import '../../SearchTrainScreen/SearchTrainScreenResources/executeOverLay.dart';

class ViewOrderScreen extends StatefulWidget {

  final String orderNo;
  ViewOrderScreen({required this.orderNo});

  @override
  _ViewOrderScreenState createState() => _ViewOrderScreenState();
}

class _ViewOrderScreenState extends State<ViewOrderScreen> {

  List<String> foodItems = [];
  String? reservationid;
  int? totalAmount;

  final DatabaseReference reference = FirebaseDatabase.instance.ref().child('Food Orders');
//function to fetch food order items
  Future<void> fetchItems() async {
    final event = await reference
        .child(widget.orderNo) //fetch using orderNo
        .once();

    // Handle the event
    if (event.snapshot.value != null &&
        event.snapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;

      foodItems = List<String>.from(data['Item']);
      reservationid = data['Reservation ID'];
      totalAmount = data['Total Amount'];
      print(data['Reservation ID']);
      print(totalAmount);
    }
  }

  @override
  void initState() {
    super.initState();
  }


    @override
    Widget build(BuildContext context) {
    //return futurebuilder to build from fetchItems function
      return FutureBuilder(
          future: fetchItems(),
          builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  showOverlay(context);
                },
                child: Icon(Icons.arrow_back),
              ),
              title: const Text(
                "Ordered Foods",
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
                        Text('Order No: ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(' ${widget.orderNo}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Items',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.start,
                    ),

                    for (String item in foodItems)
                      Text(
                        item.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.end,
                      ),

                    Divider(),
                    Row(
                      children: [
                        Text(
                          'Total Amount:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const Spacer(),
                        Text(
                          'LKR ${totalAmount.toString()}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),

                    // for (Map<String, dynamic> item in foodProvider.items)
                    //   Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       SizedBox(height: 3),
                    //       Row(
                    //         children: [
                    //           Text(
                    //             '${item['Item no'].toString()}',
                    //             style: TextStyle(
                    //               fontSize: 14,
                    //               fontWeight: FontWeight.w300,
                    //               color: Colors.black,
                    //             ),
                    //             textAlign: TextAlign.end,
                    //           ),
                    //           Text(
                    //             ' ${item['Item Name'].toString()}',
                    //             style: TextStyle(
                    //               fontSize: 14,
                    //               fontWeight: FontWeight.w300,
                    //               color: Colors.black,
                    //             ),
                    //             textAlign: TextAlign.end,
                    //           ),
                    //           Text(
                    //             'x ${item['Count'].toString()}',
                    //             style: TextStyle(
                    //               fontSize: 14,
                    //               fontWeight: FontWeight.w300,
                    //               color: Colors.black,
                    //             ),
                    //             textAlign: TextAlign.end,
                    //           ),
                    //           const Spacer(),
                    //           Text(
                    //             'LKR ${item['Item Price'].toString()}',
                    //             style: TextStyle(
                    //               fontSize: 14,
                    //               fontWeight: FontWeight.w300,
                    //               color: Colors.black,
                    //             ),
                    //             textAlign: TextAlign.end,
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // Divider(),
                    // Row(
                    //   children: [
                    //     Text(
                    //       'Total',
                    //       style: TextStyle(
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w400,
                    //         color: Colors.black,
                    //       ),
                    //       textAlign: TextAlign.end,
                    //     ),
                    //     const Spacer(),
                    //     Text(
                    //       'LKR ${paymentdetailsprovider.totalfoodprice}',
                    //       style: TextStyle(
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w300,
                    //         color: Colors.black,
                    //       ),
                    //       textAlign: TextAlign.end,
                    //     ),
                    //   ],
                    // ),
                  ]
              )
              ),
            ),
          );
        }else {
          return Scaffold(
            body: Container(),
          );
        }
      }
      );
    }
  }
