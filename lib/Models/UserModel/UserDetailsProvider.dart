import 'package:shared_preferences/shared_preferences.dart';
import 'UserDetailsModel.dart';

class UserDataStorage {
  Future<Map<String, dynamic>?> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final firstName = prefs.getString('FirstName');
    final lastName = prefs.getString('LastName');
    final Email = prefs.getString('EmailAddress');
    final mobileNum = prefs.getString('MobileNumber');
    final NICNo = prefs.getString('NICNumber');
    final passportNo = prefs.getString('PassportNumber');

    if (firstName != null && lastName != null) {
      return {
        'firstName': firstName,
        'lastName': lastName,
        'Email': Email,
        'mobileNum': mobileNum,
        'NICNo': NICNo,
        'passportNo': passportNo,
      };
    }
    return null;
  }

  Future<void> clearUserDataLocally() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('FirstName');
    prefs.remove('LastName');
    prefs.remove('EmailAddress');
    prefs.remove('MobileNumber');
    prefs.remove('NICNumber');
    prefs.remove('PassportNumber');
  }
}