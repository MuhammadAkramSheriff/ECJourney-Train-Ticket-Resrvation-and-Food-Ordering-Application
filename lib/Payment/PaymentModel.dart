import 'package:flutter/cupertino.dart';

class PaymentDetailsProvider extends ChangeNotifier {
  late String _paymentid;
  late String _reservationid;
  int _totalticketamount = 0;
  late double _servicecharge;
  late double _totalamount;
  int _totalfoodprice = 0;
  int _returntotalticketamount = 0;

  String get paymentid => _paymentid;
  String get reservationid => _reservationid;
  int get totalticketamount => _totalticketamount;
  double get servicecharge => _servicecharge;
  double get totalamount => _totalamount;
  int get totalfoodprice => _totalfoodprice;
  int get returntotalticketamount => _returntotalticketamount;


  void addPaymentID(String paymentID) {
    _paymentid = paymentID;
    notifyListeners();
  }

  void addReservationID(String reservationID) {
    _reservationid = reservationID;
    notifyListeners();
  }

  void addTotalTicketAmount(int totalticketamount) {
    _totalticketamount = totalticketamount;
    notifyListeners();
  }

  void addReturnTotalTicketAmount(int returntotalticketamount) {
    _returntotalticketamount = returntotalticketamount;
    notifyListeners();
  }

  void addServiceCharge(double servicecharge) {
    _servicecharge = servicecharge;
    notifyListeners();
  }

  void addTotalAmount(double totalamount) {
    _totalamount = totalamount;
    notifyListeners();
  }

  void addTotalFoodPrice(int totalfoodprice) {
    _totalfoodprice = totalfoodprice;
    notifyListeners();
  }
}