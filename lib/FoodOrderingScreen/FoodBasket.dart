import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/Journey Model/JourneyDetailsProvider.dart';
import '../PassengerDetailsConfirmationScreen/PassengerDetailsConfirmationScreen.dart';
import '../Payment/PaymentModel.dart';
import '../SessionTracking.dart';
import 'FoodItemsModel.dart';
import 'FoodMenuScreen.dart';

class FoodBasket extends StatefulWidget {
  final String? status;

  FoodBasket({required this.status});

  @override
  _FoodBasket createState() => _FoodBasket();
}

class _FoodBasket extends State<FoodBasket> {


  Future<void> callFetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final reservationid = prefs.getString('Reservation ID');

    final fooditemsdetailsprovider =
        Provider.of<FoodItemsDetailsProvider>(context, listen: false);

    if (reservationid != null) {
      SessionTracking().fetchData(context, reservationid: reservationid);
      fooditemsdetailsprovider.addFoodOrderStatus('Order');
    } else {
      fooditemsdetailsprovider.addFoodOrderStatus('Pre Order');
      print('reservation id null in foodmenu screen');
    }
  }

  @override
  void initState() {
    super.initState();
    print(totalamount);
  }

  // void fetchDataForEachItem(List<String> itemNumbers) {
  //   final fooditemsdetailsprovider = Provider.of<FoodItemsDetailsProvider>(
  //       context, listen: false);
  //   List<String> foodbasket = fooditemsdetailsprovider.selectedFoodItems;
  //
  //   itemNumbers.forEach((itemNumber) {
  //     FirebaseDatabase.instance.ref().child('yourNode/$itemNumber')
  //         .once()
  //         .then((DatabaseEvent snapshot) {
  //       print("Data for item number $itemNumber: ${snapshot.value}");
  //     }).catchError((error) {
  //       print("Error fetching data for item number $itemNumber: $error");
  //     });
  //   });
  // }

  bool isHomeSelected = false;
  bool isBasketSelected = true;

  late String itemno;
  late String itemname;
  int itemCount = 1;
  int price = 0;
  int totalamount = 0;

  int subtotal = 0;

  @override
  Widget build(BuildContext context) {
    final fooditemsdetailsprovider =
        Provider.of<FoodItemsDetailsProvider>(context, listen: false);
    //Fetch and store the selected food items in the List
    List<String> foodbasket = fooditemsdetailsprovider.selectedFoodItems;
    print(foodbasket);

    List<Map<String, dynamic>> itemList = [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        height: double.infinity,
        child: Column(
          children: [
            if (foodbasket.isEmpty)
              Center(
                  child:
                  Column(
                    children: [
                      Text(
                        'No Any Item!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FoodMenuScreen(status: null)));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            fixedSize: Size(90, 40),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.black),
                            ),
                          ),
                          child: Text('Add Item'))
                    ],
                  ),
              ),

            Expanded(
              //Fetch and display each item details from the database
              child: ListView.builder(
                itemCount: foodbasket.length,
                itemBuilder: (context, index) {
                  String foodItem = foodbasket[index];
                  Map<String, dynamic> items = {};

                  return StreamBuilder<DatabaseEvent>(
                      stream: FirebaseDatabase.instance
                          .ref()
                          .child('Item Category')
                          .orderByChild('Item No')
                          .equalTo(foodItem)
                          .onValue,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          Map<dynamic, dynamic>? data = snapshot
                              .data?.snapshot.value as Map<dynamic, dynamic>?;

                          if (data != null) {
                            Map<dynamic, dynamic> item = data[foodItem];
                            if (item != null) {
                              itemno = item['Item No'];
                              itemname = item['Item Category Name'];
                              price = item['Price'];

                              itemCount = fooditemsdetailsprovider
                                      .itemCounts[itemname] ??
                                  0;

                              int totalamountofeachitem = price * itemCount;

                              //print('index: $index');
                              // if (index == 0) {
                              //   totalamount = 0;
                              //   itemList.clear();
                              // }
                              //increment the totalmount during iteration
                              totalamount += totalamountofeachitem;

                              // itemList.add(
                              //     '$itemno $itemname(LKR $price) x $itemCount = LKR $totalamountofeachitem');
                              // print('item list in $index: $itemList');

                              //Add all the items user selected with the details
                              //to the list
                              items.addAll({
                                'Item no': itemno,
                                'Item Name': itemname,
                                'Item Price': price,
                                'Count': itemCount,
                                'Total Amount': totalamountofeachitem
                              });
                              //Add the items in the list to the final List
                              itemList.add(items);

                              // int initialTotalAmount = totalamountofeachitem;
                              // totalamount = (totalamount + initialTotalAmount);
                              // print('each item: $totalamountofeachitem');
                              // print('total amount: $totalamount');

                              // // Create a map to represent the item
                              // Map<String, dynamic> currentItem = {
                              //   'Item No': itemno,
                              //   'Item Category Name': itemname,
                              //   'Price': price,
                              //   'Count': itemCount,
                              //   'TotalAmount': totalamountofeachitem,
                              // };

                              // Add the item to the list

                              //itemList.clear();

                              String localItemName = itemname;

                              //return the FoodItemWidget to display the items
                              return FoodItemWidget(
                                itemNo: itemno,
                                itemName: itemname,
                                itemCount: itemCount,
                                price: price,
                                totalAmountOfEachItem: totalamountofeachitem,
                                foodbasket: foodbasket,
                                totalamount: totalamount,
                                itemList: itemList,
                                onIncrement: () {
                                  setState(() {
                                    print(localItemName);
                                    //subtotal = totalamount;
                                    totalamount = 0;
                                    item.clear();
                                    itemList.clear();

                                    fooditemsdetailsprovider.incrementItemCount(localItemName);
                                    //_calculatetotalamount();
                                  });
                                },
                                onDecrement: () {
                                  setState(() {
                                    if (fooditemsdetailsprovider.itemCounts.containsKey(localItemName) &&
                                        fooditemsdetailsprovider.itemCounts[localItemName]! >
                                            1) {
                                      totalamount = 0;
                                      item.clear();
                                      itemList.clear();

                                      fooditemsdetailsprovider.decrementItemCount(localItemName);
                                      //_calculatetotalamount();
                                    } else {
                                      fooditemsdetailsprovider.removeSelectedFoodItems(foodItem);
                                      fooditemsdetailsprovider.removeItemCount(localItemName);
                                      fooditemsdetailsprovider.removeItem(localItemName);
                                      print('Deleted');
                                      setState(() {
                                        totalamount = 0;
                                        foodbasket.remove(foodItem);
                                      });
                                    }
                                  });
                                },
                              );
                            }
                          }
                          return Text('No data available');
                        }
                        return Text('No data available in streambuilder');
                      });
                },
              ),
            ),

            //To naviagte to food menu home screen
            if (widget.status != null && foodbasket.isEmpty)
              Wrap(
                runSpacing: 10,
                spacing: 10,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.white70,
                          width: 4.0,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //Navigate to home screen if icon is pressed
                            IconButton(
                              icon: Icon(Icons.home,
                                  color: isHomeSelected
                                      ? Colors.black
                                      : Colors.grey),
                              onPressed: () {
                                setState(() {
                                  isHomeSelected = true;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FoodMenuScreen(status: null)));
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.shopping_cart,
                                  color: isBasketSelected
                                      ? Colors.black
                                      : Colors.grey),
                              onPressed: () {
                                setState(() {
                                  isBasketSelected = true;
                                  isHomeSelected = false;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FoodBasket(status: 'From home')));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),

            if (foodbasket.isNotEmpty)
              Wrap(
                runSpacing: 10,
                spacing: 10,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(20.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey,
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Sub Total",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'LKR ${subtotal}',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        SizedBox(
                          height: 48,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan[500],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              //Store the final items to the provider
                              fooditemsdetailsprovider.addItems(itemList);
                              print(fooditemsdetailsprovider.items);

                              print('total: ${totalamount}');
                              //itemList.sort();
                              //final fooditemsdetailsprovider = Provider.of<FoodItemsDetailsProvider>(context, listen: false);

                              // if (widget.OrderCondition == 'ONjourney')
                              //
                              //
                              // if (widget.OrderCondition == 'While Reservation')

                              await callFetchData();
                              //String trainno = journeyProvider.trainno;

                              //fooditemsdetailsprovider.addTrainno(trainno);
                              //fooditemsdetailsprovider.addReservationID(reservationid ?? '');
                              //fooditemsdetailsprovider.addItemNameandNo(confirmedItems);
                              fooditemsdetailsprovider.addTotalAmount(totalamount);
                              //print(fooditemsdetailsprovider.itemNodNamePrice);

                              final paymentdetailsprovider =
                                  Provider.of<PaymentDetailsProvider>(context,
                                      listen: false);
                              paymentdetailsprovider
                                  .addTotalFoodPrice(totalamount);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          PassengerDetailsConfirmation(
                                              showDialog: false)));
                            },
                            child: const Text(
                              "Place Order",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            // if(foodbasket.isNotEmpty)
            //   return bottomWrapper(totalamount: totalamount, subtotal: subtotal, itemList: itemList),
          ],
        ),
      ),
    );
  }
}

