import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecjourney/PassengerDetailsConfirmationScreen/PassengerDetailsConfirmationScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../SearchTrainScreen/SearchTrain.dart';
import '../SearchTrainScreen/SearchTrainScreenResources/executeOverLay.dart';
import '../SessionTracking.dart';
import 'FoodBasket.dart';
import 'FoodItemsModel.dart';
import 'ItemCategoriesScreen.dart';
import 'ItemDescriptionScreen.dart';

class FoodMenuScreen extends StatefulWidget {
  final String? status;

  FoodMenuScreen({required this.status});

  @override
  _FoodMenuScreen createState() => _FoodMenuScreen();
}

class _FoodMenuScreen extends State<FoodMenuScreen> {
  SearchTrain executeOverLay = SearchTrain();

  bool isHomeSelected = true;
  bool isBasketSelected = false;

  // void callFetchData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final reservationid = prefs.getString('Reservation ID');
  //
  //   if (reservationid != null) {
  //     SessionTracking().fetchData(context, reservationid: reservationid);
  //     final fooditemsdetailsprovider = Provider.of<FoodItemsDetailsProvider>(context, listen: false);
  //     fooditemsdetailsprovider.addFoodOrderStatus('Making Order');
  //   }else{
  //     print('reservation id null in foodmenu screen');
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            //Navigate user back to passenger confirm details screen
            //if user order food while rservation
            if (widget.status == 'From Reservation') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PassengerDetailsConfirmation(showDialog: false)));
            }
            //Naviagte user back to SearchTrain screen with overlay
            //if user pre order food
            if (widget.status == 'From Drawer') {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchTrain()));
              showOverlay(context);
            }
          },
          child: Icon(Icons.arrow_back),
        ),
        title: const Text(
          "Food Menu",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.cyan[500],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        height: double.infinity,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Expanded(
            //Fetch food menu from the database
            child: StreamBuilder<DatabaseEvent>(
                stream:
                    FirebaseDatabase.instance.ref().child('Food Items').onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data?.snapshot.value == null) {
                      return Text('Error fetching data or no data available');
                    } else {
                      Map<dynamic, dynamic> data = snapshot.data!.snapshot.value
                          as Map<dynamic, dynamic>;
                      List<dynamic> fooditems = data.values.toList();

                      //Display using ListView builder
                      return ListView.builder(
                        itemCount: fooditems.length,
                        itemBuilder: (context, index) {
                          final fooditem = fooditems[index];
                          print(fooditem);

                          String foodname = fooditem['Item Name'];
                          String foodimagelink = fooditem['Item Image Link'];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ItemCategoriesScreen(
                                          foodname: foodname,
                                          foodimagelink: foodimagelink)));
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.cyan.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              height: 175,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      '$foodimagelink',
                                      width: MediaQuery.of(context).size.width,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    ' $foodname',
                                    style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }
                }),
          ),
          //widget to allow user to naviagate to food basket screen
          Wrap(
            runSpacing: 10,
            spacing: 10,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.white70,
                      width: 4.0,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Navigate user to Back to food menu screen if home is pressed
                        IconButton(
                          icon: Icon(Icons.home,
                              color:
                                  isHomeSelected ? Colors.black : Colors.grey),
                          onPressed: () {
                            setState(() {
                              isHomeSelected = true;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FoodMenuScreen(status: widget.status)));
                          },
                        ),
                        //Navigate user to food basket screen if shopping cart icon is pressed
                        IconButton(
                          icon: Icon(Icons.shopping_cart,
                              color: isBasketSelected
                                  ? Colors.black
                                  : Colors.grey),
                          onPressed: () {
                            setState(() {
                              isBasketSelected = true;
                              isHomeSelected = false;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FoodBasket(status: 'From home')));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
