import 'package:ToDoDude/util/notifications_controller.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:ToDoDude/data/start_using_app.dart';
import 'package:ToDoDude/pages/calendar_page.dart';
import 'package:ToDoDude/pages/creates_note_page.dart';
import 'package:ToDoDude/pages/habbits_tracker_page.dart';
import 'package:ToDoDude/pages/habit_dashboard.dart';
import 'package:ToDoDude/pages/inbox_page.dart';
import 'package:ToDoDude/pages/notes_page.dart';

import 'package:ToDoDude/pages/dashboard_page.dart';
import 'package:ToDoDude/util/main_theme.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/wish_board_page.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  RequestConfiguration requestConfiguration = RequestConfiguration(testDeviceIds: ['9ab9c18b-81f9-4a5f-9d13-f09806c27c33']);
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);
  await AwesomeNotifications().initialize(
      'resource://drawable/ic_notification',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          defaultPrivacy: NotificationPrivacy.Public,
          locked: true, /*soundSource: 'resource://raw/tododude_notification'*/
        ),
      ],
      debug: true);
  await NotificationController.initializeIsolateReceivePort();
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  await Hive.initFlutter();
  await Hive.openBox('StartUsingAppBox');
  await Hive.openBox('MyBox');
  await Hive.openBox('WishBox');
  await Hive.openBox('ToDoListBox');
  await Hive.openBox('HabitsBox');
  await Hive.openBox('InboxListBox');
  String? initialRoute = '/wishboard';

  // Проверяем, была ли передана полезная нагрузка от уведомления
  AwesomeNotifications().getInitialNotificationAction().then((action) {
    if (action?.payload?['route'] != null) {
      initialRoute = action!.payload!['route']; // Устанавливаем начальный маршрут
    }
    runApp(MyApp(initialRoute: initialRoute));
  });
}

Future<void> onActionNotification(event) async {
  if (event.payload?['route'] != null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MyApp.navigatorKey.currentState?.pushNamed(event.payload!['route']!);
    });
  }
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final String? initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    AwesomeNotifications().setListeners(onActionReceivedMethod: onActionNotification, onNotificationDisplayedMethod: onActionNotification);
    final myBox = Hive.box('StartUsingAppBox');
    StartApp startApp = StartApp();
    if (myBox.get('STARTAPP') == null) {
      startApp.createInitialData();
    } else {
      startApp.loadData();
    }
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 600) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      }
      return MaterialApp(
        navigatorKey: navigatorKey,
        theme: mainTheme(),
        debugShowCheckedModeBanner: false,
        home: initialRoute == '/wishboard' ? WishBoardPage() : Calendar(),
        routes: {
          '/wishboard': (context) => const WishBoardPage(),
          '/habbitsTracker': (context) => const HabitsTracker(),
          '/calendar': (context) => const Calendar(),
          '/inbox': (context) => const Inbox(),
          '/notes': (context) => const Notes(),
          '/statistics': (context) => DashboardPage(),
          '/createNote': (context) => const CreateNotePage(),
          '/habitDashboard': (context) => const HabitDashboard(),
        },
      );
    });
  }
}
