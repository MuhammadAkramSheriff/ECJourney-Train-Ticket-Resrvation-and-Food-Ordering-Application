import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecjourney/Models/UserReservationTracking.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Common/Helper.dart';
import 'Models/UserModel/UserDetailsModel.dart';
import 'Models/UserModel/UserDetailsProvider.dart';

class FirebaseAuthService {

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {

    try {
      //provide the email and password for firebase authentication
      UserCredential credential =await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;

      //catch and display any firebase authentication error
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast('Email Already Regsitered');
      } else if (e.code == 'weak-password') {
        showToast('Password Should Contain At least 6 Characters');
      }
    }catch (e) {
      print('Registration Fail');
    }
    return null;

  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {

    try {
      UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      showToast("Login Failed");
    }
    return null;

  }

  Future<void> signOut(context) async {
    try {
      await _auth.signOut();
      UserDataStorage userDataStorage = UserDataStorage();
      await userDataStorage.clearUserDataLocally();
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('Reservation ID');
    } catch (e) {
      showToast("Logout Failed");
    }
  }

  Future<UserDetailsModel?> getUserDetails(String email) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(email).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return UserDetailsModel.fromMap(userData);
      } else {
        print("User details not found f");
        return null;
      }
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }

  Future<void> getUserReservationStatus(String email) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('UserReservations').doc(email).get();
      if (userDoc.exists) {

        // Use 'data()' method and cast to a Map<String, dynamic>
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        if (userData.containsKey('Reservation ID')) {
          String reservationID = userData['Reservation ID'] as String;
          print(reservationID);

          final prefs = await SharedPreferences.getInstance();
          prefs.setString('Reservation ID', reservationID);
          }
        else {
          print("Reservation ID not found in user details");
        }
      } else {
        print("User details not found");
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }
}