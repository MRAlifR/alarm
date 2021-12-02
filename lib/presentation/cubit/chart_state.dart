part of 'chart_cubit.dart';

abstract class ChartState extends Equatable {
  const ChartState();

  @override
  List<Object> get props => [];
}

class ChartInitial extends ChartState {}

class ChartNoData extends ChartState {}

class ChartLoaded extends ChartState {
  final List<Alarm> doneAlarm;

  const ChartLoaded(this.doneAlarm);
}
