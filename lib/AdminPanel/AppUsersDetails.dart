import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppUserDetails extends StatefulWidget {
  static const String id = "appuserdetails-screen";

  @override
  _AppUserDetails createState() => _AppUserDetails();
}

class _AppUserDetails extends State<AppUserDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'App Users Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 800.0),
        //   child: Row(
        //     children: [
        //       Text('Search'),
        //       SizedBox(width: 10.0),
        //       Expanded(
        //         child: TextField(
        //           decoration: InputDecoration(
        //             hintText: 'NIC/Passport No',
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        SizedBox(height: 10.0),
        AUDataTableWidget(),
      ],
    );
  }
}

//class to fetch and display the data
class AUDataTableWidget extends StatefulWidget {
  @override
  _AUDataTableWidget createState() => _AUDataTableWidget();
}

class _AUDataTableWidget extends State<AUDataTableWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      //StreamBuilder to update the data in realtime
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        //fetch users from the firestore
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available.'));
          }

          //Store the fetched users email "document" variable
          var documents = snapshot.data!.docs;

          return DataTable(
            columns: [
              //Name the Table columns
              DataColumn(label: Text('Email Address')),
              DataColumn(label: Text('First Name')),
              DataColumn(label: Text('Last Name')),
              DataColumn(label: Text('Mobile No')),
              DataColumn(label: Text('NIC No')),
              DataColumn(label: Text('Passport No')),
            ],
            //map the user details with the user email address
            rows: documents.map((document) {
              var data = document.data() as Map<String, dynamic>;
              return DataRow(
                cells: [
                  //Pass the data's to the DataCell
                  DataCell(Text(data['Email Address'])),
                  DataCell(Text(data['First Name'])),
                  DataCell(Text(data['Last Name'])),
                  DataCell(Text(data['Mobile Number'])),
                  DataCell(Text(data['NIC NO'] ?? 'N/A')),
                  DataCell(Text(data['Passport Number'] ?? 'N/A')),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
