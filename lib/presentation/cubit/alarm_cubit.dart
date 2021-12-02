import 'package:alarm/domain/model/alarm.dart';
import 'package:alarm/domain/repository/alarm_repo.dart';
import 'package:alarm/util/notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'alarm_state.dart';

class AlarmCubit extends Cubit<AlarmState> {
  final AlarmRepo alarmRepo;

  AlarmCubit({required this.alarmRepo})
      : super(AlarmState(Alarm(alarmTime: TimeOfDay.now()))) {
    Alarm? alarm = alarmRepo.findOngoingAlarm();
    alarm != null
        ? emit(AlarmState(alarm))
        : alarmRepo.addAlarm(Alarm(alarmTime: TimeOfDay.now()));
  }

  void onClockChanged(TimeOfDay timeOfDay) {
    Alarm newAlarm = state.alarm.copyWith(alarmTime: timeOfDay);
    _saveAlarm(newAlarm);
    emit(AlarmState(newAlarm));
  }

  void onSetActive() {
    Alarm newAlarm = state.alarm.copyWith(isActive: true);
    _saveAlarm(newAlarm);
    createScheduledNotification(state.alarm.alarmTime);
    emit(AlarmState(newAlarm));
  }

  void onSetDone() {
    Alarm doneAlarm = state.alarm.copyWith(
      isActive: false,
      stopTime: DateTime.now(),
    );
    alarmRepo.addAlarm(doneAlarm);
  }

  void onSetInactive() {
    Alarm newAlarm = state.alarm.copyWith(isActive: false);
    _saveAlarm(newAlarm);
    cancelScheduledNotifications();
    emit(AlarmState(newAlarm));
  }

  void onToggleChanged() {
    state.alarm.isActive ? onSetInactive() : onSetActive();
  }

  void _saveAlarm(Alarm newAlarm) {
    alarmRepo.deleteOngoingAlarm();
    alarmRepo.addAlarm(newAlarm);
  }
}
