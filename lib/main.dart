import 'package:alarm/data/adapter/time_of_day_adapter.dart';
import 'package:alarm/data/repository/alarm_repo_impl.dart';
import 'package:alarm/domain/model/alarm.dart';
import 'package:alarm/presentation/bloc/clock_bloc.dart';
import 'package:alarm/presentation/cubit/alarm_cubit.dart';
import 'package:alarm/presentation/view/alarm_view.dart';
import 'package:alarm/util/ticker.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  AwesomeNotifications().initialize(
    'resource://drawable/res_notification_app_icon',
    [
      NotificationChannel(
        channelKey: 'scheduled_alarm_channel',
        channelName: 'Alarm Notifications',
        importance: NotificationImportance.Max,
        playSound: true,
        channelShowBadge: true,
        enableLights: true,
        enableVibration: true,
        channelDescription: 'Notifications Alarm',
        criticalAlerts: true,
        soundSource: 'resource://raw/res_sound_notification_new',
        defaultRingtoneType: DefaultRingtoneType.Alarm,
      ),
    ],
  );

  await Hive.initFlutter();
  Hive.registerAdapter(AlarmAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());
  await Hive.openBox<Alarm>(Alarm.boxName);

  runApp(const AlarmApp());
}

class AlarmApp extends StatelessWidget {
  const AlarmApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarm App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ClockBloc(
              xTicker: Ticker(),
              yTicker: Ticker(),
            ),
          ),
          BlocProvider(
            create: (_) {
              return AlarmCubit(
                alarmRepo: AlarmRepoImpl(
                  Hive.box<Alarm>(Alarm.boxName),
                ),
              );
            },
          ),
        ],
        child: const AlarmView(),
      ),
    );
  }
}
