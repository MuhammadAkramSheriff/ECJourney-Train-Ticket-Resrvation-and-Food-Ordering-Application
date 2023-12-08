import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ecjourney/Common/textfield.dart';

import '../../Common/Helper.dart';

class AddCategory extends StatefulWidget {
  static const String id = "addcategory-screen";

  @override
  _AddCategory createState() => _AddCategory();
}

class _AddCategory extends State<AddCategory> {
  final _formKey = new GlobalKey<FormState>();

  final _conMenuNo = TextEditingController();
  final _conFoodName = TextEditingController();
  final _conDescription = TextEditingController();
  final _conPrice = TextEditingController();
  final _conFoodImageLink = TextEditingController();


  final DatabaseReference _dbReference = FirebaseDatabase.instance.ref().child('Food Items');


  @override
  void initState() {
    super.initState();
  }

  //Method to add the category into the database
  AddCategory() async {
    String itemname = _conFoodName.text;
    String itemimagelink = _conFoodImageLink.text;

    DatabaseReference scheduleRef = _dbReference.child(itemname);

    scheduleRef.set({
      'Item Name' : itemname,
      'Item Image Link': itemimagelink,
    }).then((value){
      showToastWeb('Successfully Added');
      Navigator.pop(context);
    }).onError((error, stackTrace){
      print((error, stackTrace));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Text('Add Item Category',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),),
                  SizedBox(height: 20.0),
                  getTextFormField( //TextFormField for category name
                      controller: _conFoodName,
                      inputType: TextInputType.name,
                      hintName: 'Category'),
                  SizedBox(height: 20.0),
                  getTextFormField( //TextFormField for image link
                      controller: _conFoodImageLink,
                      inputType: TextInputType.name,
                      hintName: 'Image Link'),
                  SizedBox(height: 10.0),

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
                    onPressed: AddCategory,
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
    );
  }
}