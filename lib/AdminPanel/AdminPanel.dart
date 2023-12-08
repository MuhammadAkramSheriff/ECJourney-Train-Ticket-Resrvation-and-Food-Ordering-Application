import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import 'package:ecjourney/AdminPanel/AdminPanelDashboard.dart';
import 'package:ecjourney/AdminPanel/AppUsersDetails.dart';

import 'Food Info/FoodMenu.dart';
import 'Food Info/FoodOrders.dart';
import 'Train Info/AddSchedule.dart';
import 'Train Info/TrainSchedule.dart';



class AdminPanel extends StatefulWidget {
  static const String id = "home-screen";

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {

  Widget _selectedScreen = Dashboard();

  currentScreen(item){
    switch(item.route){
      case Dashboard.id :
        setState((){
          _selectedScreen = Dashboard();
        });
        break;
      case AppUserDetails.id :
        setState((){
          _selectedScreen = AppUserDetails();
        });
        break;
      case TrainSchedule.id :
        setState((){
          _selectedScreen = TrainSchedule();
        });
        break;
      case FoodMenu.id :
        setState((){
          _selectedScreen = FoodMenu();
        });
        break;
      case FoodOrders.id :
        setState((){
          _selectedScreen = FoodOrders();
        });
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.cyan[500],
        title: Center(child: const Text('ECJourney')),
      ),
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            route: Dashboard.id,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'User',
            route: AppUserDetails.id,
            icon: Icons.person,
          ),
          AdminMenuItem(
            title: 'Train Schedule',
            route: TrainSchedule.id,
            icon: Icons.train,
          ),
          AdminMenuItem(
            title: 'Food',
            icon: Icons.fastfood,
            children: [
              AdminMenuItem(
              title: 'Food Orders',
              route: FoodOrders.id,
              icon: Icons.receipt,
              ),
              AdminMenuItem(
                title: 'Food Menu',
                route: FoodMenu.id,
                icon: Icons.menu_book,
              ),
            ]
          ),

        ],
        selectedRoute: AdminPanel.id,
        onSelected: (item) {
          currentScreen(item);
          // if (item.route != null) {
          //   Navigator.of(context).pushNamed(item.route!);
          // }
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'Setup',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child:_selectedScreen,
      ),
    );
  }
}