import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'permanentNotification.dart';
import 'package:latify/alarmPage.dart';
import 'package:latify/alarmList.dart';

import 'package:latify/marshallingData.dart' as marshallingData;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Androidのデフォルトアイコンを使用
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  final PermanentNotification notification =
  PermanentNotification(flutterLocalNotificationsPlugin);

  await notification.showNotification();

  runApp(const MyApp());

  const notificationListener = MethodChannel('com.github.GeekCampVol7team38.latify/notificationListener');

  notificationListener.setMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'posted') {
      Map<String, dynamic> data = methodCall.arguments;
      marshallingData.Notification notification = marshallingData.Notification();
      notification.audioStreamType = data['notification.audioStreamType'];
      notification.category = data['notification.category'];
      notification.color = data['notification.color'];
      notification.defaults = data['notification.defaults'];
      notification.flags= data['notification.flags'];
      notification.icon = data['notification.icon'];
      notification.iconLevel = data['notification.iconLevel'];
      notification.ledARGB = data['notification.ledARGB'];
      notification.ledOffMS = data['notification.ledOffMS'];
      notification.ledOnMS = data['notification.ledOnMS'];
      notification.number = data['notification.number'];
      notification.priority = data['notification.priority'];
      notification.tickerText = marshallingData.CharSequence().value = data['notification.tickerText'];
      notification.vibrate = data['notification.vibrate'];
      notification.visibility = data['notification.visibility'];
      notification.when = data['notification.when'];
      notification.describeContents = data['notification.describeContents'];
      notification.getAllowSystemGeneratedContextualActions = data['notification.getAllowSystemGeneratedContextualActions'];
      notification.getBadgeIconType = data['notification.getBadgeIconType'];
      notification.getChannelId = data['notification.getChannelId'];
      notification.getGroup = data['notification.getGroup'];
      notification.getGroupAlertBehavior = data['notification.getGroupAlertBehavior'];
      notification.getSettingsText = marshallingData.CharSequence().value = data['notification.getSettingsText'];
      notification.getShortcutId = data['notification.getShortcutId'];
      notification.getSortKey = data['notification.getSortKey'];
      notification.getTimeoutAfter = data['notification.getTimeoutAfter'];
      notification.hasImage = data['notification.hasImage'];
      notification.notificationToString = data['notification.notificationToString'];

      marshallingData.UserHandle userHandle = marshallingData.UserHandle();
      userHandle.describeContents = data['userHandle.describeContents'];
      userHandle.userHandleHashCode = data['userHandle.hashCode'];
      userHandle.userHandleToString = data['userHandle.toString'];

      marshallingData.StatusBarNotification statusBarNotification = marshallingData.StatusBarNotification();
      statusBarNotification.describeContents = data['describeContents'];
      statusBarNotification.getGroupKey = data['getGroupKey'];
      statusBarNotification.getId = data['getId'];
      statusBarNotification.getKey = data['getKey'];
      statusBarNotification.getNotification = notification;
      statusBarNotification.getOpPkg = data['getOpPkg'];
      statusBarNotification.getOverrideGroupKey = data['getOverrideGroupKey'];
      statusBarNotification.getPackageName = data['getPackageName'];
      statusBarNotification.getPostTime = data['getPostTime'];
      statusBarNotification.getTag = data['getTag'];
      statusBarNotification.getUid = data['getUid'];
      statusBarNotification.getUserId = data['getUserId'];
      statusBarNotification.isAppGroup = data['isAppGroup'];
      statusBarNotification.isClearable = data['isClearable'];
      statusBarNotification.isGroup = data['isGroup'];
      statusBarNotification.isOngoing = data['isOngoing'];
      statusBarNotification.statusBarNotificationToString = data['toString'];
    }
  });
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latify',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Alarm List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final MethodChannel _notificationAccessChannel = const MethodChannel('com.github.GeekCampVol7team38.latify/notification_access');

  Future<void> _checkPermission() async {
    try {
      if (Platform.isAndroid) {
        final isEnabled = await _notificationAccessChannel.invokeMethod('isNotificationAccessEnabled');
        if (!isEnabled) {
          await _notificationAccessChannel.invokeMethod('requestNotificationAccess');
        }

        await FlutterLocalNotificationsPlugin().resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestPermission();
      }
    } on PlatformException catch (_) {
    }
  }

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  void _navigateToAlarmPage() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AlarmPage())
    );
  }

  AlarmList alarmList = AlarmList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: alarmList.alarmTextList.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4, // カードの影の高さを設定
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // カードの余白を設定
            child: ListTile(
              title: Text(alarmList.alarmTextList[index]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editItem(index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteItem(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _editItem(int index) {
    // 編集ボタンが押されたアイテムを処理
    // 例えば、ダイアログを表示して新しい値を入力させるなどの処理を行う
  }

  void _deleteItem(int index) {
    setState(() {
      // 削除ボタンが押されたアイテムをリストから削除
      alarmList.alarmTextList.removeAt(index);
    });
  }
}
