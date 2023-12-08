import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JourneyDetailsProvider extends ChangeNotifier {
  late String _trainno;
  String? _reservationid;
  late String _from;
  late String _to;
  late String _date;
  late String _depart;
  late String _arrive;
  late int _passengercount;
  List<int> _selectedSeats = [];
  late int _ticketprice;
  // late int _totalticketamount;
  // late double _servicecharge;
  // late double _totalamount;

  String get trainno => _trainno;
  String? get reservationid => _reservationid;
  String get from => _from;
  String get to => _to;
  String get date => _date;
  String get depart => _depart;
  String get arrive => _arrive;
  int get passengercount => _passengercount;
  List<int> get selectedSeats => _selectedSeats;
  int get ticketprice => _ticketprice;
  // int get totalticketamount => _totalticketamount;
  // double get servicecharge => _servicecharge;
  // double get totalamount => _totalamount;

  void addTrainno(String trainNo) {
    _trainno = trainNo;
    notifyListeners();
  }

  void addReservationID(String reservationID) {
    _reservationid = reservationID;
    notifyListeners();
  }

  void addFrom(String from) {
    _from = from;
    notifyListeners();
  }

  void addTo(String to) {
    _to = to;
    notifyListeners();
  }

  void addDate(String date) {
    _date = date;
    notifyListeners();
  }

  void addDepart(String depart) {
    _depart = depart;
    notifyListeners();
  }

  void addArrive(String arrive) {
    _arrive = arrive;
    notifyListeners();
  }

  void addPassengercount(int passengercount) {
    _passengercount = passengercount;
    notifyListeners();
  }

  void addSelectedSeat(int seat) {
    _selectedSeats.add(seat);
    notifyListeners();
  }

  void addSelectedSeatFromDB(List<int> seat) {
    _selectedSeats.addAll(seat);
    notifyListeners();
  }

  void removeSelectedSeat(int seat) {
    _selectedSeats.remove(seat);
    notifyListeners();
  }

  void removeSelectedSeatAt(int indexno) {
    _selectedSeats.removeAt(indexno);
    notifyListeners();
  }

  void clearSelectedSeat(){
    _selectedSeats.clear();
    notifyListeners();
  }

  void addTicketPrice(int ticketprice) {
    _ticketprice = ticketprice;
    notifyListeners();
  }

  // void addTotalTicketAmount(int totalticketamount) {
  //   _totalticketamount = totalticketamount;
  //   notifyListeners();
  // }
  //
  // void addServiceCharge(double servicecharge) {
  //   _servicecharge = servicecharge;
  //   notifyListeners();
  // }
  //
  // void addTotalAmount(double totalamount) {
  //   _totalamount = totalamount;
  //   notifyListeners();
  // }
}

class ReturnJourneyDetailsProvider extends ChangeNotifier {
  String? _trainno;
  String? _reservationid;
  late String _from;
  late String _to;
  late String _date;
  late String _depart;
  late String _arrive;
  late int _passengercount;
  List<int> _selectedSeats = [];
  late int _ticketprice;

  String? get trainno => _trainno;
  String? get reservationid => _reservationid;
  String get from => _from;
  String get to => _to;
  String get date => _date;
  String get depart => _depart;
  String get arrive => _arrive;
  int get passengercount => _passengercount;
  List<int> get selectedSeats => _selectedSeats;
  int get ticketprice => _ticketprice;

  void addTrainno(String trainNo) {
    _trainno = trainNo;
    notifyListeners();
  }

  void addReservationID(String reservationID) {
    _reservationid = reservationID;
    notifyListeners();
  }

  void addFrom(String from) {
    _from = from;
    notifyListeners();
  }

  void addTo(String to) {
    _to = to;
    notifyListeners();
  }

  void addDate(String date) {
    _date = date;
    notifyListeners();
  }

  void addDepart(String depart) {
    _depart = depart;
    notifyListeners();
  }

  void addArrive(String arrive) {
    _arrive = arrive;
    notifyListeners();
  }

  void addPassengercount(int passengercount) {
    _passengercount = passengercount;
    notifyListeners();
  }

  void addSelectedSeat(int seat) {
    _selectedSeats.add(seat);
    notifyListeners();
  }

  void addSelectedSeatFromDB(List<int> seat) {
    _selectedSeats.addAll(seat);
    notifyListeners();
  }

  void removeSelectedSeat(int seat) {
    _selectedSeats.remove(seat);
    notifyListeners();
  }

  void removeSelectedSeatAt(int indexno) {
    _selectedSeats.removeAt(indexno);
    notifyListeners();
  }

  void clearSelectedSeat(){
    _selectedSeats.clear();
    notifyListeners();
  }

  void addTicketPrice (int ticketprice) {
    _ticketprice = ticketprice;
    notifyListeners();
  }
}
//
// class JourneyDataStorage {
//   Future<Map<String, dynamic>?> getJourneyDetails() async {
//     final prefs = await SharedPreferences.getInstance();
//     final from = prefs.getString('From');
//     final to = prefs.getString('To');
//     final trainNo = prefs.getString('TrainNo');
//     //final index = prefs.getInt('Index');
//     final isSingle = prefs.getBool('IsSingle');
//
//     //final index = prefs.getStringList('Index')?.map(int.parse).toList();
//     // final encodedIndexArray = prefs.getInt('Index');
//     // List<int>? index;
//     //
//     // if (encodedIndexArray != null) {
//     //   index = (jsonDecode(encodedIndexArray) as List<dynamic>).cast<int>();
//     // }
//
//
//
//     if (from != null && to != null) {
//       return {
//         'from': from,
//         'to': to,
//         'trainNo': trainNo,
//         //'index': index,
//         'isSingle': isSingle
//       };
//     }
//     return null;
//   }
//
//   // Future<void> clearUserDataLocally() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   prefs.remove('FirstName');
//   //   prefs.remove('LastName');
//   //   prefs.remove('EmailAddress');
//   //   prefs.remove('MobileNumber');
//   //   prefs.remove('NICNumber');
//   //   prefs.remove('PassportNumber');
//   // }
// }
