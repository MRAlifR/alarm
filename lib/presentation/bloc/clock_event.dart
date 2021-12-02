part of 'clock_bloc.dart';

abstract class ClockEvent extends Equatable {
  const ClockEvent();

  @override
  List<Object> get props => [];
}

class ClockVerticalDrag extends ClockEvent {
  const ClockVerticalDrag({
    required this.offsetStart,
    required this.offsetNow,
    required this.alarmTime,
  });
  final Offset offsetStart;
  final Offset offsetNow;
  final TimeOfDay alarmTime;
}

class ClockHorizontalDrag extends ClockEvent {
  const ClockHorizontalDrag({
    required this.offsetStart,
    required this.offsetNow,
    required this.alarmTime,
  });
  final Offset offsetStart;
  final Offset offsetNow;
  final TimeOfDay alarmTime;
}

class ClockTicked extends ClockEvent {
  const ClockTicked({
    required this.time,
  });
  final TimeOfDay time;
}

class ClockDragStop extends ClockEvent {}
