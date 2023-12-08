import 'package:flutter/material.dart';

class SingleReturnTogglebar extends StatefulWidget {
  //const SelectTrain({Key? key}) : super(key: key);

  final bool isSingleSelected;
  final Function(bool) isToggleSingleSelected;
  final Function(bool) isToggleReturnSelected;


  SingleReturnTogglebar({required this.isSingleSelected, required this.isToggleSingleSelected, required this.isToggleReturnSelected});

  @override
  State<SingleReturnTogglebar> createState() => _SingleReturnTogglebar();
}

class _SingleReturnTogglebar extends State<SingleReturnTogglebar> {

  bool isReturnSelected = false;
  bool isSingleSelected = true;

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            if (widget.isSingleSelected)
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isSingleSelected = true;
                            isReturnSelected = false;
                            widget.isToggleSingleSelected(isSingleSelected);
                          });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: isSingleSelected ? Colors.cyan[700] : Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(
                                5.0)),
                          ),
                        ),
                        child: Text("Single",
                            style: TextStyle(color: isSingleSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500)
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            if (!widget.isSingleSelected)
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isSingleSelected = true;
                            isReturnSelected = false;
                            widget.isToggleSingleSelected(isSingleSelected);
                          });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: isSingleSelected ? Colors.cyan[700] : Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              bottomLeft: Radius.circular(5.0),
                            ),
                          ),
                        ),
                        child: Text("Single",
                            style: TextStyle(color: isSingleSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500)
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isSingleSelected = false;
                            isReturnSelected = true;
                            widget.isToggleReturnSelected(isReturnSelected);
                          });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: isReturnSelected ? Colors.cyan[700] : Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0),
                            ),
                          ),
                        ),
                        child: Text("Return",
                            style: TextStyle(color: isReturnSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ]
    );
  }
}