
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Common/textfield.dart';
import '../FoodOrderingScreen/FoodItemsModel.dart';
import '../FoodOrderingScreen/FoodMenuScreen.dart';
import '../Waste/LocalDatabase.dart';
import '../Models/UserModel/UserDetailsProvider.dart';
import '../ReservationDetailsConfirmationScreen/ReservationDetailsConfirmationScreen.dart';
import '../Common/PopUpMessage.dart';
import '../Payment/sendEmail.dart';
import 'PassengerDetailsProvider.dart';

class PassengerDetailsConfirmation extends StatefulWidget {

  final bool showDialog;

  PassengerDetailsConfirmation({required this.showDialog});

  @override
  _PassengerDetailsConfirmation createState() => _PassengerDetailsConfirmation();
}


class _PassengerDetailsConfirmation extends State<PassengerDetailsConfirmation> {
  final _formKey = new GlobalKey<FormState>();

  final _conUserFname = TextEditingController();
  final _conUserLname = TextEditingController();
  final _conEmail = TextEditingController();
  final _conMobileNum = TextEditingController();
  final _conNICorPassport = TextEditingController();

  bool _toggleValue = false;

  @override
  void initState() {
    super.initState();
    getPassengerDetails();
    if (widget.showDialog){
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        bool? confirmed = await popUpMessage.showConfirmationDialog(context);
        if (confirmed == true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FoodMenuScreen(status: 'From Reservation')));
        }else{
          final fooditemsdetailsprovider = Provider.of<FoodItemsDetailsProvider>(context, listen: false);
          fooditemsdetailsprovider.addFoodOrderStatus('No Order');
        }
      });
  }
  }

  //method to fetch the passenger details
  getPassengerDetails() async {
    //Fetch user details from the user model
    //pass it to textformfields
    UserDataStorage userDataStorage = UserDataStorage();
    Map<String, dynamic>? userData = await userDataStorage.getUserDetails();

    if (userData != null) {
      _conUserFname.text = userData['firstName'] ?? '';
      _conUserLname.text = userData['lastName'] ?? '';
      _conEmail.text = userData['Email'] ?? '';
      _conMobileNum.text = userData['mobileNum'] ?? '';
      _conNICorPassport.text = userData['NICNo'] ?? '';
      _conNICorPassport.text = userData['passportNo'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Confirm Details",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.cyan[500],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getTextFormField(   //TextFormField for first name
                      controller: _conUserFname,
                      icon: Icons.person_outline,
                      inputType: TextInputType.name,
                      hintName: 'First Name'),
                  SizedBox(height: 10.0),
                  getTextFormField(   //TextFormField for last name
                      controller: _conUserLname,
                      icon: Icons.person_outline,
                      inputType: TextInputType.name,
                      hintName: 'Last Name'),
                  SizedBox(height: 10.0),
                  getTextFormField(   //TextFormField for email
                    isEnable: false,
                      controller: _conEmail,
                      icon: Icons.email_outlined,
                      inputType: TextInputType.emailAddress,
                      hintName: 'Email'),
                  SizedBox(height: 10.0),
                  getTextFormField(   //TextFormField for mobile num
                      controller: _conMobileNum,
                      icon: Icons.phone_android_outlined,
                      inputType: TextInputType.phone,
                      hintName: 'Mobile Number'),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Text('NIC'),
                      Switch( //toggle button to allow user to select NIC or Passport
                        value: _toggleValue,
                        onChanged: (value) {
                          setState(() {
                            _toggleValue = value;
                          });
                        },
                        activeColor: Colors.green,
                      ),
                      Text('Passport'),
                    ],
                  ),
                  getTextFormField( //TextFormField for NIC/passport
                    controller: _conNICorPassport,
                    icon: Icons.person_outline,
                    hintName: _toggleValue ? 'Passport' : 'NIC',
                  ),
                  SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextButton(
          onPressed: () {
            //store the final values in the textformfield to the provider
            if (_formKey.currentState!.validate()) {
              _formKey.currentState?.save();
              final passengerdetailsprovider =
              Provider.of<PassengerDetailsProvider>(context, listen: false);
              passengerdetailsprovider.addFirstName(_conUserFname.text);
              passengerdetailsprovider.addLastName(_conUserLname.text);
              passengerdetailsprovider.addEmail(_conEmail.text);
              passengerdetailsprovider.addMobileNum(_conMobileNum.text);

              //If toggle value is true
              //store data in Nic/Passport textformfield to passport
              if (_toggleValue) {
                passengerdetailsprovider.addPassportNo(_conNICorPassport.text);
              } else {
                passengerdetailsprovider.addNicNo(_conNICorPassport.text);
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReservationDetailsConfirmation(),
                ),
              );
            }

          },

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyan[500],
            minimumSize: Size(MediaQuery.of(context).size.width, 50),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          child: Text(
            "Confirm",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
