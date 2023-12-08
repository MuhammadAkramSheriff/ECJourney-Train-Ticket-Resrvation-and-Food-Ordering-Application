import 'package:flutter/material.dart';

enum ArrowDirection { single, returning }

class TicketTypeContainer extends StatefulWidget {
  final ArrowDirection arrowDirection;
  final String text;
  final bool isSelected;
  final Function(bool) onSelectionChanged;

  TicketTypeContainer({
    required this.arrowDirection,
    required this.text,
    required this.isSelected,
    required this.onSelectionChanged,
  });

  @override
  _TicketTypeContainer createState() => _TicketTypeContainer();
}

class _TicketTypeContainer extends State<TicketTypeContainer> {
  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.isSelected ? Colors.cyan[500] : Colors.grey[400];

    return ElevatedButton(
      onPressed: () {
        widget.onSelectionChanged(!widget.isSelected);
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        backgroundColor: buttonColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Column(
        children: [
          Icon(
            widget.arrowDirection == ArrowDirection.single
                ? Icons.arrow_forward
                : Icons.compare_arrows,
            size: 30,
            color: Colors.white,
          ),
          //SizedBox(height: 2),
          Text(
            widget.text,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
