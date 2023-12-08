//Database to store from firebase
// class UserDetails {
//   final String firstName;
//   final String lastName;
//   final String Email;
//   final String mobileNum;
//   final String? NICNo;
//   final String? passportNo;
//
//
//   UserDetails({required this.firstName, required this.lastName, required this.Email, required this.mobileNum, required this.NICNo, required this.passportNo});
//
//   Map<String, dynamic> toMap() {
//     return {
//       'First Name': firstName,
//       'Last Name': lastName,
//       'Email Address': Email,
//       'Mobile Number': mobileNum,
//       'NIC NO' : NICNo,
//       'Passport Number': passportNo,
//     };
//   }
//
//   factory UserDetails.fromMap(Map<String, dynamic> data) {
//     return UserDetails(
//       firstName: data['First Name'] ?? '',
//       lastName: data['Last Name'] ?? '',
//       Email: data['Email Address'] ?? '',
//       mobileNum: data['Mobile Number'] ?? '',
//       NICNo: data['NIC NO'] ?? '',
//       passportNo: data['Passport Number'] ?? '',
//     );
//   }
// }

//database to store in sqflite
class UserDetailsModel {
  late String firstName;
  late String lastName;
  late String Email;
  late String mobileNum;
  late String? NICNo;
  late String? passportNo;

  UserDetailsModel({required this.firstName,required this.lastName, required this.Email,
    required this.mobileNum,required this.NICNo,required this.passportNo});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'FirstName': firstName,
      'LastName': lastName,
      'Email': Email,
      'MobileNumber': mobileNum,
      'NICNumber': NICNo,
      'PassportNumber': passportNo,
    };
    return map;
  }

  factory UserDetailsModel.fromMap(Map<String, dynamic> data) {
    return UserDetailsModel(
      firstName: data['First Name'] ?? '',
      lastName: data['Last Name'] ?? '',
      Email: data['Email Address'] ?? '',
      mobileNum: data['Mobile Number'] ?? '',
      NICNo: data['NIC NO'] ?? '',
      passportNo: data['Passport Number'] ?? '',
    );
  }
}