import 'package:ecjourney/LoginScreen/LoginPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Common/Helper.dart';
import '../../FoodOrderingScreen/FoodItemsModel.dart';
import '../../FoodOrderingScreen/FoodMenuScreen.dart';
import '../../FoodOrderingScreen/FoodOrders/FoodOrders.dart';
import '../../FoodOrderingScreen/accessVerifier.dart';
import '../../Models/Journey Model/JourneyDetailsProvider.dart';
import '../../Models/UserReservationTracking.dart';
import '../../Payment/RecieptScreen/recieptScreenForReservation.dart';
import '../../SessionTracking.dart';
import '../../SessionTracking.dart';
import '../../ViewReservation.dart';
import '../../firebase_auth_services.dart';
import 'executeOverLay.dart';



class CustomDrawer extends StatefulWidget {

  final VoidCallback onDrawerItemTap;

  CustomDrawer({required this.onDrawerItemTap});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(height: 50),
          ListTile(
            leading: Icon(Icons.train),
            title: Text('Reservations'),
            onTap: () {
              setState(() {
                //Remove overLay
                widget.onDrawerItemTap();
              });
              //Naviagte to Reservation Receipt Screen
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RecieptScreenForReservation(newReciept: false)));
            },
          ),
          ListTile(
            leading: Icon(Icons.fastfood),
            title: Text('Food Orders'),
            onTap: () {
              setState(() {
                //Remove overLay
                widget.onDrawerItemTap();
              });
              //Naviagte to Food orders screen
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FoodOrdersScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.local_dining),
            title: Text('Order Food'),
            onTap: () async {
              //Get the reservation ID
              final prefs = await SharedPreferences.getInstance();
              final reservationid = prefs.getString('Reservation ID');

              //If reservation ID is not null, remove overLay
              if (reservationid != null) {
                if (widget.onDrawerItemTap != null) {
                  setState(() {
                    widget.onDrawerItemTap();
                  });
                }

                //Naviagte to Food Menu Screen
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FoodMenuScreen(status: 'From Drawer')));

                //If reservation ID is null, print message
              }else{
                showToastError('No Exisiting Reservations To Order Food');
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onTap: () {
              //Remove overLay
              if (widget.onDrawerItemTap != null) {
                setState(() {
                  widget.onDrawerItemTap();
                });
              }
              //Call firebase signout service
              final FirebaseAuthService _auth = FirebaseAuthService();
              _auth.signOut(context);
              //Navigate to Sign-in Screen
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}