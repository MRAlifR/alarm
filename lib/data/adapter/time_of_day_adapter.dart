import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TimeOfDayAdapter extends TypeAdapter<TimeOfDay> {
  @override
  final typeId = 200;

  @override
  TimeOfDay read(BinaryReader reader) {
    Map map = reader.readMap();
    return TimeOfDay(
      hour: map['hour']!,
      minute: map['minute']!,
    );
  }

  @override
  void write(BinaryWriter writer, TimeOfDay obj) {
    writer.writeMap(<String, int>{
      'hour': obj.hour,
      'minute': obj.minute,
    });
  }
}
