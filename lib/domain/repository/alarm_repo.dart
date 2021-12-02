import 'package:alarm/domain/model/alarm.dart';

abstract class AlarmRepo {
  Alarm? findActiveAlarm();
  Alarm? findOngoingAlarm();
  List<Alarm> findDoneAlarm();
  List<Alarm> findAllAlarm();
  Future<int> addAlarm(Alarm alarm);
  void deleteOngoingAlarm();
}
