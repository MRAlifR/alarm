part of 'clock_bloc.dart';

abstract class ClockState extends Equatable {
  const ClockState(this.time);
  final TimeOfDay time;

  @override
  List<Object> get props => [time];
}

class ClockInitial extends ClockState {
  const ClockInitial(TimeOfDay time) : super(time);
}

class ClockChanged extends ClockState {
  const ClockChanged(TimeOfDay time) : super(time);
}
