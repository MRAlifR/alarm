import 'dart:async';

import 'package:alarm/util/ticker.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'clock_event.dart';
part 'clock_state.dart';

enum ClockDragPosition {
  none,
  xPositiveSlow,
  xPositiveNormal,
  xPositiveFast,
  xNegativeSlow,
  xNegativeNormal,
  xNegativeFast,
  yPositiveSlow,
  yPositiveNormal,
  yPositiveFast,
  yNegativeSlow,
  yNegativeNormal,
  yNegativeFast,
}

class ClockBloc extends Bloc<ClockEvent, ClockState> {
  static const int slowTreshold = 0;
  static const int normalTreshold = 50;
  static const int fastTreshold = 130;

  static const int slowTimeMilis = 300;
  static const int normalTimeMilis = 100;
  static const int fastTimeMilis = 10;

  ClockBloc({
    required this.xTicker,
    required this.yTicker,
  }) : super(ClockInitial(TimeOfDay.now())) {
    on<ClockVerticalDrag>(_onVerticalDrag);
    on<ClockHorizontalDrag>(_onHorizontalDrag);
    on<ClockDragStop>(_onDragStop);
    on<ClockTicked>(_onClockTicked);
  }

  final Ticker xTicker;
  final Ticker yTicker;

  StreamSubscription<int>? xTickerSubs;
  StreamSubscription<int>? yTickerSubs;

  ClockDragPosition lastXPosition = ClockDragPosition.none;
  ClockDragPosition lastYPosition = ClockDragPosition.none;

  void _onDragStop(ClockDragStop event, Emitter<ClockState> emit) {
    xTickerSubs?.cancel();
    yTickerSubs?.cancel();
    lastXPosition = ClockDragPosition.none;
    lastYPosition = ClockDragPosition.none;
  }

  void _onClockTicked(ClockTicked event, Emitter<ClockState> emit) {
    emit(ClockChanged(event.time));
  }

  void _onVerticalDrag(ClockVerticalDrag event, Emitter<ClockState> emit) {
    Offset deltaOffset = Offset(
      event.offsetNow.dx - event.offsetStart.dx,
      event.offsetNow.dy - event.offsetStart.dy,
    );

    double absDeltaY = deltaOffset.dy.abs();
    if (absDeltaY >= slowTreshold && absDeltaY < normalTreshold) {
      if (lastYPosition != ClockDragPosition.yPositiveSlow) {
        yTickerSubs?.cancel();
        if (deltaOffset.dy < 0) {
          Stream<int> yTickerStream = yTicker.tickIncrement(
            interval: const Duration(milliseconds: slowTimeMilis),
            initialValue: event.alarmTime.hour,
            maxValue: 23,
          );
          yTickerSubs = yTickerStream.listen((newHour) {
            add(ClockTicked(time: event.alarmTime.replacing(hour: newHour)));
          });
        } else {
          Stream<int> yTickerStream = yTicker.tickDecrement(
            interval: const Duration(milliseconds: slowTimeMilis),
            initialValue: event.alarmTime.hour,
            minValue: 0,
          );
          yTickerSubs = yTickerStream.listen((newHour) {
            add(ClockTicked(time: event.alarmTime.replacing(hour: newHour)));
          });
        }
      }
      lastYPosition = ClockDragPosition.yPositiveSlow;
    } else if (absDeltaY >= normalTreshold && absDeltaY < fastTreshold) {
      if (lastYPosition != ClockDragPosition.yPositiveNormal) {
        yTickerSubs?.cancel();
        if (deltaOffset.dy < 0) {
          Stream<int> yTickerStream = yTicker.tickIncrement(
            interval: const Duration(milliseconds: normalTimeMilis),
            initialValue: event.alarmTime.hour,
            maxValue: 23,
          );
          yTickerSubs = yTickerStream.listen((newHour) {
            add(ClockTicked(time: event.alarmTime.replacing(hour: newHour)));
          });
        } else {
          Stream<int> yTickerStream = yTicker.tickDecrement(
            interval: const Duration(milliseconds: normalTimeMilis),
            initialValue: event.alarmTime.hour,
            minValue: 0,
          );
          yTickerSubs = yTickerStream.listen((newHour) {
            add(ClockTicked(time: event.alarmTime.replacing(hour: newHour)));
          });
        }
      }
      lastYPosition = ClockDragPosition.yPositiveNormal;
    } else if (absDeltaY >= fastTreshold) {
      if (lastYPosition != ClockDragPosition.yPositiveFast) {
        yTickerSubs?.cancel();
        if (deltaOffset.dy < 0) {
          Stream<int> yTickerStream = yTicker.tickIncrement(
            interval: const Duration(milliseconds: fastTimeMilis),
            initialValue: event.alarmTime.hour,
            maxValue: 23,
          );
          yTickerSubs = yTickerStream.listen((newHour) {
            add(ClockTicked(time: event.alarmTime.replacing(hour: newHour)));
          });
        } else {
          Stream<int> yTickerStream = yTicker.tickDecrement(
            interval: const Duration(milliseconds: fastTimeMilis),
            initialValue: event.alarmTime.hour,
            minValue: 0,
          );
          yTickerSubs = yTickerStream.listen((newHour) {
            add(ClockTicked(time: event.alarmTime.replacing(hour: newHour)));
          });
        }
      }
      lastYPosition = ClockDragPosition.yPositiveFast;
    }
  }

