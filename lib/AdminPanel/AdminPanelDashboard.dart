import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class Dashboard extends StatefulWidget {
  static const String id = "dashboard-screen";
  @override
  _Dashboard createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {

  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Online Reservation',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataTableWidget(),
      ],
    );
  }
}

class DataTableWidget extends StatelessWidget {
  DatabaseReference _dbReference = FirebaseDatabase.instance.ref().child('Reservations');

  @override
  Widget build(BuildContext context) {
    //Fetch reservations from the database
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
          DataSnapshot dataSnapshot = snapshot.data!.snapshot;

          dynamic dataValue = dataSnapshot.value;

          List<Map<String, dynamic>> items = [];
          dataValue.forEach((key, reservationData) {
            if (reservationData is Map<dynamic, dynamic>) {
              // Extract reservation ID
              String reservationID = key;
              // Extract train details from the child node
              Map<String, dynamic>? trainDetails = reservationData['Train Details'];
              Map<String, dynamic>? passengerDetails = reservationData['Passenger Details'];
              Map<String, dynamic>? foodDetails = reservationData['Food Order'];
              Map<String, dynamic>? paymentDetails = reservationData['Payment'];
              print('train details: $trainDetails');

              //Add the train details into Items List<String> to display in the table
              if (trainDetails != null) {
                List<dynamic>? seatNumbers = trainDetails['Seat No'];
                items.add({
                  'Reservation ID': reservationID,
                  'Passenger Email': passengerDetails?['Email'] ?? '',
                  'Date': trainDetails['Date'] ?? '',
                  'Train': '${trainDetails['Train No'] ?? ''} ${trainDetails['From'] ?? ''} - ${trainDetails['To'] ?? ''}',
                  'Seat': seatNumbers?.join(', ') ?? '',
                  'Food Order ID': foodDetails?['Order No'] ?? '',
                  'Invoice No': paymentDetails?['Invoice No'] ?? '',
                  'Total Amount': paymentDetails?['Total Amount'] ?? '',
                });
              }
            }
          });
          //from the fetched data return a LayoutBuilder
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  //Create a table
                  child: DataTable(
                    //Name table column
                    columns: const <DataColumn>[
                      DataColumn(label: Text('Reservation ID')),
                      DataColumn(label: Text('Passenger Email')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Train')),
                      DataColumn(label: Text('Seat')),
                      DataColumn(label: Text('Food Order ID')),
                      DataColumn(label: Text('Invoice No')),
                      DataColumn(label: Text('Total Amount')),
                    ],
                    rows: items.map<DataRow>((item) {
                      return DataRow(
                        //Pass the values to the data cell from the Item List
                        cells: <DataCell>[
                          DataCell(Text(item['Reservation ID'])),
                          DataCell(Text(item['Passenger Email'])),
                          DataCell(Text(item['Date'])),
                          DataCell(Text(item['Train'])),
                          DataCell(Text(item['Seat'])),
                          DataCell(Text(item['Food Order ID'])),
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
