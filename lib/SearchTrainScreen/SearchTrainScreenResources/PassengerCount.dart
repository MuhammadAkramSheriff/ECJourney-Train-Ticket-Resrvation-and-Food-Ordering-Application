import 'package:flutter/material.dart';

class PassengerCount extends StatefulWidget {

  final Function(int) passengerCount;

  PassengerCount({required this.passengerCount});

  @override
  _PassengerCountState createState() => _PassengerCountState();
}

class _PassengerCountState extends State<PassengerCount> {
  int selectedCount = 1; // Default selected count is 1

  void selectPassengerCount(int count) {
    setState(() {
      selectedCount = count;
      widget.passengerCount(selectedCount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          for (int i = 1; i <= 10; i++)
            GestureDetector(
              onTap: () => selectPassengerCount(i),
              child: Container(
                width: 18,
                height: 40,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedCount == i ? Colors.cyan : Colors.grey[400],
                ),
                child: Center(
                  child: Text(
                    i.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}