import 'dart:convert';

import 'package:ecjourney/SeatSelectionScreen/seatpickerController.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Common/PopUpMessage.dart';
import '../Common/SingleReturnTogglebar.dart';
import '../FoodOrderingScreen/FoodOrderingNaviagtionScreen.dart';
import '../Models/Journey Model/JourneyDetailsProvider.dart';
import '../PassengerDetailsConfirmationScreen/PassengerDetailsConfirmationScreen.dart';
import '../ReservationDetailsConfirmationScreen/ReservationDetailsConfirmationScreen.dart';
import 'SelectSeatFunctions.dart';

class SelectSeat extends StatefulWidget {
  bool isSingleSelected;
  String singleTrainNo;
  String? returnTrainNo;

  SelectSeat(
      {required this.isSingleSelected,
      required this.singleTrainNo,
      required this.returnTrainNo});

  @override
  State<SelectSeat> createState() => _SelectSeat();
}

class _SelectSeat extends State<SelectSeat> {
  List<int> currentUserSelectedSeats = [];
  List<int> selectedSeatsByOthers = [];

  List<int> currentUserSelectedSeatsForReturn = [];
  List<int> selectedSeatsByOthersForReturn = [];

  bool isReturnSelected = false;
  bool isSingleSelected = true;

  //DatabaseReference _databaseReference = FirebaseDatabase.instance.ref().child('Train Schedule');
  DatabaseReference _ssdatabaseReference =
      FirebaseDatabase.instance.ref().child('Reservations');

  //SelectSeatFunctions selectseat = SelectSeatFunctions();
  //JourneyDataStorage journeyDataStorage = JourneyDataStorage();

