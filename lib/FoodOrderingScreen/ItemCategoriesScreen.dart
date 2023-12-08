import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'FoodBasket.dart';
import 'FoodItemsModel.dart';
import 'ItemDescriptionScreen.dart';

class ItemCategoriesScreen extends StatefulWidget {

  final String foodname;
  final String foodimagelink;

  ItemCategoriesScreen({required this.foodname, required this.foodimagelink});

  @override
  _ItemCategoriesScreen createState() => _ItemCategoriesScreen();
}

class _ItemCategoriesScreen extends State<ItemCategoriesScreen> {

  List<String> foodbasket = [];

  @override
  void initState() {
    super.initState();
    refreshBasketButtonVisibility();
  }

  void refreshBasketButtonVisibility() {
    final fooditemsdetailsprovider = Provider.of<FoodItemsDetailsProvider>(context, listen: false);
    setState(() {
      foodbasket = fooditemsdetailsprovider.selectedFoodItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        height: double.infinity,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Stack(
            children: [
              Image.asset(  //Display the main food item image
                widget.foodimagelink,
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 35,
                left: 10,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.2),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
            ),
              SizedBox(height: 8),
              Text(
                ' ${widget.foodname}',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 26),
              Container(
                height: 3,
                color: Colors.grey[200],
                margin: EdgeInsets.symmetric(vertical: 10), // Optional: Adjust the margin as needed
              ),
              SizedBox(height: 8),
              Expanded(
                //Fetch sub items from the database
                  child: StreamBuilder<DatabaseEvent>(
                    stream: FirebaseDatabase.instance.ref().child('Food Menu')
                        .orderByChild('Item Name')
                        .equalTo(widget.foodname)
                        .onValue,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Show a loading indicator while fetching data
                      } else {
                        if (snapshot.hasError || !snapshot.hasData || snapshot.data?.snapshot.value == null) {
                          return Text('Error fetching data or no data available');
                        } else {
                          Map<dynamic, dynamic> data = snapshot.data!.snapshot.value as Map<
                              dynamic,
                              dynamic>;
                          List<dynamic> itemcategories = data.values.toList();

                          return ListView.builder(
                            itemCount: itemcategories.length,
                            itemBuilder: (context, index) {
                              final itemcategory = itemcategories[index];
                              print(' item: $itemcategory');

                              String itemno = itemcategory['Menu No'];
                              String categoryname = itemcategory['Item Category Name'];
                              String itemimage = itemcategory['Food Image Link'];
                              int price  = itemcategory['Price'];
                              String description = itemcategory['Description'];

                              return GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(context, MaterialPageRoute(builder: (_) =>
                                      ItemDescriptionScreen(
                                          itemno: itemno,
                                          itemname: categoryname,
                                          itemPrice: price,
                                          itemDescription: description,
                                          itemImage: itemimage)));

                                  //Call the view basket button if user add an item to basket
                                  if (result != null && result == 'refresh') {
                                    refreshBasketButtonVisibility();
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    //color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$categoryname',
                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                              ),
                                              Text(
                                                'LKR $price',
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,
                                                    color: Colors.green),
                                              ),
                                            ],
                                          ),
                                          ),
                                          Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: AssetImage('$itemimage'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }
                    },
                  )
              ),

              //Show view food basket button if foodbasket is not empty
              if (foodbasket.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    onPressed: () async {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => FoodBasket(status: null)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan[500],
                      minimumSize: Size(MediaQuery.of(context).size.width, 50),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                    child: Text(
                      "View Basket",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ]
        ),
      ),
    );
  }
}