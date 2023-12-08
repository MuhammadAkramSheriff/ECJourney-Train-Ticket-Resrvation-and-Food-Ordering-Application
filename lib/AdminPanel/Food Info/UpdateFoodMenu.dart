import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ecjourney/Common/textfield.dart';

import '../../Common/Helper.dart';

class UpdateFoodMenu extends StatefulWidget {
  static const String id = "updatefoodmenu-screen";

  final String menuno;
  UpdateFoodMenu({required this.menuno});

  @override
  _UpdateFoodMenu createState() => _UpdateFoodMenu();
}

class _UpdateFoodMenu extends State<UpdateFoodMenu> {
  final _formKey = new GlobalKey<FormState>();

  final _conMenuNo = TextEditingController();
  final _conItemName = TextEditingController();
  final _conItemCategoryName = TextEditingController();
  final _conDescription = TextEditingController();
  final _conPrice = TextEditingController();
  final _conImageLink = TextEditingController();


  final DatabaseReference _dbReferenceFI = FirebaseDatabase.instance.ref().child('Item Category');
  final DatabaseReference _dbReferenceFM = FirebaseDatabase.instance.ref().child('Food Menu');

  @override
  void initState() {
    super.initState();
    getFoodDetails();
  }

  //Method to fetch the food item detials that user wished to update
  getFoodDetails() async {
    DataSnapshot snapshot = (await _dbReferenceFM.child(widget.menuno).get());

    Map itemdetails = snapshot.value as Map;

    // Assign retrieved values to your text fields
    _conMenuNo.text = itemdetails['Menu No'] ?? '';
    _conItemName.text = itemdetails['Item Name'] ?? '';
    _conItemCategoryName.text = itemdetails['Item Category Name'] ?? '';
    _conDescription.text = itemdetails['Description'] ?? '';
    _conPrice.text = (itemdetails['Price'] ?? '').toString();
  }

  //Method to update the food item in the menu
  updateFoodMenu() async {
    String menuno = _conMenuNo.text;
    String itemname = _conItemName.text;
    String itemcategoryname = _conItemCategoryName.text;
    String description = _conDescription.text;
    int price = int.tryParse(_conPrice.text) ?? 0;

    //Update the current value in the database with
    //the value from textformfields
    _dbReferenceFM.child(widget.menuno).update({
      'Menu No' : menuno,
      'Item Name' : itemname,
      'Item Category Name' : itemcategoryname,
      'Description': description,
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
                  Text('Update Food Menu Item',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),),
                  SizedBox(height: 20.0),
                  getTextFormField(  //TextFormField for Menu No
                      isEnable: false,
                      controller: _conMenuNo,
                      inputType: TextInputType.name,
                      hintName: 'Menu No'),
                  SizedBox(height: 20.0),
                  getTextFormField( //TextFormField for item name
                      isEnable: false,
                      controller: _conItemName,
                      inputType: TextInputType.name,
                      hintName: 'Item Name'),
                  SizedBox(height: 20.0),
                  getTextFormField( //TextFormField for item category name
                      isEnable: false,
                      controller: _conItemCategoryName,
                      inputType: TextInputType.name,
                      hintName: 'Item Category Name'),
                  SizedBox(height: 20.0),
                  getTextFormField( //TextFormField for decription
                      controller: _conDescription,
                      inputType: TextInputType.name,
                      hintName: 'Description'),
                  SizedBox(height: 10.0),
                  getTextFormField( //TextFormField for price
                      controller: _conPrice,
                      inputType: TextInputType.emailAddress,
                      hintName: 'Price'),
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
                    onPressed: updateFoodMenu,
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
    );
  }
}