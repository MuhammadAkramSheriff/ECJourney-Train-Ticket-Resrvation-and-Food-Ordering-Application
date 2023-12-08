import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ecjourney/Common/textfield.dart';

import '../../Common/Helper.dart';

class AddFoodMenu extends StatefulWidget {
  static const String id = "addfoodmenu-screen";

  @override
  _AddFoodMenu createState() => _AddFoodMenu();
}

class _AddFoodMenu extends State<AddFoodMenu> {
  final _formKey = new GlobalKey<FormState>();

  final _conMenuNo = TextEditingController();
  final _conItemName = TextEditingController();
  final _conItemCategoryName = TextEditingController();
  final _conItemImage = TextEditingController();
  final _conDescription = TextEditingController();
  final _conPrice = TextEditingController();


  final DatabaseReference _dbReferenceFI = FirebaseDatabase.instance.ref().child('Item Category');
  final DatabaseReference _dbReferenceFM = FirebaseDatabase.instance.ref().child('Food Menu');

  List<String> itemNames = [];
  String _selecteditem = '';

  List<String> itemCategoryNames = [];
  String _selecteditemcategory = '';

  getFoodDetails() async {
    print('opended');
    DataSnapshot snapshot = (await _dbReferenceFI
        .orderByChild('Item Category Name')
        .equalTo(_selecteditemcategory)
        .get());

    if (snapshot.value != null) {
      Map<dynamic, dynamic>? foodDetails = snapshot.value as Map<
          dynamic,
          dynamic>?;

      if (foodDetails != null) {
        Map<dynamic, dynamic>? innerItemDetails = foodDetails.values.first as Map<dynamic, dynamic>?;

        if (innerItemDetails != null) {
          print('Food Details for: $innerItemDetails');
          print('Food Details for Item Name: ${innerItemDetails['Item Name']}');

          // Assign retrieved values to your text fields
          _conMenuNo.text = innerItemDetails['Item No'] ?? '';
          _conItemName.text = innerItemDetails['Item Name'] ?? '';
          _conItemCategoryName.text = innerItemDetails['Item Category Name'] ?? '';
          _conItemImage.text = innerItemDetails['Item Image'] ?? '';
          _conDescription.text = innerItemDetails['Description'] ?? '';
          _conPrice.text = (innerItemDetails['Price'] ?? '').toString();
        }
      }else{
        print('null');
      }
    }else{
      print('null 2');
    }
  }

  //Mehtod to add the food menu
  AddMenu() async {
    String menuno = _conMenuNo.text;
    String itemname = _conItemName.text;
    String itemcategoryname = _conItemCategoryName.text;
    String itemimage = _conItemImage.text;
    String description = _conDescription.text;
    int price = int.tryParse(_conPrice.text) ?? 0;

    DatabaseReference scheduleRef = _dbReferenceFM.child(menuno);

    //Add the food item into the 'Food Menu' database
    scheduleRef.set({
      'Menu No' : menuno,
      'Item Name' : itemname,
      'Item Category Name' : itemcategoryname,
      'Description': description,
      'Price': price,
      'Food Image Link': itemimage,
    }).then((value){
      showToastWeb('Successfully Added');
      Navigator.pop(context);
    }).onError((error, stackTrace){
      print((error, stackTrace));
    });
  }

  //Method to fetch item from database
  void fetchItemFromDatabase() {
    DatabaseReference reference = FirebaseDatabase.instance.ref().child('Item Category');

    reference.once().then((DatabaseEvent event) {
      Map<dynamic, dynamic>? values = event.snapshot.value as Map<dynamic, dynamic>?;
      print(values);

      if (values != null) {
        values.forEach((key, value) {
          //fetch the item name and item catgeory name from the database
          String foodName = value['Item Name'];
          String itemcategoryname = value['Item Category Name'];

          print(foodName);
          print(itemcategoryname);
          if (foodName != null && !itemNames.contains(foodName)) {
            setState(() {
              //add the item name into the List
              itemNames.add(foodName);
              _selecteditem = itemNames[0];
              fetchItemCategoryFromDatabase(_selecteditem);
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

  //Method to fetch item categories from the database
  void fetchItemCategoryFromDatabase(String itemName) {
    DatabaseReference reference = FirebaseDatabase.instance.ref().child('Item Category');

    reference.once().then((DatabaseEvent event) {
      Map<dynamic, dynamic>? values = event.snapshot.value as Map<dynamic, dynamic>?;
      print(values);

      if (values != null) {
        values.forEach((key, value) {
          //fecth the item name and item categories
          String foodName = value['Item Name'];
          String itemcategoryname = value['Item Category Name'];

          print(itemcategoryname);
          print(foodName);

          //check if the fetched item category matches the item
          //in the item dropdown
          if (foodName == itemName) {
            if (itemcategoryname != null && !itemCategoryNames.contains(itemcategoryname)) {
              //Add the item categories name to the List
              setState(() {
                itemCategoryNames.clear();
                itemCategoryNames.add(itemcategoryname);
                _selecteditemcategory = itemCategoryNames[0];
                getFoodDetails();
                print(itemCategoryNames);
              });
            }
          }else{
            print('not equal');
          }
        });
      }
    }).catchError((error) {
      // Handle error
      print("Error: $error");
    });
  }

  @override
  void initState() {
    super.initState();
    fetchItemFromDatabase();
    fetchItemCategoryFromDatabase(_selecteditem);
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
                  Text('Add Food Item To Menu',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),),
                  SizedBox(height: 20.0),
                    Container(  //Dropdown for item
                      child: DropdownButton<String>(
                        value: _selecteditem,
                        //Map the values for dropdown from the item list
                        items: itemNames.map((String foodName) {
                          return DropdownMenuItem<String>(
                            value: foodName,
                            child: Text(foodName),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selecteditem = value ?? '';
                            fetchItemCategoryFromDatabase(_selecteditem);
                            print('calling');
                            getFoodDetails();
                          });
                        },
                      ),
                    ),
                  Container( //Dropdown for the item category
                    child: DropdownButton<String>(
                      value: _selecteditemcategory,
                      //Map the value for the dropdown from the item categories list
                      items: itemCategoryNames.map((String foodName) {
                        return DropdownMenuItem<String>(
                          value: foodName,
                          child: Text(foodName),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selecteditemcategory = value ?? '';
                          getFoodDetails();
                        });
                      },
                    ),
                  ),
                  getTextFormField( //TextFormField for Menu no
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
                  getTextFormField( //TextFormField for image link
                      controller: _conItemImage,
                      inputType: TextInputType.name,
                      hintName: 'Image Link'),

                  SizedBox(height: 10.0),
                  getTextFormField( //TextFormField for description
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
                    onPressed: AddMenu,
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