import 'package:alarm/data/adapter/time_of_day_adapter.dart';
import 'package:alarm/data/repository/alarm_repo_impl.dart';
import 'package:alarm/domain/model/alarm.dart';
import 'package:alarm/domain/repository/alarm_repo.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  //Init
  await Hive.initFlutter();
  Hive.registerAdapter(AlarmAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());

  Box<Alarm> box = await Hive.openBox<Alarm>(Alarm.boxName);
  AlarmRepo repo = AlarmRepoImpl(box);

  await repo.addAlarm(Alarm(
    alarmTime: TimeOfDay.now(),
    isActive: true,
  ));
  // print(repo.findAllAlarm());
  // repo.deleteAlarm(repo.findActiveAlarm()!);
  // print(repo.findAllAlarm());
}
