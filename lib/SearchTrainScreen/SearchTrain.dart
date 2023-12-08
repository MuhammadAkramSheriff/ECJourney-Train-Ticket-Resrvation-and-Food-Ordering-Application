import 'dart:ui';

import 'package:ecjourney/Common/SingleReturnTogglebar.dart';
import 'package:ecjourney/SessionTracking.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Common/Helper.dart';
import '../Models/UserModel/UserDetailsProvider.dart';
import 'SearchTrainScreenResources/DateFields.dart';
import 'SearchTrainScreenResources/Drawer.dart';
import 'SearchTrainScreenResources/PassengerCount.dart';
import 'SearchTrainScreenResources/StationListBottomSheet.dart';
import 'SearchTrainScreenResources/TicketTypeContainer.dart';
import 'SearchTrainScreenResources/connectingDots.dart';
import '../Waste/dropdownList.dart';
import '../Waste/Header.dart';
import '../Waste/LoginInputField.dart';
import '../SelectTrainScreen/SelectTrain.dart';
import 'SearchTrainScreenResources/executeOverLay.dart';

class SearchTrain extends StatefulWidget {

  @override
  State<SearchTrain> createState() => _SearchTrainState();
}

class _SearchTrainState extends State<SearchTrain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isReturnSelected = false;
  bool isSingleSelected = true;

  String selectedStart = 'Start';
  String selectedEnd = 'End';

  String departureDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String returnDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  int passengercount = 1;

 //Method to check if the user currently has a reservation
  void getReservationId() async {
    final prefs = await SharedPreferences.getInstance();
    final ridBeforeCheck = prefs.getString('Reservation ID');

    print('running sessiontrack at search train');
    await SessionTracking().deleteReservation(context, reservationid: ridBeforeCheck);
    final ridAfterCheck = prefs.getString('Reservation ID');

    setState(() {
      print('search tra: $ridAfterCheck');
      if (ridAfterCheck != null) {
        //If the user has a reservation, call showOverlay
        showOverlay(context);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getReservationId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      appBar: AppBar(
        title: const Text(
          "Search Train",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.cyan[700],
      ),
      drawer: CustomDrawer(onDrawerItemTap: removeOverlay),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container( //Backgorund Image
              padding: EdgeInsets.only(
                  top: 50.0, bottom: 0.0, right: 20.0, left: 20.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Train4.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                colors: [
                                  Colors.cyan.shade500,
                                  Colors.cyan.shade300,
                                  Colors.cyan.shade400
                                ]),
                          ),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  //Call DestinationConnector Class
                                  DestinationConnector(),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        //Call StationListButtonSheet class
                                        //to select and search stations
                                        StationListBottomSheet(
                                          bottomsheetTitle: "Select Start",
                                          selectedItem: selectedStart,
                                          onSelect: (station) {
                                            setState(() {
                                              selectedStart = station;
                                            });
                                          },
                                        ),
                                        SizedBox(height: 16),
                                        StationListBottomSheet(
                                          bottomsheetTitle: "Select End",
                                          selectedItem: selectedEnd,
                                          onSelect: (station) {
                                            setState(() {
                                              selectedEnd = station;
                                            });
                                          },
                                        ),
                                        // InkWell(
                                        //   onTap: () {
                                        //     _showBottomSheet(context);
                                        //   },
                                        //   child: Container(
                                        //     alignment: Alignment.centerLeft,
                                        //     decoration: BoxDecoration(
                                        //       color: Colors.white,
                                        //       borderRadius: BorderRadius.circular(8.0),
                                        //     ),
                                        //     padding: EdgeInsets.all(12.0),
                                        //     child: Text(
                                        //       "End",
                                        //       style: TextStyle(
                                        //         color: Colors.grey,
                                        //         fontSize: 16.0,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                        // dropdownList(
                                        //   items: Arrivalitems,
                                        //   selectedItem: ArrivalselectedItem,
                                        //   onChanged: (String? newValue) {
                                        //     setState(() {
                                        //       ArrivalselectedItem =
                                        //           newValue!;
                                        //     });
                                        //   },
                                        // ),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 6,
                                  offset: Offset(0, 2))
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          //Display Single and Return Button
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //Call TicketTypeContainer to allow the user to select
                                  //Single and Return ticket reservations
                                  TicketTypeContainer(
                                    arrowDirection: ArrowDirection.single,
                                    text: 'Single',
                                    isSelected: isSingleSelected,
                                    //To verify if the button is selected and make appropriate changes
                                    onSelectionChanged: (isSelected) {
                                      setState(() {
                                        if (isSelected) {
                                          isSingleSelected = true;
                                          isReturnSelected = false;
                                        }
                                      });
                                    },
                                  ),
                                  SizedBox(width: 30),
                                  TicketTypeContainer(
                                    arrowDirection: ArrowDirection.returning,
                                    text: 'Return',
                                    isSelected: isReturnSelected,
                                    onSelectionChanged: (isSelected) {
                                      setState(() {
                                        if (isSelected) {
                                          isReturnSelected = true;
                                          isSingleSelected = false;
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              //Display data selection based on the Ticket type selected(Single or Return)
                              DateFields(
                                isSingleSelected: isSingleSelected,
                                DepartureDate: (departDate) {
                                  setState(() {
                                    departureDate = departDate;
                                  });
                                },
                                ReturnDate: (ReturnDate) {
                                  setState(() {
                                    returnDate = ReturnDate;
                                  });
                                },
                              ),

                              SizedBox(height: 30),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Passenger Count",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              //Call passengerCount class to allow user
                              //to select passenger count
                              PassengerCount(passengerCount: (selectedCount) {
                                setState(() {
                                  passengercount = selectedCount;
                                });
                              }),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: TextButton(
                        onPressed: () {
                          //Navigate to select train screen
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SelectTrain(
                                      isSingleSelected: isSingleSelected,
                                      selectedStart: selectedStart,
                                      selectedEnd: selectedEnd,
                                      selectedDepartureDate: departureDate,
                                      selectedReturnDate: returnDate,
                                      selectedPassengerCount: passengercount)));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan[500],
                          minimumSize:
                              Size(MediaQuery.of(context).size.width, 50),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        child: Text(
                          "Search",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
