import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class Clock extends StatelessWidget {
  const Clock({
    Key? key,
    required this.time,
  }) : super(key: key);

  final TimeOfDay time;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3F6080).withOpacity(.2),
                  blurRadius: 32,
                  offset: const Offset(40, 20),
                ),
                BoxShadow(
                  color: const Color(0xFFFFFFFF).withOpacity(1),
                  blurRadius: 32,
                  offset: const Offset(-20, -10),
                ),
              ],
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFECF6FF), Color(0xFFCADBEB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3F6080).withOpacity(.2),
                  blurRadius: 32,
                  offset: const Offset(10, 5),
                ),
                BoxShadow(
                  color: const Color(0xFFFFFFFF).withOpacity(1),
                  blurRadius: 32,
                  offset: const Offset(-10, -5),
                ),
              ],
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFE3F0F8), Color(0xFFEEF5FD)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          Transform.rotate(
            angle: pi / 2,
            child: Container(
              constraints: const BoxConstraints.expand(),
              child: CustomPaint(
                painter: ClockPainter(time: time),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  ClockPainter({
    required this.time,
  });

  final TimeOfDay time;

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    Offset center = Offset(centerX, centerY);
    double radius = min(centerY, centerX);

    Paint dashPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    Paint secdashPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    double outerRadius = radius - 20;
    double innerRadius = radius - 30;
    for (int i = 0; i < 360; i += 30) {
      double x1 = centerX - outerRadius * cos(i * pi / 180);
      double y1 = centerX - outerRadius * sin(i * pi / 180);
      double x2 = centerX - innerRadius * cos(i * pi / 180);
      double y2 = centerX - innerRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashPaint);
    }
    for (int i = 0; i < 360; i += 6) {
      double x1 = centerX - outerRadius * .95 * cos(i * pi / 180);
      double y1 = centerX - outerRadius * .95 * sin(i * pi / 180);
      double x2 = centerX - innerRadius * cos(i * pi / 180);
      double y2 = centerX - innerRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), secdashPaint);
    }

    Offset minStartOffset = Offset(
      centerX - outerRadius * .6 * cos(time.minute * 6 * pi / 180),
      centerX - outerRadius * .6 * sin(time.minute * 6 * pi / 180),
    );
    Offset minEndOffset = Offset(
      centerX + 20 * cos(time.minute * 6 * pi / 180),
      centerX + 20 * sin(time.minute * 6 * pi / 180),
    );

    Offset hourStartOffset = Offset(
      centerX -
          outerRadius *
              .4 *
              cos((time.hour * 30 + time.minute * 0.5) * pi / 180),
      centerX -
          outerRadius *
              .4 *
              sin((time.hour * 30 + time.minute * 0.5) * pi / 180),
    );
    Offset hourEndOffset = Offset(
      centerX + 20 * cos((time.hour * 30 + time.minute * 0.5) * pi / 180),
      centerX + 20 * sin((time.hour * 30 + time.minute * 0.5) * pi / 180),
    );

    Paint centerCirclePaint = Paint()..color = const Color(0xFFE81466);
    Paint minPaint = Paint()
      ..color = const Color(0xFFBEC5D5)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    Paint hourPaint = Paint()
      ..color = const Color(0xFF222E63)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(minStartOffset, minEndOffset, minPaint);
    canvas.drawLine(hourStartOffset, hourEndOffset, hourPaint);
    canvas.drawCircle(center, 4, centerCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
