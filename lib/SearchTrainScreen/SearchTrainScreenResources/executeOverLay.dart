import 'dart:ui';
import 'package:flutter/material.dart';
import 'Drawer.dart';


OverlayEntry? overlay;

//Method to showOverlay
void showOverlay(BuildContext context) {
  overlay = OverlayEntry(
    builder: (context) => Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: IgnorePointer(
        //Disable user interaction with the screen under overlay
        ignoring: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          drawerEnableOpenDragGesture: false,
          //An Appbar will still be there in the overlay
          appBar: AppBar(
            title: const Text(
              "Search Train",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.blue,
          ),
          drawer: CustomDrawer(onDrawerItemTap: removeOverlay),
          body: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              Column(
                children: [
                  Container(
                    height: 50,
                    color: Colors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                        ),
                        Text(
                          'You Alread Have a Reservation!',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  // Other content of your dialog
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
  Overlay.of(context)?.insert(overlay!);
}

// void removeOverlay(BuildContext context) {
//   Navigator.of(context).pop(); // This will remove the overlay
// }

void removeOverlay() {
  if (overlay != null) {
    print('inside remove overlay funtion');
      overlay!.remove();
      overlay = null;
  }
}
  // void removeOverlay(BuildContext overlayContext) {
  //   if (overlay != null) {
  //     overlay!.remove();
  //     overlay = null;
  //   }
  // }
