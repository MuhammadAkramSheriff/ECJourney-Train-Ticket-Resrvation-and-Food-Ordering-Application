import 'package:flutter/material.dart';

class StationListBottomSheet extends StatefulWidget {
  String bottomsheetTitle;
  String selectedItem;
  final Function(String) onSelect;

  StationListBottomSheet({required this.bottomsheetTitle, required this.selectedItem, required this.onSelect});

  @override
  _StationListBottomSheet createState() => _StationListBottomSheet();
}

class _StationListBottomSheet extends State<StationListBottomSheet> {

  final items = [
    'Anuradhapura',
    'Ampara',
    'Badulla',
    'Batticaloa',
    'Colombo',
    'Galle',
    'Gampaha',
    'Hambantota',
    'Jaffna',
    'Kalutara',
    'Kandy',
    'Kegalle',
    'Kilinochchi',
    'Mannar',
    'Matale',
    'Matara',
    'Moneragala',
    'Mullaitivu',
    'Nuwara Eliya',
    'Polonnaruwa',
    'Puttalam',
    'Ratnapura',
    'Trincomalee',
    'Vavuniya'];

  List<String> filteredItems = [];
  bool showFilteredResults = false;

  @override
  void initState() {
    super.initState();
    filteredItems = List.from(items);
  }

  void updateFilteredItems(String query) {
    setState(() {
      filteredItems = items.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
      showFilteredResults = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) { // Use StatefulBuilder here
                    return Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        widget.bottomsheetTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child:Text(
                          'Search Station',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          border: InputBorder.none,
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                        onChanged: (value) {
                          updateFilteredItems(value); // Update the filtered list when the user types in the search field
                        },
                      ),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                      child:Text(
                        'Select Station',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: showFilteredResults ? filteredItems.length : items.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = showFilteredResults ? filteredItems[index] : items[index];
                          return ListTile(
                            title: Text(item),
                            onTap: () {
                              setState(() {
                                widget.onSelect(item);
                                showFilteredResults = false;
                                Navigator.pop(context);
                              });
                            },
                          );
                        },
                      ),
                      ),
                    ],
                  ),
                    );
                  },
                );
              },
            );
          },
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: EdgeInsets.all(12.0),
            child: Text(
              widget.selectedItem,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              ),
            ),
          ),
        );
  }
}