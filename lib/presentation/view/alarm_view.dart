import 'package:alarm/presentation/bloc/clock_bloc.dart';
import 'package:alarm/presentation/cubit/alarm_cubit.dart';
import 'package:alarm/presentation/view/alarm_chart_view.dart';
import 'package:alarm/presentation/widget/clock.dart';
import 'package:alarm/util/extension/time_of_day.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlarmView extends StatefulWidget {
  const AlarmView({Key? key}) : super(key: key);

  @override
  _AlarmViewState createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> {
  Offset startOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ClockBloc, ClockState>(
          listener: (context, state) {
            if (state is ClockChanged) {
              context.read<AlarmCubit>().onSetInactive();
              context.read<AlarmCubit>().onClockChanged(state.time);
            }
          },
        ),
        BlocListener<AlarmCubit, AlarmState>(
          listener: (context, state) {
            if (state.alarm.isActive) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Alarm Active'),
                ),
              );
            }
          },
        ),
      ],
      child: Builder(builder: (context) {
        AlarmCubit alarmCubit = context.watch<AlarmCubit>();
        TimeOfDay alarmTime = alarmCubit.state.alarm.alarmTime;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text('Alarm'),
            backgroundColor: Colors.white70,
            actions: [
              Switch(
                value: alarmCubit.state.alarm.isActive,
                onChanged: (_) => context.read<AlarmCubit>().onToggleChanged(),
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                alarmTime.toStringAsTime,
                style: Theme.of(context).textTheme.headline3!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onVerticalDragStart: (x) => startOffset = x.localPosition,
                onVerticalDragUpdate: (x) => onYDragHandler(x, alarmTime),
                onVerticalDragEnd: (x) => onDragEndHandler(),
                onHorizontalDragStart: (x) => startOffset = x.localPosition,
                onHorizontalDragUpdate: (x) => onXDragHandler(x, alarmTime),
                onHorizontalDragEnd: (details) => onDragEndHandler(),
                child: Center(
                  child: Clock(
                    time: alarmTime,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> checkPermission() async {
    List<NotificationPermission> permissionList = [
      NotificationPermission.Sound,
      NotificationPermission.Vibration,
      NotificationPermission.Alert,
      NotificationPermission.CriticalAlert,
      NotificationPermission.PreciseAlarms,
      // NotificationPermission.OverrideDnD,
      NotificationPermission.Badge,
    ];

    List<NotificationPermission> permissionsAllowed =
        await AwesomeNotifications()
            .checkPermissionList(permissions: permissionList);

    if (permissionsAllowed.length == permissionList.length) return;

    List<NotificationPermission> permissionsNeeded =
        permissionList.toSet().difference(permissionsAllowed.toSet()).toList();
    List<NotificationPermission> lockedPermissions =
        await AwesomeNotifications()
            .shouldShowRationaleToRequest(permissions: permissionsNeeded);

    if (lockedPermissions.isEmpty) {
      await AwesomeNotifications()
          .requestPermissionToSendNotifications(permissions: permissionsNeeded);
      permissionsAllowed = await AwesomeNotifications()
          .checkPermissionList(permissions: permissionsNeeded);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Allow Notifications'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'To proceede, you need to enable the permissions above:',
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                lockedPermissions
                    .join(', ')
                    .replaceAll('NotificationPermission.', ''),
                maxLines: 2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Don\'t Allow',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            ),
            TextButton(
              onPressed: () => AwesomeNotifications()
                  .requestPermissionToSendNotifications()
                  .then((_) => Navigator.pop(context)),
              child: const Text(
                'Allow',
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    checkPermission();
    AwesomeNotifications().actionStream.listen((notification) {
      context.read<AlarmCubit>().onSetDone();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const AlarmChartView(),
        ),
      );
    });
  }

  void onDragEndHandler() {
    context.read<ClockBloc>().add(ClockDragStop());
  }

  void onXDragHandler(
    DragUpdateDetails details,
    TimeOfDay alarmTime,
  ) {
    context.read<ClockBloc>().add(ClockHorizontalDrag(
          offsetStart: startOffset,
          offsetNow: details.localPosition,
          alarmTime: alarmTime,
        ));
  }

  void onYDragHandler(
    DragUpdateDetails details,
    TimeOfDay alarmTime,
  ) {
    context.read<ClockBloc>().add(ClockVerticalDrag(
          offsetStart: startOffset,
          offsetNow: details.localPosition,
          alarmTime: alarmTime,
        ));
  }
}
