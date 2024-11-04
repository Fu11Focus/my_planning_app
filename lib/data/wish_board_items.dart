import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WishItems extends ChangeNotifier {
  List wishItems = [];
  final wishBox = Hive.box('WishBox');

  void createInitialOrLoadData() {
    if (wishBox.get('WISHITEMS') == null) {
      _createInitialData();
    } else {
      _loadData();
    }
  }

  void _createInitialData() {
    wishItems = [
      // {'img': null, 'txt': 'Hello!'},
    ];
  }

  void _loadData() {
    wishItems = wishBox.get('WISHITEMS');
  }

  void updateDataBase() {
    wishBox.put('WISHITEMS', wishItems);
  }

  void addWishItems(Map wish) {
    wishItems.add(wish);
    updateDataBase();
    notifyListeners();
  }

  void deleteItem(index) {
    wishItems.removeAt(index);
    updateDataBase();
    notifyListeners();
  }
}
