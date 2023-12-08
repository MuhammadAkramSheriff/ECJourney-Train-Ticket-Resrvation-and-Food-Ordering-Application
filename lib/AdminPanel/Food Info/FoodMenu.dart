import 'package:ecjourney/AdminPanel/Food%20Info/AddCategory.dart';
import 'package:ecjourney/AdminPanel/Train%20Info/AddSchedule.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../Common/textfield.dart';
import 'AddFoodMenu.dart';
import 'AddItem.dart';
import 'UpdateFoodMenu.dart';

class FoodMenu extends StatefulWidget {
  static const String id = "foodmenu-screen";

  @override
  _FoodMenu createState() => _FoodMenu();
}

class _FoodMenu extends State<FoodMenu> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Food Menu',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              ElevatedButton(
                child: Text('Add Item Category'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddCategory()),
                  );
                },
              ),
              SizedBox(width: 20),
              ElevatedButton(
                child: Text('Add Item'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddItem()),
                  );
                },
              ),
              SizedBox(width: 20),
              ElevatedButton(
                child: Text('Add Menu'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddFoodMenu()),
                  );
                },
              ),
              SizedBox(width: 500),
              // Text(
              //   'Search',
              // ),
              // SizedBox(width: 10.0),
              // Expanded(
              //   child: TextField(
              //     decoration: InputDecoration(
              //       hintText: 'Menu No',
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        SizedBox(height: 10.0),
        DataTableWidget(),
      ],
    );
  }
}

class DataTableWidget extends StatelessWidget {
  DatabaseReference _dbReference = FirebaseDatabase.instance.ref().child('Food Menu');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      //Fetch each added item in the 'Food Menu' database
      stream: _dbReference.onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: Text(
                'No data available'),
          );
        } else {

          //Store the fetched data
          DataSnapshot dataSnapshot = snapshot.data!.snapshot;

          dynamic dataValue = dataSnapshot.value;

          List<Map<String, dynamic>> items = [];
          dataValue.forEach((key, menuData) {
            //Store the fetched data in a List
            if (menuData is Map<dynamic, dynamic>) {
              // Extract reservation ID
              String menuNO = key;
                items.add({
                  'Menu No': menuNO,
                  'Item Category': menuData['Item Category Name'] ?? '',
                  'Item Name': menuData['Item Name'] ?? '',
                  'Description': menuData['Description'] ?? '',
                  'Price': menuData['Price'] ?? '',
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
                      DataColumn(label: Text('Menu No')),
                      DataColumn(label: Text('Item Category')),
                      DataColumn(label: Text('Item Name')),
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Price')),
                      DataColumn(
                          label: Center(
                              child: Text('Operation',
                                  textAlign: TextAlign.center))),
                    ],

                    //map each item for the DataCell from the List
                    rows: items.map<DataRow>((item) {
                      String menuNo = item['Menu No'].split(' ')[0];
                      return DataRow(
                        cells: <DataCell>[
                          DataCell(Text(item['Menu No'])),
                          DataCell(Text(item['Item Category'])),
                          DataCell(Text(item['Item Name'])),
                          DataCell(Text(item['Description'])),
                          DataCell(Text(item['Price'].toString())),
                          DataCell(Row(
                            children: [
                              ElevatedButton(
                                child: Text('Update'),
                                onPressed: () {
                                  // Handle button press
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => UpdateFoodMenu(menuno: menuNo)),
                                  );
                                },
                              ),
                              SizedBox(width: 5.0),
                              ElevatedButton(
                                child: Text('Delete'),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(context, menuNo);
                                },
                              ),
                            ],
                          )),
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

  Future<void> _showDeleteConfirmationDialog(context, String menuno) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this food menu?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _dbReference.child(menuno).remove();
              },
            ),
          ],
        );
      },
    );
  }
}