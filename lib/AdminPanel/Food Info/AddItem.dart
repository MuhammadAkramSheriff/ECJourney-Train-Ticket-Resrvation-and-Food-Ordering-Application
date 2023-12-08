import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:ecjourney/Common/textfield.dart';

import '../../Common/Helper.dart';

class AddItem extends StatefulWidget {
  static const String id = "additem-screen";

  @override
  _AddItem createState() => _AddItem();
}

class _AddItem extends State<AddItem> {
  final _formKey = new GlobalKey<FormState>();

  final _conItemCategory = TextEditingController();
  final _conItemName = TextEditingController();
  final _conItemImage = TextEditingController();
  final _conDescription = TextEditingController();
  final _conPrice = TextEditingController();
  final _conItemNo = TextEditingController();


  final DatabaseReference _dbReferenceFM = FirebaseDatabase.instance.ref().child('Item Category');

  @override
  void initState() {
    super.initState();
    fetchDataFromDatabase();
    _conItemName.text = _selecteditem;
  }

  List<String> itemNames = [];
  String _selecteditem = '';

  // getFoodDetails() async {
  //   DataSnapshot snapshot = (await _dbReferenceFI.child(_selectedFood).get());
  //
  //   Map fooddetails = snapshot.value as Map;
  //
  //   //_conMenuNo.text = fooddetails['Menu No'];
  //   _conItemName.text = fooddetails['Food Name'];
  //   _conDescription.text = fooddetails['Description'];
  //   _conPrice.text = fooddetails['Price'].toString();
  // }

  //Method to add item into the database
  AddItem() async {
    String itemno = _conItemNo.text;
    String itemname = _conItemName.text;
    String itemcategory = _conItemCategory.text;
    String itemimage = _conItemImage.text;
    String description = _conDescription.text;
    int price = int.tryParse(_conPrice.text) ?? 0;
    //String imagelink = _conImageLink.text;

    DatabaseReference scheduleRef = _dbReferenceFM.child(itemno);

    //Add the user entered values into 'Item Category' database
    scheduleRef.set({
      'Item No' : itemno,
      'Item Name' : itemname,
      'Item Category Name' : itemcategory,
      'Item Image' : itemimage,
      'Description': description,
      'Price': price,
    }).then((value){
      showToastWeb('Successfully Added');
      Navigator.pop(context);
    }).onError((error, stackTrace){
      print((error, stackTrace));
    });
  }


  // void _onCategoryChanged(String? value) {
  //   setState(() {
  //     _selectedCategory = value ?? '';
  //   });
  // }

  //Method to fetch item categories from database
  void fetchDataFromDatabase() {
    DatabaseReference reference = FirebaseDatabase.instance.ref().child('Food Items');

    reference.once().then((DatabaseEvent event) {
      Map<dynamic, dynamic>? values = event.snapshot.value as Map<dynamic, dynamic>?;
      print(values);

      if (values != null) {
        values.forEach((key, value) {
          String itemName = value['Item Name'];
          print(itemName);
          //Add the fetched item names into the List
          if (itemName != null && !itemNames.contains(itemName)) {
            setState(() {
              itemNames.add(itemName);
              _selecteditem = itemNames[0];
              _conItemName.text = _selecteditem;
              print(itemNames);
            });
          }
        });
      }
    }).catchError((error) {
      // Handle error
      print("Error: $error");
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
                  Text('Add Item Categories',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),),
                  SizedBox(height: 20.0),
                  Container(
                    child: DropdownButton<String>(
                      value: _selecteditem,
                      items: itemNames.map((String foodName) {
                        return DropdownMenuItem<String>(
                          value: foodName,
                          child: Text(foodName),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selecteditem = value ?? '';
                          _conItemName.text = _selecteditem;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  getTextFormField( //TextFormField for food name
                      isEnable: false,
                      controller: _conItemName,
                      inputType: TextInputType.name,
                      hintName: 'Food Name'),
                  SizedBox(height: 20.0),
                  getTextFormField( //TextFormField for item category
                      controller: _conItemCategory,
                      inputType: TextInputType.name,
                      hintName: 'Item Category'),
                  SizedBox(height: 20.0),
                  getTextFormField( //TextFormField for item no
                      controller: _conItemNo,
                      inputType: TextInputType.name,
                      hintName: 'Item No'),
                  SizedBox(height: 20.0),
                  getTextFormField( //TextFormField for item image
                      controller: _conItemImage,
                      inputType: TextInputType.name,
                      hintName: 'Item Image'),
                  SizedBox(height: 20.0),
                  getTextFormField( //TextFormField for item description
                      controller: _conDescription,
                      inputType: TextInputType.name,
                      hintName: 'Description'),
                  SizedBox(height: 10.0),
                  getTextFormField(   //TextFormField for price
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
                    onPressed: AddItem,
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