class FoodItemWidget extends StatefulWidget {
  final String itemNo;
  final String itemName;
  final int itemCount;
  final int price;
  final List<String> foodbasket;
  final int totalAmountOfEachItem;
  final int totalamount;
  final List<Map<String, dynamic>> itemList;
  final Function() onIncrement;
  final Function() onDecrement;

  FoodItemWidget({
    required this.itemNo,
    required this.itemName,
    required this.itemCount,
    required this.price,
    required this.foodbasket,
    required this.totalAmountOfEachItem,
    required this.totalamount,
    required this.itemList,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  _FoodItemWidgetState createState() => _FoodItemWidgetState();
}

class _FoodItemWidgetState extends State<FoodItemWidget> {
  @override
  Widget build(BuildContext context) {
    //Get the seat no from the proivder
    final journeydetailsprovider =
        Provider.of<JourneyDetailsProvider>(context, listen: false);
    String seatno = journeydetailsprovider.selectedSeats.join(',');

    print('Building FoodItemWidget for ${widget.itemName}');
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color.fromRGBO(188, 188, 188, 1.0),
            width: 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  ' ${widget.itemName}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.cyan),
                  ),
                  height: 40,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: widget.itemCount > 1
                            ? Icon(Icons.remove)
                            : Icon(Icons.delete),
                        onPressed: widget.onDecrement,
                      ),
                      Text(
                        '${widget.itemCount}',
                        style: TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: widget.onIncrement,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              ' LKR ${widget.totalAmountOfEachItem}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Text(
              ' Deliver to Seat $seatno',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
//
// class bottomWrapper extends StatefulWidget {
//   final int totalamount;
//   final int subtotal;
//   final List<Map<String, dynamic>> itemList;
//
//   bottomWrapper({
//     required this.totalamount,
//     required this.subtotal,
//     required this.itemList,
//   });
//
//   @override
//   _bottomWrapperState createState() => _bottomWrapperState();
// }
//
//
// class _bottomWrapperState extends State<bottomWrapper> {
//
//   Future<void> callFetchData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final reservationid = prefs.getString('Reservation ID');
//
//     final fooditemsdetailsprovider = Provider.of<FoodItemsDetailsProvider>(context, listen: false);
//
//     if (reservationid != null) {
//       SessionTracking().fetchData(context, reservationid: reservationid);
//       fooditemsdetailsprovider.addFoodOrderStatus('Order');
//     }else{
//       fooditemsdetailsprovider.addFoodOrderStatus('Pre Order');
//       print('reservation id null in foodmenu screen');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final fooditemsdetailsprovider = Provider.of<FoodItemsDetailsProvider>(context, listen: false);
//
//     return Wrap(
//         runSpacing: 10,
//         spacing: 10,
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width,
//             padding: const EdgeInsets.all(20.0),
//             decoration: const BoxDecoration(
//               border: Border(
//                 top: BorderSide(
//                   color: Colors.grey,
//                   width: 1.5,
//                 ),
//               ),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Sub Total",
//                       style: TextStyle(
//                         fontSize: 14.0,
//                         color: Colors.black,
//                       ),
//                     ),
//                     Text(
//                       'LKR ${widget.totalamount}',
//                       style: TextStyle(
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 8.0,
//                 ),
//                 const SizedBox(
//                   height: 15.0,
//                 ),
//                 SizedBox(
//                   height: 48,
//                   width: MediaQuery.of(context).size.width,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.cyan[500],
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     onPressed: () async {
//                       // confirmedItems.clear();
//                       // for (String item in itemList) {
//                       //   print(item);
//                       //   confirmedItems.add(item);
//                       // }
//                       fooditemsdetailsprovider.addItems(widget.itemList);
//                       print(fooditemsdetailsprovider.items);
//                       //print('Items: ${fooditemsdetailsprovider.items}');
//                       //print(confirmedItems);
//                       print('total: ${widget.totalamount}');
//                       //itemList.sort();
//                       //final fooditemsdetailsprovider = Provider.of<FoodItemsDetailsProvider>(context, listen: false);
//
//                       // if (widget.OrderCondition == 'ONjourney')
//                       //
//                       //
//                       // if (widget.OrderCondition == 'While Reservation')
//
//                       await callFetchData();
//                       //String trainno = journeyProvider.trainno;
//
//                       //fooditemsdetailsprovider.addTrainno(trainno);
//                       //fooditemsdetailsprovider.addReservationID(reservationid ?? '');
//                       //fooditemsdetailsprovider.addItemNameandNo(confirmedItems);
//                       fooditemsdetailsprovider.addTotalAmount(widget.totalamount);
//                       //print(fooditemsdetailsprovider.itemNodNamePrice);
//
//                       final paymentdetailsprovider = Provider.of<PaymentDetailsProvider>(context, listen: false);
//                       paymentdetailsprovider.addTotalFoodPrice(widget.totalamount);
//
//                       Navigator.push(context, MaterialPageRoute(builder: (_) =>
//                           PassengerDetailsConfirmation(showDialog: false)));
//                     },
//                     child: const Text(
//                       "Place Order",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//
//     );
//   }
// }
