import 'package:ecjourney/AdminPanel/AdminPanel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ecjourney/Common/textfield.dart';
import 'package:intl/intl.dart';

import '../../Common/Helper.dart';
import 'TrainSchedule.dart';

class UpdateTrainSchedule extends StatefulWidget {
  static const String id = "updatetrainschedule-screen";

  final String trainNo;
  UpdateTrainSchedule({required this.trainNo});

  @override
  _UpdateTrainSchedule createState() => _UpdateTrainSchedule();
}


class _UpdateTrainSchedule extends State<UpdateTrainSchedule> {
  final _formKey = new GlobalKey<FormState>();

  final _conTrainNo = TextEditingController();
  final _conDate = TextEditingController();
  final _conStartStation = TextEditingController();
  final _conEndStation = TextEditingController();
  final _conDeparts = TextEditingController();
  final _conArrive = TextEditingController();
  final _conSeatAvailable = TextEditingController();
  final _conPrice = TextEditingController();

  final DatabaseReference _dbReference = FirebaseDatabase.instance.ref().child('Train Schedule');

  late DateTime _selectedDate;
  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    getTrainDetails();
    _selectedDate = DateTime.now();
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: _selectedDate,
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        formattedDate = DateFormat('dd-MM-yyyy').format(picked);
        _conDate.text = formattedDate;
      });
    }
  }

  //To get the train details user wish to update
  getTrainDetails() async {
    //Fetch from 'Train Schedule' database
    DataSnapshot snapshot = (await _dbReference.child(widget.trainNo).get());

    Map traindetails = snapshot.value as Map;

    //Pass it to the TextFormFields
    _conTrainNo.text = traindetails['Train No'];
    _conDate.text = traindetails['Date'];
    _conStartStation.text = traindetails['Start Station'];
    _conEndStation.text = traindetails['End Station'];
    _conDeparts.text = traindetails['Departs'];
    _conArrive.text = traindetails['Arrive'];
    _conSeatAvailable.text = traindetails['Seats Availability'].toString();
    _conPrice.text = traindetails['Price'].toString();
  }


  //To perform update
  updateTrainSchedule() async {
    String trainno = _conTrainNo.text;
    String date = _conDate.text;
    String startstation = _conStartStation.text;
    String endstation = _conEndStation.text;
    String departs = _conDeparts.text;
    String arrive = _conArrive.text;
    int seatsavailable = int.tryParse(_conSeatAvailable.text) ?? 0;
    int price = int.tryParse(_conPrice.text) ?? 0;

    //Update the values in the database with the current values
    //in the TextFormField
    _dbReference.child(widget.trainNo).update({
      'Date': date,
      'Start Station': startstation,
      'End Station': endstation,
      'Departs': departs,
      'Arrive': arrive,
      'Seats Availability': seatsavailable,
      'Price': price,
    }).then((value){
      showToastWeb('Successfully Updated');
      Navigator.pop(context);
    }).onError((error, stackTrace){
      print((error, stackTrace));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        final value = await Navigator.push(
            context, MaterialPageRoute(builder: (_) => AdminPanel()));
        if (value != null){
          return Future.value(value);
        }else{
          return Future.value(false);
        }
      },
      child:Scaffold(
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Update Train Schedule',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),),
                    SizedBox(height: 20.0),
                    TextFormField(  //TextFormField for Date
                      controller: _conDate,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () {
                            //User can select date from the calender
                            _selectDate(context);
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        fillColor: Colors.grey[200],
                        filled: true,
                        labelText: 'Date',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    getTextFormField(   //TextFormField for Start Station
                        controller: _conStartStation,
                        inputType: TextInputType.name,
                        hintName: 'Start Station'),
                    SizedBox(height: 10.0),
                    getTextFormField(   //TextFormField for End Station
                        controller: _conEndStation,
                        inputType: TextInputType.name,
                        hintName: 'End Station'),
                    SizedBox(height: 10.0),
                    getTextFormField(   //TextFormField for Depart
                        controller: _conDeparts,
                        inputType: TextInputType.name,
                        hintName: 'Departs'),
                    SizedBox(height: 10.0),
                    getTextFormField(   //TextFormField for Email Address
                        controller: _conArrive,
                        inputType: TextInputType.emailAddress,
                        hintName: 'Arrive'),
                    SizedBox(height: 10.0),
                    getTextFormField(   //TextFormField for Seat availability
                        controller: _conSeatAvailable,
                        inputType: TextInputType.phone,
                        hintName: 'Seats Available'),
                    SizedBox(height: 10.0),
                    getTextFormField(   //TextFormField for price
                        controller: _conPrice,
                        inputType: TextInputType.phone,
                        hintName: 'Price'),
                    SizedBox(height: 20.0),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan[500]!),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size(double.infinity, 50),
                        ),
                      ),
                      onPressed: updateTrainSchedule,
                      child: Text(
                        'Update',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}