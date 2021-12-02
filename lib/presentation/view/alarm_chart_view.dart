import 'package:alarm/data/repository/alarm_repo_impl.dart';
import 'package:alarm/domain/model/alarm.dart';
import 'package:alarm/presentation/cubit/chart_cubit.dart';
import 'package:alarm/util/extension/time_of_day.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AlarmChartView extends StatelessWidget {
  const AlarmChartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChartCubit(
        alarmRepo: AlarmRepoImpl(
          Hive.box<Alarm>(Alarm.boxName),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Alarm Chart'),
          backgroundColor: Colors.white70,
        ),
        extendBodyBehindAppBar: true,
        body: BlocBuilder<ChartCubit, ChartState>(
          builder: (context, state) {
            if (state is ChartLoaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Center(
                  child: Container(
                    height: 300,
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 48,
                      bottom: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFECF6FF), Color(0xFFCADBEB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: BarChart(
                      BarChartData(
                        barGroups: buildChartData(state.doneAlarm),
                        titlesData: buildTitleData(state.doneAlarm),
                        axisTitleData: buildAxisTitle(),
                      ),
                    ),
                  ),
                ),
              );
            }
            return const Center(
              child: Text('No Data'),
            );
          },
        ),
      ),
    );
  }

  FlAxisTitleData buildAxisTitle() {
    return FlAxisTitleData(
      leftTitle: AxisTitle(
        showTitle: true,
        titleText: 'Duration (in second)',
      ),
      bottomTitle: AxisTitle(
        showTitle: true,
        titleText: 'Alarm time',
      ),
    );
  }

  List<BarChartGroupData> buildChartData(List<Alarm> alarms) {
    return List<BarChartGroupData>.from(
      alarms.map(
        (alarm) => BarChartGroupData(
          x: alarms.indexOf(alarm) + 1,
          barRods: [
            BarChartRodData(
              y: alarm.deltaTime!.toDouble(),
              borderRadius: BorderRadius.circular(2),
              colors: [const Color(0xFF222E63)],
              width: 16,
            )
          ],
        ),
      ),
    );
  }

  FlTitlesData buildTitleData(List<Alarm> alarms) {
    Alarm highestDelta = alarms.reduce(
      (a, b) => a.deltaTime! > b.deltaTime! ? a : b,
    );
    return FlTitlesData(
      show: true,
      topTitles: SideTitles(showTitles: false),
      rightTitles: SideTitles(
        showTitles: false,
        reservedSize: 40,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        interval: (highestDelta.deltaTime! / 7).ceilToDouble(),
      ),
      bottomTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            int index = (value - 1).toInt();
            return alarms[index].alarmTime.toStringAsTime;
          }),
    );
  }
}
