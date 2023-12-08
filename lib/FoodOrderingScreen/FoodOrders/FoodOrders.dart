import 'package:ecjourney/FoodOrderingScreen/FoodOrders/ViewOrder.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/Journey Model/JourneyDetailsProvider.dart';

class FoodOrdersScreen extends StatefulWidget {
  @override
  _FoodOrdersScreenState createState() => _FoodOrdersScreenState();
}

class _FoodOrdersScreenState extends State<FoodOrdersScreen> {
  @override
  void initState() {
    super.initState();
  }

  // String? reservationid;
  //
  // void getReservationID() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   reservationid = prefs.getString('Reservation ID');
  // }

  @override
  Widget build(BuildContext context) {
    //getReservationID();
    final journeydetailsprovider = Provider.of<JourneyDetailsProvider>(context, listen: false);
    String? reservationid = journeydetailsprovider.reservationid;
    print(reservationid);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Food Order",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.cyan[500],
      ),
      body: StreamBuilder<DatabaseEvent>(
        //Fetch Food Order by reservation ID from database
        stream: FirebaseDatabase.instance
            .ref()
            .child('Food Orders')
            .orderByChild('Reservation ID')
            .equalTo(reservationid)
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasError || !snapshot.hasData || snapshot.data?.snapshot.value == null) {
              return Text('Error fetching data or no data available');
            } else {
              Map<dynamic, dynamic> data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
              List<dynamic> orders = data.values.toList();
              print(orders);

              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final foodorders = orders[index];
                  final orderKey = data.keys.toList()[index];
                  print(' item: $orderKey');

                  String orderNo = foodorders['Reservation ID'];
                  // String categoryname = itemcategory['Item Category Name'];
                  // int price  = itemcategory['Price'];
                  // String description = itemcategory['Description'];

                  return GestureDetector(
                    onTap: () async {
                      //Naviagte to View Order Screen on Tap
                      Navigator.push(context, MaterialPageRoute(builder: (_) =>
                          ViewOrderScreen(orderNo: orderKey)));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[150],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.cyan),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                ' Order No',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                ' $orderKey',
                                style: TextStyle(fontSize: 17, color: Colors.green, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (_) =>
                                      ViewOrderScreen(orderNo: orderKey)));
                                },
                              ),
                            ],
                          ),
                          Text(
                            ' Reservation ID: $orderNo',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
