import 'package:ecjourney/AdminPanel/Food%20Info/AddCategory.dart';
import 'package:ecjourney/AdminPanel/Train%20Info/AddSchedule.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../Common/textfield.dart';
import 'AddFoodMenu.dart';
import 'AddItem.dart';

class FoodOrders extends StatefulWidget {
  static const String id = "foodorder-screen";

  @override
  _FoodOrders createState() => _FoodOrders();
}

class _FoodOrders extends State<FoodOrders> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Food Orders',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 10.0),
        DataTableWidget(),
      ],
    );
  }
}

class DataTableWidget extends StatelessWidget {
  DatabaseReference _dbReference = FirebaseDatabase.instance.ref().child('Food Orders');

  @override
  Widget build(BuildContext context) {
    //Fetch current food orders from the 'Food Order' database
    return StreamBuilder<DatabaseEvent>(
      stream: _dbReference.onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: Text('No data available'),
          );
        } else {

          //Store the fetched data
          DataSnapshot dataSnapshot = snapshot.data!.snapshot;

          dynamic dataValue = dataSnapshot.value;

          List<Map<String, dynamic>> items = [];
          dataValue.forEach((key, orderData) {
            if (orderData is Map<dynamic, dynamic>) {
              print('order data: $orderData');
              // Extract reservation ID
              String orderNO = key;
              print('order id: $orderNO');

              //Store the data in a List
              List<dynamic>? foodItems = orderData['Item'];
              items.add({
                'Order No': orderNO,
                'Reservation ID': orderData['Reservation ID'] ?? '',
                'Train No': orderData['Train No'] ?? '',
                'Items': foodItems?.cast<String>() ?? [],
                'Invoice No': orderData['Invoice No'] ?? '',
                'Total Amount': orderData['Total Amount'] ?? '',
              });
            }
          });
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    columns: const <DataColumn>[
                      //Column names for the table
                      DataColumn(label: Text('Order No')),
                      DataColumn(label: Text('Reservation ID')),
                      DataColumn(label: Text('Train No')),
                      DataColumn(label: Text('Item')),
                      DataColumn(label: Text('Invoice No')),
                      DataColumn(label: Text('Total Amount')),
                    ],

                    //Map each item from the List and pass it to the DataCell
                    rows: items.map<DataRow>((item) {
                      return DataRow(
                        cells: <DataCell>[
                          DataCell(Text(item['Order No'])),
                          DataCell(Text(item['Reservation ID'])),
                          DataCell(Text(item['Train No'])),
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: (item['Items'] as List<String>)
                                  .map((foodItem) {
                                return Text(
                                  foodItem,
                                  style: TextStyle(fontSize: 16),
                                );
                              }).toList(),
                            ),
                          ),
                          DataCell(Text(item['Invoice No'])),
                          DataCell(Text(item['Total Amount'].toString())),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
