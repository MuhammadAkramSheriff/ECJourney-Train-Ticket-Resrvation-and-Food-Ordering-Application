import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Common/SingleReturnTogglebar.dart';
import '../FoodOrderingScreen/FoodItemsModel.dart';
import '../Models/Journey Model/JourneyDetailsProvider.dart';
import '../Payment/PaymentModel.dart';
import '../SeatSelectionScreen/SelectSeat.dart';
import 'SelectTrainScreenResources/TimeDuration.dart';
import 'SelectTrainScreenResources/TrainFiltration.dart';

class SelectTrain extends StatefulWidget {
  //const SelectTrain({Key? key}) : super(key: key);
  final String selectedStart;
  final String selectedEnd;
  final String selectedDepartureDate;
  final String selectedReturnDate;
  final bool isSingleSelected;
  final int selectedPassengerCount;

  SelectTrain(
      {required this.isSingleSelected,
      required this.selectedStart,
      required this.selectedEnd,
      required this.selectedDepartureDate,
      required this.selectedReturnDate,
      required this.selectedPassengerCount});

  @override
  State<SelectTrain> createState() => _SelectTrain();
}

class _SelectTrain extends State<SelectTrain> {
  int selectedSingleListItemIndex = -1;
  int selectedReturnListItemIndex = -1;

  bool isReturnSelected = false;
  bool isSingleSelected = true;

  //Query dbRef = FirebaseDatabase.instance.ref().child('Train Schedule');
  DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('Train Schedule');

  TrainDataManager filteredTrainData = TrainDataManager();

  late String trainNo;
  late String Date;
  late String startStation;
  late String endStation;
  late String departTime;
  late String arriveTime;
  late int passengerCount = widget.selectedPassengerCount;
  late int ticketPrice;
  late int totalTicketAmount = (ticketPrice * passengerCount);

  //late double serviceCharge = (totalTicketAmount * (8/100));
  //late double totalAmount = (totalTicketAmount + serviceCharge);

  String? returnTrainNo;
  String? returnDate;
  String? returnStartStation;
  String? returnEndStation;
  String? returnDepartTime;
  String? returnArriveTime;
  int? returnTicketPrice;
  late int returnTotalTicketAmount = (returnTicketPrice! * passengerCount);

  @override
  void initState() {
    super.initState();
    fetchDataAndFilter();

    // reference
    //     .orderByChild('Start Station') // Filter by Start Station
    //     .equalTo(widget.selectedStart) // Match the selectedStart
    //     .once()
    //     .then((DatabaseEvent event) {
    //   // Handle the event
    //   if (event.snapshot.value != null &&
    //       event.snapshot.value is Map<dynamic, dynamic>) {
    //     Map<dynamic, dynamic> data = event.snapshot.value as Map<
    //         dynamic,
    //         dynamic>;
    //     List<Map<dynamic, dynamic>> matchingTrains = data.values.toList().cast<
    //         Map<dynamic, dynamic>>();
    //
    //     filteredSingleTrains = matchingTrains.where((train) {
    //       return train['End Station'] == widget.selectedEnd &&
    //           train['Date'] == widget.selectedDepartureDate.toString() &&
    //           train['Seats Availability'] >= widget.selectedPassengerCount;
    //     }).toList();
    //     print(widget.selectedDepartureDate);
    //     print(filteredSingleTrains);
    //
    //     filteredReturnTrains = matchingTrains.where((train) {
    //       return train['End Station'] == widget.selectedEnd &&
    //           train['Date'] == widget.selectedReturnDate.toString() &&
    //           train['Seats Availability'] >= widget.selectedPassengerCount;
    //     }).toList();
    //     print(widget.selectedReturnDate);
    //
    //     filteredSingleSeatsAvailability = matchingTrains.where((train) {
    //       return train['End Station'] == widget.selectedEnd  &&
    //           train['Date'] == widget.selectedDepartureDate.toString() &&
    //           train['Seats Availability'] < widget.selectedPassengerCount;
    //     }).toList();
    //
    //     filteredReturnSeatsAvailability = matchingTrains.where((train) {
    //       return train['End Station'] == widget.selectedEnd  &&
    //           train['Date'] == widget.selectedReturnDate.toString() &&
    //           train['Seats Availability'] < widget.selectedPassengerCount;
    //     }).toList();
    //
    //     setState(() {});

//         List<Train> matchingTrainss = data.values.map((trainData) {
//           final train = Train(
//             trainNo: trainData['Train No'],
//             startStation: trainData['Start Station'],
//             endStation: trainData['End Station'],
//             date: trainData['Date'],
//             seatsAvailability: trainData['Seats Availability'],
//             meetsPassengerCountCriteria: trainData['End Station'] == widget.selectedEnd &&
//                 trainData['Date'] == widget.selectedDepartureDate.toString() &&
//                 trainData['Seats Availability'] >= widget.selectedPassengerCount,
//           );
//           return train;
//         }).toList();
//
// // Filter based on departure or return (you can adjust this based on your conditions)
//         filteredTrains = matchingTrainss.where((train) {
//           return widget.isSingleSelected
//               ? train.date == widget.selectedDepartureDate.toString()
//               : train.date == widget.selectedReturnDate.toString();
//         }).toList();
//         print(filteredTrains);
//       }
//     });
  }

