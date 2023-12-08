

import 'package:ecjourney/AdminPanel/Train%20Info/AddSchedule.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'UpdateSchedule.dart';

class TrainSchedule extends StatefulWidget {
  static const String id = "trainschedule-screen";

  @override
  _TrainSchedule createState() => _TrainSchedule();
}

class _TrainSchedule extends State<TrainSchedule> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Train Schedule',
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
                child: Text('Add Schedule'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddTrain()),
                  );
                },
              ),
              SizedBox(width: 700),
              // Text(
              //   'Search',
              // ),
              // SizedBox(width: 10.0),
              // Expanded(
              //   child: TextField(
              //     decoration: InputDecoration(
              //       hintText: 'Train No/Name',
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        SizedBox(height: 10.0),
        TSDataTableWidget(),
      ],
    );
  }
}

class TSDataTableWidget extends StatefulWidget {
  @override
  _TSDataTableWidgetState createState() => _TSDataTableWidgetState();
}

class _TSDataTableWidgetState extends State<TSDataTableWidget> {
  DatabaseReference _dbReference = FirebaseDatabase.instance.ref().child('Train Schedule');

  @override
  Widget build(BuildContext context) {
    //Fetch all the current train schedules from the database
    return StreamBuilder<DatabaseEvent>(
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
          //Store the fetched data's
          DataSnapshot dataSnapshot = snapshot.data!.snapshot;

          dynamic dataValue = dataSnapshot.value;

          List<Map<String, dynamic>> items = [];
          dataValue.forEach((key, item) {
            //Add the fetched data in a List
            if (item is Map<dynamic, dynamic>) {
              items.add({
                'Train No': item['Train No'],
                'Start Station - End Station': '${item['Start Station']} - ${item['End Station']}',
                'Departs': item['Departs'],
                'Arrive': item['Arrive'],
                'Seats Availability': item['Seats Availability'] is int
                    ? item['Seats Availability']
                    : int.tryParse(item['Seats Availability'].toString()) ?? 0,
                'Price': item['Price'] is int
                    ? item['Price']
                    : int.tryParse(item['Price'].toString()) ?? 0,
              });
            }
          });
          //Return LayoutBuilder after performing StreamBuilder
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    columns: const <DataColumn>[
                      //Name the table columns
                      DataColumn(label: Text('Train No')),
                      DataColumn(label: Text('Start Station - End Station')),
                      DataColumn(label: Text('Departs')),
                      DataColumn(label: Text('Arrive')),
                      DataColumn(label: Text('Seats Availability')),
                      DataColumn(label: Text('Price')),
                      DataColumn(
                          label: Center(
                              child: Text('Operation',
                                  textAlign: TextAlign.center))),
                    ],

                    //Map each data from the List that holds the fetched data
                    rows: items.map<DataRow>((item) {
                      String trainNo = item['Train No'].split(' ')[0];
                      return DataRow(
                        //Display the data in the table
                        cells: <DataCell>[
                          DataCell(Text(item['Train No'])),
                          DataCell(Text(item['Start Station - End Station'])),
                          DataCell(Text(item['Departs'])),
                          DataCell(Text(item['Arrive'])),
                          DataCell(Text(item['Seats Availability'].toString())),
                          DataCell(Text(item['Price'].toString())),
                          DataCell(Row(
                            children: [
                              ElevatedButton(
                                child: Text('Update'),
                                onPressed: () {
                                  // Handle button press
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => UpdateTrainSchedule(trainNo: trainNo)),
                                  );
                                },
                              ),
                              SizedBox(width: 5.0),
                              ElevatedButton(
                                child: Text('Delete'),
                                onPressed: () {
                                  // Handle button press
                                  _showDeleteConfirmationDialog(trainNo);
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

  Future<void> _showDeleteConfirmationDialog(String trainNo) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this train schedule?'),
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
                _dbReference.child(trainNo).remove();
              },
            ),
          ],
        );
      },
    );
  }
}
