import 'package:flutter/cupertino.dart';

class FoodItemsDetailsProvider extends ChangeNotifier {
  late String _foodorderid;
  late String _foodorderstatus;
  List<String> _selectedFoodItems = [];
  late String _trainno;
  //List<String> _itemNoNamePrice = [];
  late int _totalamount;
  Map<String, int> _itemCounts = {};
  List<Map<String, dynamic>> _items = [];

  String get foodorderid => _foodorderid;
  String get foodorderstatus => _foodorderstatus;
  List<String> get selectedFoodItems => _selectedFoodItems;
  String get trainno => _trainno;
  //List<String> get itemNodNamePrice => _itemNoNamePrice;
  int get totalamount => _totalamount;
  Map<String, int> get itemCounts => _itemCounts;
  List<Map<String, dynamic>> get items => _items;


  void addItems(List<Map<String, dynamic>> items) {
    for (var newItem in items) {
      // Check if an item with the same key is already present
      var containsItem = _items.any((existingItem) => existingItem['Item no'] == newItem['Item no']);

      if (containsItem) {
        // If it exists, remove the existing item
        _items.removeWhere((existingItem) => existingItem['Item no'] == newItem['Item no']);
      }

      // Add the new item
      _items.add(newItem);
    }
    notifyListeners();
  }

  void removeItem(String itemName) {
    _items.removeWhere((item) => item['Item Name'] == itemName);
    notifyListeners();
  }


  void addItemCountWithName(String itemName, int itemcount) {
    if (_itemCounts.containsKey(itemName)) {
      itemCounts[itemName] = itemcount;
      _itemCounts.remove(itemName);
    }
    _itemCounts[itemName] = itemcount;
    notifyListeners();
  }

  void addFoodOrderID(String foodorderid) {
    _foodorderid = foodorderid;
    notifyListeners();
  }

  void addFoodOrderStatus(String foodorderstatus) {
    _foodorderstatus = foodorderstatus;
    notifyListeners();
  }


  void addTrainno(String trainNo) {
    _trainno = trainNo;
    notifyListeners();
  }


  // void addItemNameandNo(List<String> itemnameandno) {
  //   _itemNoNamePrice.addAll(itemnameandno);
  //   notifyListeners();
  // }

  void addTotalAmount(int totalamount) {
    _totalamount = totalamount;
    notifyListeners();
  }

  void incrementItemCount(String itemName) {
    _itemCounts[itemName] = (_itemCounts[itemName] ?? 0) + 1;
    notifyListeners();
  }

  void decrementItemCount(String itemName) {
    _itemCounts[itemName] = _itemCounts[itemName]! - 1;
    notifyListeners();
  }

  void removeItemCount(String itemName) {
    if (_itemCounts.containsKey(itemName)) {
      _itemCounts.remove(itemName);
      notifyListeners();
    }
  }

  void addSelectedFoodItems(String item) {
    if (!_selectedFoodItems.contains(item)) {
      _selectedFoodItems.add(item);
      notifyListeners();
    }
  }

  void removeSelectedFoodItems(String item) {
    _selectedFoodItems.remove(item);
    notifyListeners();
  }

  void clearSelectedFoodItems(){
    _selectedFoodItems.clear();
    notifyListeners();
  }
}