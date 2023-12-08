
// class UserModel {
//   late String fname;
//   late String lname;
//   late String email;
//   late String mobileNum;
//   late String? nicno;
//   late String? passportno;
//   late String cpassword;
//
//   UserModel(this.fname,this.lname, this.email, this.mobileNum,this.nicno,this.passportno, this.cpassword);
//
//   Map<String, dynamic> toMap() {
//     var map = <String, dynamic>{
//       'First_Name': user_fname,
//       'Last_Name': user_lname,
//       'Email': user_email,
//       'Mobile_Num': user_mobileNum,
//       'Nic_Num': user_NICno,
//       'Passport_Num': user_Passportno,
//       'Confirmed_Password': password
//     };
//     return map;
//   }
//
//   UserModel.fromMap(Map<String, dynamic> map) {
//     user_fname = map['First_Name'];
//     user_lname = map['Last_Name'];
//     user_email = map['Email'];
//     user_mobileNum = map['Mobile_Num'];
//     user_NICno = map['Nic_Num'];
//     user_Passportno = map['Passport_Num'];
//     password = map['Confirmed_Password'];
//   }
// }