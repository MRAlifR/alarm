import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'alarm.g.dart';

@HiveType(typeId: 0)
class Alarm extends HiveObject {
  static const boxName = "alarm_box";

  @HiveField(0)
  TimeOfDay alarmTime;
  @HiveField(1)
  DateTime? stopTime;
  @HiveField(2)
  bool isActive;

  Alarm({
    required this.alarmTime,
    this.stopTime,
    this.isActive = false,
  });

  int? get deltaTime {
    DateTime? doneTime = stopTime;
    if (doneTime == null) return null;
    int doneSec = (doneTime.hour * 60 + doneTime.minute) * 60 + doneTime.second;
    int startSec = (alarmTime.hour * 60 + alarmTime.minute) * 60;
    return doneSec - startSec;
  }

  Alarm copyWith({
    TimeOfDay? alarmTime,
    DateTime? stopTime,
    bool? isActive,
  }) {
    return Alarm(
      alarmTime: alarmTime ?? this.alarmTime,
      stopTime: stopTime ?? this.stopTime,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() =>
      'Alarm(alarmTime: $alarmTime, stopTime: $stopTime, isActive: $isActive)';
}
