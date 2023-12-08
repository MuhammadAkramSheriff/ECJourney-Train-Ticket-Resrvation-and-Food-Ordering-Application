import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../SearchTrain.dart';

class DateFields extends StatefulWidget {
  final bool isSingleSelected;
  final Function(String) DepartureDate;
  final Function(String) ReturnDate;

  DateFields({required this.isSingleSelected, required this.DepartureDate, required this.ReturnDate});

  @override
  _DateFields createState() => _DateFields();
}

class _DateFields extends State<DateFields> {
  late DateTime _selectedDepartureDate;
  late DateTime _selectedReturnDate;
  String formattedDepartureDate = DateFormat('dd MMM').format(DateTime.now());
  String formattedReturnDate = DateFormat('dd MMM').format(DateTime.now());
  late String departuredate;
  late String returndate;

  @override
  void initState() {
    super.initState();
    _selectedDepartureDate = DateTime.now();
    _selectedReturnDate = DateTime.now();
  }


  // Function to select a date and display it for departure
  void _selectDepartureDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDepartureDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDepartureDate) {
      if (_selectedReturnDate.isBefore(picked)) {
        // If return date is before the new departure date, update return date
        setState(() {
          _selectedDepartureDate = picked;
          formattedDepartureDate = DateFormat('dd MMM').format(picked);
          _selectedReturnDate = picked;
          formattedReturnDate = DateFormat('dd MMM').format(picked);
          departuredate = DateFormat('dd-MM-yyyy').format(picked);
          widget.DepartureDate(departuredate);
          returndate = DateFormat('dd-MM-yyyy').format(picked);
          widget.ReturnDate(returndate);
        });
      } else {
        setState(() {
          _selectedDepartureDate = picked;
          formattedDepartureDate = DateFormat('dd MMM').format(picked);
          departuredate = DateFormat('dd-MM-yyyy').format(picked);
          widget.DepartureDate(departuredate);
          // returndate = DateFormat('dd-MM-yyyy').format(picked);
          // widget.ReturnDate(returndate);
        });
      }
    }
  }

  // Function to select a date and display it for return
  void _selectReturnDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedReturnDate,
      firstDate: _selectedDepartureDate,
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedReturnDate) {
      setState(() {
        _selectedReturnDate = picked;
        formattedReturnDate = DateFormat('dd MMM').format(picked);
        returndate = DateFormat('dd-MM-yyyy').format(picked);
        widget.ReturnDate(returndate);
        print(returndate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSingleSelected) {
      formattedReturnDate = DateFormat('dd MMM').format(_selectedDepartureDate);
    }

    return Column(
      children: [
        if (widget.isSingleSelected)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Departure Date",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 134,
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(text: formattedDepartureDate),
                    onTap: () {
                      _selectDepartureDate(context);
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () {
                          _selectDepartureDate(context);
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        if (!widget.isSingleSelected)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Departure Date",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child:Text(
                      "Return Date",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            controller: TextEditingController(
                              text: formattedDepartureDate,
                            ),
                            onTap: () {
                              // Show the calendar when the user taps the field
                              _selectDepartureDate(context);
                            },
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(Icons.calendar_today),
                                onPressed: () {
                                  // Show the calendar when the user taps the calendar icon
                                  _selectDepartureDate(context);
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: Colors.black12),
                              ),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true, // Make the field read-only
                            controller: TextEditingController(
                              text: formattedReturnDate,
                            ),
                            onTap: () {
                              // Show the calendar when the user taps the field
                              _selectReturnDate(context);
                            },
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(Icons.calendar_today),
                                onPressed: () {
                                  // Show the calendar when the user taps the calendar icon
                                  _selectReturnDate(context);
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: Colors.black12),
                              ),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