  void _onHorizontalDrag(ClockHorizontalDrag event, Emitter<ClockState> emit) {
    Offset deltaOffset = Offset(
      event.offsetNow.dx - event.offsetStart.dx,
      event.offsetNow.dy - event.offsetStart.dy,
    );

    double absDeltaX = deltaOffset.dx.abs();
    if (absDeltaX >= slowTreshold && absDeltaX < normalTreshold) {
      if (lastXPosition != ClockDragPosition.xPositiveSlow) {
        xTickerSubs?.cancel();
        if (deltaOffset.dx >= 0) {
          Stream<int> xTickerStream = xTicker.tickIncrement(
            interval: const Duration(milliseconds: slowTimeMilis),
            initialValue: event.alarmTime.minute,
            maxValue: 59,
          );
          xTickerSubs = xTickerStream.listen((newMinute) {
            add(ClockTicked(
                time: event.alarmTime.replacing(minute: newMinute)));
          });
        } else {
          Stream<int> xTickerStream = xTicker.tickDecrement(
            interval: const Duration(milliseconds: slowTimeMilis),
            initialValue: event.alarmTime.minute,
            minValue: 0,
          );
          xTickerSubs = xTickerStream.listen((newMinute) {
            add(ClockTicked(
                time: event.alarmTime.replacing(minute: newMinute)));
          });
        }
      }
      lastXPosition = ClockDragPosition.xPositiveSlow;
    } else if (absDeltaX >= normalTreshold && absDeltaX < fastTreshold) {
      if (lastXPosition != ClockDragPosition.xPositiveNormal) {
        xTickerSubs?.cancel();
        if (deltaOffset.dx >= 0) {
          Stream<int> xTickerStream = xTicker.tickIncrement(
            interval: const Duration(milliseconds: normalTimeMilis),
            initialValue: event.alarmTime.minute,
            maxValue: 59,
          );
          xTickerSubs = xTickerStream.listen((newMinute) {
            add(ClockTicked(
                time: event.alarmTime.replacing(minute: newMinute)));
          });
        } else {
          Stream<int> xTickerStream = xTicker.tickDecrement(
            interval: const Duration(milliseconds: normalTimeMilis),
            initialValue: event.alarmTime.minute,
            minValue: 0,
          );
          xTickerSubs = xTickerStream.listen((newMinute) {
            add(ClockTicked(
                time: event.alarmTime.replacing(minute: newMinute)));
          });
        }
      }
      lastXPosition = ClockDragPosition.xPositiveNormal;
    } else if (absDeltaX >= fastTreshold) {
      if (lastXPosition != ClockDragPosition.xPositiveFast) {
        xTickerSubs?.cancel();
        if (deltaOffset.dx >= 0) {
          Stream<int> xTickerStream = xTicker.tickIncrement(
            interval: const Duration(milliseconds: fastTimeMilis),
            initialValue: event.alarmTime.minute,
            maxValue: 59,
          );
          xTickerSubs = xTickerStream.listen((newMinute) {
            add(ClockTicked(
                time: event.alarmTime.replacing(minute: newMinute)));
          });
        } else {
          Stream<int> xTickerStream = xTicker.tickDecrement(
            interval: const Duration(milliseconds: fastTimeMilis),
            initialValue: event.alarmTime.minute,
            minValue: 0,
          );
          xTickerSubs = xTickerStream.listen((newMinute) {
            add(ClockTicked(
                time: event.alarmTime.replacing(minute: newMinute)));
          });
        }
      }
      lastXPosition = ClockDragPosition.xPositiveFast;
    }
  }
}
