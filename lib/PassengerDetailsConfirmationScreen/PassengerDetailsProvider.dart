import 'package:flutter/cupertino.dart';

class PassengerDetailsProvider extends ChangeNotifier {
  late String _firstname;
  late String _lastname;
  late String _mobilenum;
  late String _email;
  String? _nicno;
  String? _passportno;

  String get firstname => _firstname;
  String get lastname => _lastname;
  String get email => _email;
  String get mobilenum => _mobilenum;
  String? get nicno => _nicno;
  String? get passportno => _passportno;


  void addFirstName(String firstname) {
    _firstname = firstname;
    notifyListeners();
  }

  void addLastName(String lastname) {
    _lastname = lastname;
    notifyListeners();
  }


  void addEmail(String email) {
    _email = email;
    notifyListeners();
  }


  void addMobileNum(String mobilenum) {
    _mobilenum = mobilenum;
    notifyListeners();
  }

  void addNicNo(String nicno) {
    _nicno = nicno;
    notifyListeners();
  }

  void addPassportNo(String passportno) {
    _passportno = passportno;
    notifyListeners();
  }

}