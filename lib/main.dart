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
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/wish_board_page.dart';
import 'package:flutter/services.dart';

void main() async {
  await AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/ic_notification',
      [
        NotificationChannel(channelGroupKey: 'basic_channel_group', channelKey: 'basic_channel', channelName: 'Basic notifications', channelDescription: 'Notification channel for basic tests', defaultColor: const Color(0xFF9D50DD), ledColor: Colors.white, importance: NotificationImportance.High, locked: true, soundSource: 'resource://raw/tododude_notification'),
      ],
      // Channel groups are only visual and are not required
      channelGroups: [NotificationChannelGroup(channelGroupKey: 'basic_channel_group', channelGroupName: 'Basic group')],
      debug: true);
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  WidgetsFlutterBinding.ensureInitialized();
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

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final String? initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (event) async {
        if (event.payload!['route'] == '/calendar') {
          navigatorKey.currentState?.pushNamed('/calendar');
        }
      },
      onNotificationDisplayedMethod: (event) async {
        if (event.payload!['route'] == '/calendar') {
          Navigator.pushNamed(context, '/calendar');
        }
      },
    );
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
