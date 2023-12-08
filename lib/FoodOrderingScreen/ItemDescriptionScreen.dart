import 'package:ecjourney/FoodOrderingScreen/FoodItemsModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'FoodItemsModel.dart';
import 'FoodItemsModel.dart';

class ItemDescriptionScreen extends StatefulWidget {
  final String itemno;
  final String itemname;
  final int itemPrice;
  final String itemDescription;
  final String itemImage;

  ItemDescriptionScreen(
      {required this.itemno,
      required this.itemname,
      required this.itemPrice,
      required this.itemDescription,
      required this.itemImage});

  @override
  _ItemDescriptionScreen createState() => _ItemDescriptionScreen();
}

class _ItemDescriptionScreen extends State<ItemDescriptionScreen> {
  @override
  void initState() {
    super.initState();
    //get the current quantity for the item
    final fooditemsdetailsprovider =
        Provider.of<FoodItemsDetailsProvider>(context, listen: false);
    int countForItem =
        fooditemsdetailsprovider.itemCounts[widget.itemname] ?? 1;
    _counter = fooditemsdetailsprovider.itemCounts.isEmpty ? 1 : countForItem;
  }

  String buttonText = 'Add';

  late int _counter;
  late int totalamount = widget.itemPrice;

  void _calculatetotalamount() {
    totalamount = widget.itemPrice * _counter;
  }

  @override
  Widget build(BuildContext context) {
    final fooditemsdetailsprovider =
        Provider.of<FoodItemsDetailsProvider>(context, listen: false);
    List<String> basket = fooditemsdetailsprovider.selectedFoodItems;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        height: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(
            children: [
              Image.asset(
                widget.itemImage,
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
          Text(
            ' ${widget.itemname}',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          Text(
            '  LKR ${widget.itemPrice}',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 20, right: 8, left: 10, bottom: 10),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.cyan),
                  ),
                  height: 40,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (_counter > 1) {
                              _counter--;
                              _calculatetotalamount();

                              if (basket.contains(widget.itemno)) {
                                buttonText = 'Update';
                              }
                            }
                          });
                        },
                      ),
                      Text(
                        '$_counter',
                        style: TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _counter++;
                            _calculatetotalamount();

                            if (basket.contains(widget.itemno)) {
                              buttonText = 'Update';
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  'LKR $totalamount',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            height: 5,
            color: Colors.grey[200],
            margin: EdgeInsets.symmetric(
                vertical: 10),
          ),
          SizedBox(height: 8),
          Expanded(
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                ' Description',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                ' ${widget.itemDescription}',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () async {
                //Store the item to the provider
                final fooditemsdetailsprovider =
                    Provider.of<FoodItemsDetailsProvider>(context,
                        listen: false);

                fooditemsdetailsprovider.addItemCountWithName(
                    widget.itemname, _counter);

                fooditemsdetailsprovider.addSelectedFoodItems(widget.itemno);

                Navigator.pop(context, 'refresh');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan[500],
                minimumSize: Size(MediaQuery.of(context).size.width, 50),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              child: Text(
                "$buttonText $_counter to Basket",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