  // void _loadJourneyDetails() async {
  //   Map<String, dynamic>? journeyDetails = await journeyDataStorage.getJourneyDetails();
  //
  //   if (journeyDetails != null) {
  //     String trainNo = journeyDetails['trainNo'];
  //     selectseat.loadSelectedSeats(trainNo); // Pass the trainNo to your function
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // final journeyDetailsProvider = Provider.of<JourneyDetailsProvider>(context, listen: false);
    // final ReturnjourneyDetailsProvider = Provider.of<ReturnJourneyDetailsProvider>(context, listen: false);
    // String? trainno = ReturnjourneyDetailsProvider.trainno;
    _loadSelectedSeats(widget.singleTrainNo);
    _loadSelectedSeatsForReturn(widget.returnTrainNo);
  }

  //Method to fetch and update the selected seat by others
  void _loadSelectedSeats(String trainNo) {
    print(trainNo);
    _ssdatabaseReference.once().then((DatabaseEvent event) {
      Map<dynamic, dynamic>? reservations =
          event.snapshot.value as Map<dynamic, dynamic>;

      if (reservations != null) {
        for (String reservationId in reservations.keys) {
          print('reservationid: $reservationId');
          // For each reservation ID, access Train Details
          _ssdatabaseReference
              .child(reservationId)
              .child('Train Details')
              .once()
              .then((DatabaseEvent trainnos) {
            Map<dynamic, dynamic>? trainDetails =
                trainnos.snapshot.value as Map<dynamic, dynamic>;

            if (trainDetails != null) {
              print('inTrainDetails: $trainDetails');
              // Iterate over Train Details and filter by trainNo
              trainDetails.forEach((key, value) {
                if (trainDetails.containsValue(trainNo)) {
                  // Access seat number or any other relevant informatio
                  if (trainDetails.containsKey('Seat No')) {
                    List<int> usedseatList =
                        List<int>.from(trainDetails['Seat No']);
                    setState(() {
                      //currentUserSelectedSeats.clear();
                      selectedSeatsByOthers.addAll(
                          usedseatList.map<int>((seat) => seat - 1).toList());
                    });
                  }
                }
              });
            } else {
              print('No reservations found.');
            }
          });

          // _ssdatabaseReference
          //     .child(singletrainNo)
          //     .child('Used Seat')
          //     .once()
          //     .then((DatabaseEvent event) {
          //   if (event.snapshot.value != null) {
          //     final List<dynamic> usedseatList = (event.snapshot.value as List<dynamic>);
          //     setState(() {
          //       selectedSeats.clear();
          //       usedSeats.addAll(usedseatList.cast<int>());
          //     });
          //   }
          // }).catchError((error) {
          //   // Handle any errors here
          //   print('Error loading selected seats: $error');
          // });
        }
      }
    });
  }

  //Method to fetch and update the UI with the selected by others for return
  void _loadSelectedSeatsForReturn(String? returntrainNo) {
    if (returntrainNo != null) {
      print('insded return load');
      _ssdatabaseReference.once().then((DatabaseEvent event) {
        Map<dynamic, dynamic>? reservations =
            event.snapshot.value as Map<dynamic, dynamic>;
        print('reservation in seat: $reservations');

        if (reservations != null) {
          for (String reservationId in reservations.keys) {
            print('reservationid: $reservationId');
            // For each reservation ID, access Train Details
            _ssdatabaseReference
                .child(reservationId)
                .child('Train Details')
                .once()
                .then((DatabaseEvent trainnos) {
              Map<dynamic, dynamic>? trainDetails =
                  trainnos.snapshot.value as Map<dynamic, dynamic>;

              if (trainDetails != null) {
                print('inTrainDetails: $trainDetails');
                // Iterate over Train Details and filter by trainNo
                trainDetails.forEach((key, value) {
                  if (trainDetails.containsValue(returntrainNo)) {
                    // Access seat number or any other relevant informatio
                    if (trainDetails.containsKey('Seat No')) {
                      List<int> usedseatList =
                          List<int>.from(trainDetails['Seat No']);
                      setState(() {
                        currentUserSelectedSeatsForReturn.clear();
                        selectedSeatsByOthersForReturn.addAll(
                            usedseatList.map<int>((seat) => seat - 1).toList());
                      });
                    }
                  }
                });
              } else {
                print('No reservations found.');
              }
            });
          }
        }
      });
    }
  }

  //Method to update the seat based on current user selection
  void updateSeat(int index) {
    //increase the seatnum by one since the current index start from 0
    int seatNum = index + 1;

    final journeyDetailsProvider =
        Provider.of<JourneyDetailsProvider>(context, listen: false);
    final ReturnjourneyDetailsProvider =
        Provider.of<ReturnJourneyDetailsProvider>(context, listen: false);


    if (selectedSeatsByOthers.contains(index)) return;

    //Add and remove user selected seats to the List
    if (isSingleSelected) {
      //Check if the current user selected seat is not already in the List
      if (!currentUserSelectedSeats.contains(index)) {
        //If the user select seat exceeding the passenger count
        //remove the seat number at index 0
        //Add the recent selected seat
        if (currentUserSelectedSeats.length >=
            journeyDetailsProvider.passengercount) {
          currentUserSelectedSeats.removeAt(0);
          journeyDetailsProvider.removeSelectedSeatAt(0);
        }
        //Add the user selected seat to the List
        currentUserSelectedSeats.add(index);
        //selectedSeats.add(index);
        journeyDetailsProvider.addSelectedSeat(seatNum);

        //ReturnjourneyDetailsProvider.addSelectedSeat(index);
      }
      //If the current user selected seat is already in the List
      //Remove the index
      else {
        currentUserSelectedSeats.remove(index);
        //selectedSeats.add(index);
        journeyDetailsProvider.removeSelectedSeat(seatNum);
        //ReturnjourneyDetailsProvider.removeSelectedSeat(index);
      }
    }

    //Add and remove user selected seats for return to the List
    if (isReturnSelected) {
      //Check if the current user selected seat for return
      //is not already in the List
      if (!currentUserSelectedSeatsForReturn.contains(index)) {
        //If the user select seat exceeding the passenger count
        //remove the seat number at index 0
        //Add the recent selected seat for return
        if (currentUserSelectedSeatsForReturn.length >=
            journeyDetailsProvider.passengercount) {
          currentUserSelectedSeatsForReturn.removeAt(0);
          ReturnjourneyDetailsProvider.removeSelectedSeatAt(0);
        }
        //Add the user selected seat to the List
        currentUserSelectedSeatsForReturn.add(index);
        //selectedSeats.add(index);
        ReturnjourneyDetailsProvider.addSelectedSeat(seatNum);
      }
      //If the current user selected seat for return is already in the List
      //Remove the index
      else {
        currentUserSelectedSeatsForReturn.remove(index);
        //selectedSeats.add(index);
        ReturnjourneyDetailsProvider.removeSelectedSeat(seatNum);
      }
    }

    List<int> selectedseats = journeyDetailsProvider.selectedSeats;

    List<int>? rselectedseats = ReturnjourneyDetailsProvider.selectedSeats;
    print('single $selectedseats return: $rselectedseats');

    //selectedSeats.clear();
    //selectedSeats.addAll(usedSeats);
    // selectseat.usedSeats.addAll(usedSeats);
    // selectseat.selectedSeats.addAll(usedSeats);

    print('$currentUserSelectedSeats $currentUserSelectedSeatsForReturn');

    //saveSelectedSeats(widget.singletrainNo);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //Initialize proivder and get the ticket price
    final journeyDetailsProvider =
        Provider.of<JourneyDetailsProvider>(context, listen: false);
    int ticketPrice =
        journeyDetailsProvider.ticketprice * currentUserSelectedSeats.length;
    int returnTicketPrice = 0;

    final ReturnjourneyDetailsProvider =
        Provider.of<ReturnJourneyDetailsProvider>(context, listen: false);
    if (!isSingleSelected) {
      returnTicketPrice = ReturnjourneyDetailsProvider.ticketprice *
          currentUserSelectedSeatsForReturn.length;
    }

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            //clear the selected seats of current user when the user go back
            final journeyDetailsProvider =
                Provider.of<JourneyDetailsProvider>(context, listen: false);
            final ReturnjourneyDetailsProvider =
                Provider.of<ReturnJourneyDetailsProvider>(context,
                    listen: false);
            journeyDetailsProvider.clearSelectedSeat();
            ReturnjourneyDetailsProvider.clearSelectedSeat();
          },
          child: Icon(Icons.arrow_back),
        ),
        title: const Text(
          "Select Seat",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.cyan[700],
      ),
      body: Container(
        color: Colors.blue[50],
        child: Column(children: [
          //Call SingleReturnToggleBar class to allow
          //User to select seats for return ticket (if applicable)
          SingleReturnTogglebar(
            isSingleSelected: widget.isSingleSelected,
            isToggleSingleSelected: (isSelected) {
              setState(() {
                selectedSeatsByOthers.clear();
                _loadSelectedSeats(widget.singleTrainNo);
                if (isSelected) {
                  isSingleSelected = true;
                  isReturnSelected = false;
                }
              });
            },
            isToggleReturnSelected: (isSelected) {
              setState(() {
                final ReturnjourneyDetailsProvider =
                    Provider.of<ReturnJourneyDetailsProvider>(context,
                        listen: false);
                String? trainno = ReturnjourneyDetailsProvider.trainno;
                selectedSeatsByOthers.clear();
                _loadSelectedSeats(trainno!);
                if (isSelected) {
                  isSingleSelected = false;
                  isReturnSelected = true;
                }
              });
            },
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.blue[50],
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.square,
                          size: 24.0,
                          color: Color(0xff1aa84b),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "Available",
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Icon(
                          Icons.square,
                          size: 24.0,
                          color: Color(0xfff8c321),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "Selected",
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(width: 15.0),
                        Icon(
                          Icons.square,
                          size: 24.0,
                          color: Color(0xffe4e4e4),
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          "Unavailable",
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width -
                                  (2 * 20.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.elliptical(150.0, 300.0),
                                  topRight: Radius.elliptical(150.0, 300.0),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 40,
                                    left: 30,
                                    right: 30,
                                    child: Container(
                                      height: 60,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffd9d9d9),
                                        borderRadius: BorderRadius.only(
                                          topLeft:
                                              Radius.elliptical(200.0, 300.0),
                                          topRight:
                                              Radius.elliptical(200.0, 300.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width -
                                  (2 * 20.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 30,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xfffdc620),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: const Text(
                                        "eBooking Class",
                                        style: TextStyle(
                                          color: Color(0xff383d47),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: LayoutBuilder(
                                        builder: (context, constraints) {
                                      double spacing = 6;
                                      var size =
                                          (constraints.biggest.width / 5.7);
                                      return Wrap(
                                        runSpacing: spacing,
                                        spacing: spacing,
                                        children: List.generate(
                                          60,
                                          (index) {
                                            var number = (index + 1)
                                                .toString()
                                                .padLeft(2, "0");
                                            late bool selected;bool selectedSeatByOther =
                                                  selectedSeatsByOthers.contains(index);

                                            //Add selected seat by current user to the list
                                            if (isReturnSelected) {
                                              selected =
                                                  currentUserSelectedSeatsForReturn
                                                      .contains(index);
                                            } else {
                                              selected =
                                                  currentUserSelectedSeats
                                                      .contains(index);
                                            }

                                            var color = const Color(0xff1ba44a);
                                            if (selectedSeatByOther) {
                                              color = const Color(0xffe4e4e4);
                                            } else if (selected) {
                                              color = const Color(0xfffdc620);
                                            }

                                            return InkWell(
                                              onTap: () async {
                                                //add and remove seat when user tap
                                                updateSeat(index);
                                              },
                                              child: Container(
                                                height: size,
                                                width: size,
                                                margin: EdgeInsets.only(
                                                    right: (index + 1) % 2 ==
                                                                0 &&
                                                            (index + 1) % 4 != 0
                                                        ? 20
                                                        : 0),
                                                decoration: BoxDecoration(
                                                  color: color,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(
                                                      8.0,
                                                    ),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    number,
                                                    style: TextStyle(
                                                        color:
                                                            selectedSeatByOther
                                                                ? Colors
                                                                    .grey[500]
                                                                : selected
                                                                    ? const Color(
                                                                        0xff393e48)
                                                                    : Colors
                                                                        .white,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
      bottomNavigationBar: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.cyan,
                  width: 4.0,
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Selected Seat",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[500],
                      ),
                    ),
                    if (isSingleSelected)
                      Text(
                        currentUserSelectedSeats
                            .map((intNumber) => intNumber.toString())
                            .join(', '),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (isReturnSelected)
                      Text(
                        currentUserSelectedSeatsForReturn
                            .map((intNumber) => intNumber.toString())
                            .join(', '),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Price",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[500],
                      ),
                    ),
                    if (isSingleSelected)
                      Text(
                        ticketPrice.toString(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (isReturnSelected)
                      Text(
                        returnTicketPrice.toString(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
                SizedBox(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    onPressed: () async {
                      final journeyDetailsProvider =
                          Provider.of<JourneyDetailsProvider>(context,
                              listen: false);

                      //Naviagate to next screen if the user has selected the seat
                      if (widget.isSingleSelected &&
                          currentUserSelectedSeats.length ==
                              journeyDetailsProvider.passengercount) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PassengerDetailsConfirmation(
                                    showDialog: true)));
                      } else if (!widget.isSingleSelected &&
                          currentUserSelectedSeats.length ==
                              journeyDetailsProvider.passengercount &&
                          currentUserSelectedSeatsForReturn.length ==
                              journeyDetailsProvider.passengercount) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PassengerDetailsConfirmation(
                                    showDialog: true)));
                      } else {
                        print(
                            'maximum seat count: ${journeyDetailsProvider.passengercount}');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan[500],
                      minimumSize: Size(MediaQuery.of(context).size.width, 50),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                    child: Text(
                      "Confirm Seat",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
