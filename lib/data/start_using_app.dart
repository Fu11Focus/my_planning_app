import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StartApp extends ChangeNotifier {
  late Map startUsingApp = {};
  final _myBox = Hive.box('StartUsingAppBox');

  void createInitialData() {
    startUsingApp = {
      'date': DateTime.now(),
    };
    updateDataBase();
    notifyListeners();
  }

  void loadData() {
    startUsingApp = _myBox.get('STARTAPP');
  }

  void updateDataBase() {
    _myBox.put('STARTAPP', startUsingApp);
  }
}
