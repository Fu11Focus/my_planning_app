
class NotificationService {
  bool notificationIsNotEmpty = false;

  void createNotification() {}
  void changeNotificationEmpty(Function setState) {
    setState(() {
      notificationIsNotEmpty = !notificationIsNotEmpty;
    });
  }
}
