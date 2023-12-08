import 'package:ecjourney/FoodOrderingScreen/FoodItemsModel.dart';
import 'package:ecjourney/Models/UserReservationTracking.dart';
import 'package:ecjourney/Payment/RecieptScreen/recieptScreenForFoodOrder.dart';
import 'package:ecjourney/ReservationDetailsConfirmationScreen/ReservationDetailsConfirmationScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AdminPanel/AdminPanel.dart';
import 'AdminPanel/Train Info/AddSchedule.dart';
import 'AdminPanel/Train Info/TrainSchedule.dart';
import 'AdminPanel/test.dart';
import 'FoodOrderingScreen/FoodMenuScreen.dart';
import 'LoginScreen/LoginPage.dart';
import 'Models/Journey Model/JourneyDetailsProvider.dart';
import 'PassengerDetailsConfirmationScreen/PassengerDetailsConfirmationScreen.dart';
import 'PassengerDetailsConfirmationScreen/PassengerDetailsProvider.dart';
import 'Payment/PayPalCheckout.dart';
import 'Payment/PaymentModel.dart';
import 'Payment/RecieptScreen/recieptScreenForReservation.dart';
import 'SearchTrainScreen/SearchTrain.dart';
import 'SearchTrainScreen/SearchTrainScreenResources/executeOverLay.dart';
import 'SeatSelectionScreen/SelectSeat.dart';
import 'SessionTracking.dart';
import 'callSaveInDatabase.dart';
import 'firebase_auth_services.dart';


Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyCyXCd7TiiqfW5LGJu1HQqVgAerfw3KHns",
        appId: "1:193113038607:web:8c25ab71936c27f302687a",
        messagingSenderId: "193113038607",
        projectId: "ecjourney-f154f",
        databaseURL: "https://ecjourney-f154f-default-rtdb.firebaseio.com"),
    );
  }else {
    await Firebase.initializeApp();

    SessionTracking sessiontracking = SessionTracking();
    final FirebaseAuthService _auth = FirebaseAuthService();

    final prefs = await SharedPreferences.getInstance();
    final reservationID = prefs.getString('Reservation ID');
    final resforrec = prefs.getString('Reservation ID For Reciept');
    print(resforrec);
    final email = prefs.getString('EmailAddress');

    if (email != null){
      _auth.getUserReservationStatus(email);
    }else{
      print('email null');
    }

    // if (reservationID != null){
    //   print('running session trckng at main');
    //   sessiontracking.deleteReservation(reservationid: reservationID);
    // }else{
    //   print('reservation id null');
    // }

  }
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => JourneyDetailsProvider()),
          ChangeNotifierProvider(create: (context) => ReturnJourneyDetailsProvider()),
          ChangeNotifierProvider(create: (context) => FoodItemsDetailsProvider()),
          ChangeNotifierProvider(create: (context) => PassengerDetailsProvider()),
          ChangeNotifierProvider(create: (context) => PaymentDetailsProvider()),
        ],
        child: MyApp(),
  ));

  // html.window.onPopState.listen((event) {
  //   globalKey.currentState?.pop(); // Navigate back using Navigator
  // });
}

//GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigatorService.navigatorKey,
      debugShowCheckedModeBanner: false,

      routes: {
        '/recieptScreenForReservation': (context) => _navigateAndSaveForReservation(context),
        '/recieptScreenForFoodOrder': (context) => _navigateAndSaveForFoodOrder(context),
      },

      title: 'ECJourney',
      home: SplashScreen(),
    );
  }
}
Widget _navigateAndSaveForReservation(BuildContext context) {
  return FutureBuilder(
    future: saveInDatabaseForReservation(context),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return RecieptScreenForReservation(newReciept: true);
      } else {
        // You can return a loading indicator or an empty container while saving
        return Container();
      }
    },
  );
}

Widget _navigateAndSaveForFoodOrder(BuildContext context) {
  return FutureBuilder(
    future: saveInDatabaseForFoodOrder(context),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return RecieptScreenForFoodOrder();
      } else {
        // You can return a loading indicator or an empty container while saving
        return Container();
      }
    },
  );
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Delayed navigation to allow for a splash screen or other initialization tasks
    Future.delayed(Duration(seconds: 2), () {
      navigateToRelevantScreen(context);
    });

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  //Method to navogate to relavant screen by identifiying the device
  //that the application is running
  void navigateToRelevantScreen(BuildContext context) {
    //if the application is running on web, it provide access to admin panel
    if (kIsWeb) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminPanel()),
      );
    }
    //if the application is running on mobile device, it give access to mobile application
    else {

      final User? user = FirebaseAuth.instance.currentUser;

      //Further, if the user is already sign-in it will directly give the
      //user access into the application to reserve ticket
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SearchTrain()),
        );
      }
      //If the user is not sign-in, it will ask the user to sign-in
      //by navigating to login screen
      else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    }
  }


}