  Future<void> fetchDataAndFilter() async {
    await filteredTrainData.fetchDataAndFilter(
      selectedStart: widget.selectedStart,
      selectedEnd: widget.selectedEnd,
      selectedDepartureDate: widget.selectedDepartureDate,
      selectedReturnDate: widget.selectedReturnDate,
      selectedPassengerCount: widget.selectedPassengerCount,
    );
    setState(() {});
  }

  //ListView Builder will return the listitem to display trains
  Widget listItem({
    required Map train,
    required bool isSelected,
    required Function onTap,
    bool isSelectable = true,
  }) {
    String TrainNo = train['Train No'];
    String StartStation = train['Start Station'];
    String EndStation = train['End Station'];
    String date = train['Date'];
    String departsTime = train['Departs'];
    String arriveTime = train['Arrive'];
    int price = train['Price'];

    TimeDuration result =
        calculateHoursAndMinutes(date, departsTime, arriveTime);
    int hours = result.hours;
    int minutes = result.minutes;

    return GestureDetector(
      //pass the trian details on tap
      onTap: isSelectable
          ? () => onTap(TrainNo, date, StartStation, EndStation, departsTime,
              arriveTime, price)
          : null,
      child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.green[300]
                : (isSelectable ? Colors.blue[50] : Colors.grey[200]),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.train,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: ' $TrainNo',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        TextSpan(
                          text: '  $StartStation ',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                        WidgetSpan(
                          child: Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: ' $EndStation',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Divider(),
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: ' $departsTime',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      TextSpan(
                        text: ' $hours' 'h $minutes' 'min',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.black),
                      ),
                      TextSpan(
                        text: ' $arriveTime',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(),
              Row(
                children: [
                  Icon(Icons.airline_seat_recline_extra,
                      size: 24, color: Colors.orange[300]),
                  Text(
                    '${train['Seats Availability']} ',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Text(
                    'Seats available',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Rs. $price',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Train',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.cyan[700],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        height: double.infinity,
        child: Column(
          children: [
            //Call SingleReturnToggleBar to allow user
            //to select single and return trains, if applicable
            SingleReturnTogglebar(
              isSingleSelected: widget.isSingleSelected,
              isToggleSingleSelected: (isSelected) {
                setState(() {
                  if (isSelected) {
                    isSingleSelected = true;
                    isReturnSelected = false;
                  }
                });
              },
              isToggleReturnSelected: (isSelected) {
                setState(() {
                  if (isSelected) {
                    isSingleSelected = false;
                    isReturnSelected = true;
                  }
                });
              },
            ),
            // if (widget.isSingleSelected)
            //   Row(
            //     children: [
            //       Expanded(
            //         child: Padding(
            //           padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            //           child: TextButton(
            //           onPressed: () {
            //             setState(() {
            //               isSingleSelected = true;
            //               isReturnSelected = false;
            //             });
            //           },
            //           style: TextButton.styleFrom(
            //             backgroundColor: SinglebuttonColor,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.all(Radius.circular(5.0)),
            //             ),
            //           ),
            //           child: Text("Single",
            //               style: TextStyle(color: SingletextColor, fontWeight: FontWeight.w500)
            //           ),
            //       ),
            //         ),
            //       ),
            //     ],
            //   ),
            //
            // if (!widget.isSingleSelected)
            // Row(
            //   children: [
            //     Expanded(
            //       child: Padding(
            //         padding: const EdgeInsets.only(left: 10.0),
            //         child: TextButton(
            //           onPressed: () {
            //             setState(() {
            //               isSingleSelected = true;
            //               isReturnSelected = false;
            //             });
            //           },
            //           style: TextButton.styleFrom(
            //             backgroundColor: SinglebuttonColor,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.only(
            //                 topLeft: Radius.circular(5.0),
            //                 bottomLeft: Radius.circular(5.0),
            //               ),
            //             ),
            //           ),
            //           child: Text("Single",
            //               style: TextStyle(color: SingletextColor, fontWeight: FontWeight.w500)
            //           ),
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       child: Padding(
            //         padding: const EdgeInsets.only(right: 10.0),
            //         child: TextButton(
            //           onPressed: () {
            //             setState(() {
            //               isSingleSelected = false;
            //               isReturnSelected = true;
            //             });
            //           },
            //           style: TextButton.styleFrom(
            //             backgroundColor: ReturnbuttonColor,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.only(
            //                 topRight: Radius.circular(5.0),
            //                 bottomRight: Radius.circular(5.0),
            //               ),
            //             ),
            //           ),
            //           child: Text("Return",
            //           style: TextStyle(color: ReturntextColor, fontWeight: FontWeight.w500)
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),

            //Display the filtered trains using ListView Builder
            if (isSingleSelected)
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTrainData.filteredSingleTrains.length +
                      filteredTrainData.filteredSingleSeatsAvailability.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < filteredTrainData.filteredSingleTrains.length) {
                      Map train = filteredTrainData.filteredSingleTrains[index];
                      return listItem(
                        train: train,
                        isSelected: index == selectedSingleListItemIndex,
                        onTap: ( //get the train details on user tap
                            String trainno,
                            String date,
                            String startstation,
                            String endstation,
                            String departtime,
                            String arrivetime,
                            int price) {
                          setState(() { //assign the retrieved details to a variable
                            selectedSingleListItemIndex = index;
                            trainNo = trainno;
                            Date = date;
                            startStation = startstation;
                            endStation = endstation;
                            departTime = departtime;
                            arriveTime = arrivetime;
                            ticketPrice = price;
                            print(trainno);
                          });
                        },
                      );
                      //Display the available train with less seats availability
                      //compared to users passenger count
                    } else {
                      int adjustedIndex =
                          index - filteredTrainData.filteredSingleTrains.length;
                      Map train = filteredTrainData
                          .filteredSingleSeatsAvailability[adjustedIndex];
                      return listItem(
                        train: train,
                        isSelected: false,
                        onTap: () {},
                        isSelectable: false,
                      );
                    }
                  },
                ),
              ),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: filteredTrainData.filteredSingleTrains.length,
            //     itemBuilder: (BuildContext context, int index) {
            //       Map train = filteredTrainData.filteredSingleTrains[index]; // Use Train type here
            //       return listItem(
            //         train: train, // If needed, convert the Train object to a Map
            //         isSelected: index == selectedSingleListItemIndex,
            //         onTap: (String trainno) {
            //           setState(() {
            //             selectedSingleListItemIndex = index;
            //             //trainNo = trainno;
            //           });
            //         },
            //       );
            //     },
            //   ),
            // ),
            //Display filtered trains for return
            if (isReturnSelected)
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTrainData.filteredReturnTrains.length +
                      filteredTrainData.filteredReturnSeatsAvailability.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < filteredTrainData.filteredReturnTrains.length) {
                      Map train = filteredTrainData.filteredReturnTrains[index];
                      return listItem(
                        train: train,
                        isSelected: index == selectedReturnListItemIndex,
                        onTap: ( //get the train details on user tap
                            String trainno,
                            String date,
                            String startstation,
                            String endstation,
                            String departtime,
                            String arrivetime,
                            int price) {
                          setState(() { //assign the retrived details to the variable
                            selectedReturnListItemIndex = index;
                            returnTrainNo = trainno;
                            returnDate = date;
                            returnStartStation = startstation;
                            returnEndStation = endstation;
                            returnDepartTime = departtime;
                            returnArriveTime = arrivetime;
                            returnTicketPrice = price;
                            print(trainno);
                          });
                        },
                      );
                      //Display the filtered trains with less seat availability
                      //compared to passenger count
                    } else {
                      int adjustedIndex =
                          index - filteredTrainData.filteredReturnTrains.length;
                      Map train = filteredTrainData
                          .filteredReturnSeatsAvailability[adjustedIndex];
                      return listItem(
                        train: train,
                        isSelected: false,
                        onTap: () {},
                        isSelectable: false,
                      );
                    }
                  },
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  onPressed: () async {
                    //Naviagte user to select seat screen if user has selected a train
                    if (widget.isSingleSelected &&
                        selectedSingleListItemIndex != -1) {
                      // final prefs = await SharedPreferences.getInstance();
                      // prefs.setString('From', startStation);
                      // prefs.setString('To', endStation);
                      // prefs.setString('TrainNo', singletrainNo);
                      // prefs.setBool('isSingle', isSingleSelected);

                      //Store all the user selected train details to provider
                      final journeyDetailsProvider =
                          Provider.of<JourneyDetailsProvider>(context,
                              listen: false);
                      journeyDetailsProvider.addTrainno(trainNo);
                      journeyDetailsProvider.addFrom(startStation);
                      journeyDetailsProvider.addTo(endStation);
                      journeyDetailsProvider.addDate(Date);
                      journeyDetailsProvider.addDepart(departTime);
                      journeyDetailsProvider.addArrive(arriveTime);
                      journeyDetailsProvider.addPassengercount(passengerCount);
                      journeyDetailsProvider.addTicketPrice(ticketPrice);

                      final paymentDetailsProvider =
                          Provider.of<PaymentDetailsProvider>(context,
                              listen: false);
                      paymentDetailsProvider
                          .addTotalTicketAmount(totalTicketAmount);

                      final foodDetailsProvider =
                          Provider.of<FoodItemsDetailsProvider>(context,
                              listen: false);
                      foodDetailsProvider.addTrainno(trainNo);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => SelectSeat(
                                  isSingleSelected: widget.isSingleSelected,
                                  singleTrainNo: trainNo,
                                  returnTrainNo: returnTrainNo)));
                    }
                    //Navigate user to select seat screen
                    //if single and return train selected (if applicable)
                    else if (selectedSingleListItemIndex != -1 &&
                        selectedReturnListItemIndex != -1) {

                      //Store the selected trian details to provider
                      final journeyDetailsProvider =
                          Provider.of<JourneyDetailsProvider>(context,
                              listen: false);
                      journeyDetailsProvider.addTrainno(trainNo);
                      journeyDetailsProvider.addFrom(startStation);
                      journeyDetailsProvider.addTo(endStation);
                      journeyDetailsProvider.addDate(Date);
                      journeyDetailsProvider.addDepart(departTime);
                      journeyDetailsProvider.addArrive(arriveTime);
                      journeyDetailsProvider.addPassengercount(passengerCount);
                      journeyDetailsProvider.addTicketPrice(ticketPrice);
                      // journeyDetailsProvider.addTotalTicketAmount(totalTicketAmount);
                      // journeyDetailsProvider.addServiceCharge(serviceCharge);
                      // journeyDetailsProvider.addTotalAmount(totalAmount);

                      //Store the selected return train details to provider
                      final ReturnjourneyDetailsProvider =
                          Provider.of<ReturnJourneyDetailsProvider>(context,
                              listen: false);
                      ReturnjourneyDetailsProvider.addTrainno(
                          returnTrainNo ?? '');
                      ReturnjourneyDetailsProvider.addFrom(
                          returnStartStation ?? '');
                      ReturnjourneyDetailsProvider.addTo(
                          returnEndStation ?? '');
                      ReturnjourneyDetailsProvider.addDate(returnDate ?? '');
                      ReturnjourneyDetailsProvider.addDepart(
                          returnDepartTime ?? '');
                      ReturnjourneyDetailsProvider.addArrive(
                          returnArriveTime ?? '');
                      ReturnjourneyDetailsProvider.addPassengercount(
                          passengerCount);
                      ReturnjourneyDetailsProvider.addTicketPrice(
                          returnTicketPrice!);

                      final paymentDetailsProvider =
                          Provider.of<PaymentDetailsProvider>(context,
                              listen: false);
                      paymentDetailsProvider
                          .addTotalTicketAmount(totalTicketAmount);
                      paymentDetailsProvider
                          .addReturnTotalTicketAmount(returnTotalTicketAmount);

                      final foodDetailsProvider =
                          Provider.of<FoodItemsDetailsProvider>(context,
                              listen: false);
                      foodDetailsProvider.addTrainno(trainNo);

                      print(returnTrainNo);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => SelectSeat(
                                  isSingleSelected: widget.isSingleSelected,
                                  singleTrainNo: trainNo,
                                  returnTrainNo: returnTrainNo)));
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
                    "Next",
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
      ),
    );
  }
}
