import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WishItems extends ChangeNotifier {
  List wishItems = [];
  final wishBox = Hive.box('WishBox');

  void createInitialData() {
    wishItems = [
      // {'img': null, 'txt': 'Hello!'},
    ];
  }

  void loadData() {
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
