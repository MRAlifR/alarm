import 'package:alarm/domain/model/alarm.dart';
import 'package:alarm/domain/repository/alarm_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chart_state.dart';

class ChartCubit extends Cubit<ChartState> {
  final AlarmRepo alarmRepo;

  ChartCubit({required this.alarmRepo}) : super(ChartInitial()) {
    List<Alarm> doneAlarm = alarmRepo.findDoneAlarm();
    doneAlarm.isEmpty ? emit(ChartNoData()) : emit(ChartLoaded(doneAlarm));
  }
}
