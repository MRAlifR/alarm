import 'package:alarm/domain/model/alarm.dart';
import 'package:alarm/domain/repository/alarm_repo.dart';
import 'package:hive/hive.dart';

class AlarmRepoImpl extends AlarmRepo {
  final Box<Alarm> box;

  AlarmRepoImpl(this.box);

  @override
  Future<int> addAlarm(Alarm alarm) async => await box.add(alarm);

  @override
  void deleteOngoingAlarm() {
    Iterable<Alarm> ongoingAlarm = box.values.where(
      (alarm) => alarm.stopTime == null,
    );
    for (var alarm in ongoingAlarm) {
      alarm.delete();
    }
  }

  @override
  Alarm? findActiveAlarm() {
    Iterable<Alarm> alarms = box.values.where((alarm) => alarm.isActive);
    return alarms.isNotEmpty ? alarms.first : null;
  }

  @override
  List<Alarm> findAllAlarm() => box.values.toList();

  @override
  List<Alarm> findDoneAlarm() {
    Iterable<Alarm> activeAlarm = box.values.where(
      (alarm) => alarm.stopTime != null,
    );
    return activeAlarm.toList();
  }

  @override
  Alarm? findOngoingAlarm() {
    Iterable<Alarm> ongoingAlarm = box.values.where(
      (alarm) => alarm.stopTime == null,
    );
    return ongoingAlarm.isNotEmpty ? ongoingAlarm.first : null;
  }
}
