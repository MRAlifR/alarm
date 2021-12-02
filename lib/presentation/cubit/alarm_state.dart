part of 'alarm_cubit.dart';

class AlarmState extends Equatable {
  const AlarmState(this.alarm);

  final Alarm alarm;

  @override
  List<Object> get props => [alarm];
}
