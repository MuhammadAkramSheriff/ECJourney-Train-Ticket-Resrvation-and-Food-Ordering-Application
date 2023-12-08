import 'package:ecjourney/AdminPanel/AdminPanel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ecjourney/Common/textfield.dart';
import 'package:intl/intl.dart';

import '../../Common/Helper.dart';
import 'TrainSchedule.dart';

class AddTrain extends StatefulWidget {
  static const String id = "addtraindetails-screen";

  @override
  _AddTrainState createState() => _AddTrainState();
}


class _AddTrainState extends State<AddTrain> {


final _formKey = new GlobalKey<FormState>();

  final _conTrainNo = TextEditingController();
  final _conTScheduleDate = TextEditingController();
  final _constartStation = TextEditingController();
  final _conendStation = TextEditingController();
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
    _selectedDate = DateTime.now();
    _conTScheduleDate.text = formattedDate;
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
      });
    }
  }

  AddSchedule() async {
    String trainno = _conTrainNo.text;
    String tscheduledate = _conTScheduleDate.text;
    String startstation = _constartStation.text;
    String endstation = _conendStation.text;
    String departs = _conDeparts.text;
    String arrive = _conArrive.text;
    int seatsavailable = int.tryParse(_conSeatAvailable.text) ?? 0;
    int price = int.tryParse(_conPrice.text) ?? 0;

    DatabaseReference scheduleRef = _dbReference.child(trainno);

    //Add the values in the TextFormField into the 'Train Schedule' database
    scheduleRef.set({
      'Train No' : trainno,
      'Date' : tscheduledate,
      'Start Station': startstation,
      'End Station': endstation,
      'Departs': departs,
      'Arrive': arrive,
      'Seats Availability': seatsavailable,
      'Price': price,
    }).then((value){
      showToastWeb('Successfully Added');
      Navigator.pop(context);
    }).onError((error, stackTrace){
      print((error, stackTrace));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //Navigating back to AdminPanel when back icon is pressed
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
                  Text('Add Train Schedule',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(height: 20.0),
                  getTextFormField(     //TextFormField for Train No
                      controller: _conTrainNo,
                      inputType: TextInputType.name,
                      hintName: 'Train No'),
                  SizedBox(height: 10.0),
                      TextFormField( //TextFormField for Date
                        controller: TextEditingController(text: formattedDate),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () {
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
                  getTextFormField(  //TextFormField for Start Station
                      controller: _constartStation,
                      inputType: TextInputType.name,
                      hintName: 'Start Station'),
                  SizedBox(height: 10.0),
                  getTextFormField(   //TextFormField for End Station
                      controller: _conendStation,
                      inputType: TextInputType.name,
                      hintName: 'End Station'),
                  SizedBox(height: 10.0),
                  getTextFormField(   //TextFormField for Depart time
                      controller: _conDeparts,
                      inputType: TextInputType.name,
                      hintName: 'Departs'),
                  SizedBox(height: 10.0),
                  getTextFormField(   //TextFormField for Arrive Time
                      controller: _conArrive,
                      inputType: TextInputType.emailAddress,
                      hintName: 'Arrive'),
                  SizedBox(height: 10.0),
                  getTextFormField(   //TextFormField for Seat Availability
                      controller: _conSeatAvailable,
                      inputType: TextInputType.phone,
                      hintName: 'Seats Available'),
                  SizedBox(height: 10.0),
                  getTextFormField(   //TextFormField for Price
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
                    onPressed: AddSchedule,
                    child: Text(
                      'Add',
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