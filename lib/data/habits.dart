import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class HabitsDB extends ChangeNotifier {
  List habbitsList = [];
  final _myBox = Hive.box('HabitsBox');
//create database if this first time runing app
  void createInitialData() {
    habbitsList = [];
  }

//load the data from database
  void loadData() {
    habbitsList = _myBox.get('HABITS');
  }

//update the database
  void updateDataBase() {
    _myBox.put('HABITS', habbitsList);
  }

  void addHabit(String title, List<String> daysOfWeek, start, end, notificationTime, notificationId) async {
    Map<String, bool> progress = {};
    String? channelKey = null;
    DateFormat dateFormat = DateFormat('dd MMM yyyy');
    int? notificationId = null;
    for (DateTime date = DateTime(start.year, start.month, start.day, notificationTime != null ? notificationTime.hour : 0, notificationTime != null ? notificationTime.minute : 0); date.isBefore(end) || dateFormat.format(date) == dateFormat.format(end); date = date.add(const Duration(days: 1))) {
      if (daysOfWeek.contains(DateFormat('EEE').format(date))) {
        progress[dateFormat.format(date)] = false;
        if (notificationTime != null) {
          notificationId = int.parse(DateTime.now().microsecond.toString());
          AwesomeNotifications().createNotification(content: NotificationContent(locked: true, notificationLayout: NotificationLayout.BigText, wakeUpScreen: true, id: notificationId, channelKey: 'basic_channel', groupKey: title, title: "ToDoDude", body: title, payload: {'route': '/calendar'}), schedule: NotificationCalendar(year: date.year, month: date.month, day: date.day, hour: notificationTime.hour, minute: notificationTime.minute, allowWhileIdle: true, preciseAlarm: true));
        }
      }
    }

    habbitsList.add({
      'id': const Uuid().v4(),
      'title': title,
      'daysOfWeek': daysOfWeek,
      'progress': progress,
      'start': start,
      'finish': end,
      'notificationId': notificationId,
      'notificationTime': notificationTime,
    });
    updateDataBase();
    notifyListeners();
  }

  void toDayIsDone(id, value, selectedDate) {
    int index = habbitsList.indexWhere((element) => element['id'] == id);
    habbitsList[index]['progress'][DateFormat('dd MMM yyyy').format(selectedDate)] = value;

    updateDataBase();
    notifyListeners();
  }

  void removeHabit(index) async {
    AwesomeNotifications().cancelNotificationsByGroupKey(habbitsList[index]['title']);
    habbitsList.removeAt(index);
    updateDataBase();
    notifyListeners();
  }
}
