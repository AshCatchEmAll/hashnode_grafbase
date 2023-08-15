import 'package:flutter/material.dart';
import 'dart:math' as math;

class Sparkling extends StatefulWidget {
  const Sparkling({Key? key}) : super(key: key);

  @override
  _SparklingState createState() => _SparklingState();
}

class _SparklingState extends State<Sparkling>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;
  late List<MyStar> myStars;

  @override
  void initState() {
    super.initState();

    myStars = <MyStar>[];
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 250,
        ));
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        for (final star in myStars) {
          star.isEnable = math.Random().nextBool();
        }

        animationController.forward();
      }
    });
    animation = Tween<double>(begin: 0, end: 8).animate(CurvedAnimation(
        parent: animationController, curve: Curves.easeInOutSine));
    animation.addListener(() {
      setState(() {});
    });

    animationController.forward();
  }

  void postFrameCallback(_) {
    if (!mounted) {
      return;
    }
    final size = MediaQuery.of(context).size;
    if (myStars.isEmpty) {
      myStars = List.generate(60, (index) {
        double velocityX = 2 * (math.Random().nextDouble());//max velocity 2
        double velocityY = 2 * (math.Random().nextDouble());

        velocityX = math.Random().nextBool() ? velocityX : -velocityX;
        velocityY = math.Random().nextBool() ? velocityY : -velocityY;

        return MyStar(
            isEnable: math.Random().nextBool(),
            innerCirclePoints: 4,
            beamLength: math.Random().nextDouble() * (8 - 2) + 2,
            innerOuterRadiusRatio: 0.0,
            angleOffsetToCenterStar: 0,
            center: Offset(size.width * (math.Random().nextDouble()),
                size.height * (math.Random().nextDouble())),
            velocity: Offset(velocityX, velocityY),
            color: Colors.white);
      });
    } else {
      for (final star in myStars) {
        star.center = star.center + star.velocity;
        if (star.isEnable) {
          star.innerOuterRadiusRatio = animation.value;

          if (star.center.dx >= size.width) {
            if (star.velocity.dy > 0) {
              star.velocity = const Offset(-1, 1);
            } else {
              star.velocity = const Offset(-1, -1);
            }

            star.center = Offset(size.width, star.center.dy);
          } else if (star.center.dx <= 0) {
            if (star.velocity.dy > 0) {
              star.velocity = const Offset(1, 1);
            } else {
              star.velocity = const Offset(1, -1);
            }

            star.center = Offset(0, star.center.dy);
          } else if (star.center.dy >= size.height) {
            if (star.velocity.dx > 0) {
              star.velocity = const Offset(1, -1);
            } else {
              star.velocity = const Offset(-1, -1);
            }

            star.center = Offset(star.center.dx, size.height);
          } else if (star.center.dy <= 0) {
            if (star.velocity.dx > 0) {
              star.velocity = const Offset(1, 1);
            } else {
              star.velocity = const Offset(-1, 1);
            }

            star.center = Offset(star.center.dx, 0);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback(postFrameCallback);

    return CustomPaint(
        size: MediaQuery.of(context).size,
        painter: StarPainter(
          myStars: myStars,
        ));
  }
}

class StarPainter extends CustomPainter {
  List<MyStar> myStars;

  StarPainter({required this.myStars});

  List<Map> calcStarPoints(
      {required double centerX,
      required double centerY,
      required int innerCirclePoints,
      required double innerRadius,
      required double outerRadius,
      required double angleOffsetToCenterStar}) {
    final angle = ((math.pi) / innerCirclePoints);

    final totalPoints = innerCirclePoints * 2; // 10 in a 5-points star
    List<Map> points = [];
    for (int i = 0; i < totalPoints; i++) {
      bool isEvenIndex = i % 2 == 0;
      final r = isEvenIndex ? outerRadius : innerRadius;

      var currY = centerY + math.cos(i * angle + angleOffsetToCenterStar) * r;
      var currX = centerX + math.sin(i * angle + angleOffsetToCenterStar) * r;
      points.add({'x': currX, 'y': currY});
    }
    return points;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final myStar in myStars) {
      final innerRadius = myStar.beamLength / myStar.innerCirclePoints;
      final outerRadius = innerRadius * myStar.innerOuterRadiusRatio;

      List<Map> points = calcStarPoints(
          centerX: myStar.center.dx,
          centerY: myStar.center.dy,
          innerCirclePoints: myStar.innerCirclePoints,
          innerRadius: innerRadius,
          outerRadius: outerRadius,
          angleOffsetToCenterStar: myStar.angleOffsetToCenterStar);
      var star = Path()..moveTo(points[0]['x'], points[0]['y']);
      for (var point in points) {
        star.lineTo(point['x'], point['y']);
      }

      canvas.drawPath(
        star, 
        Paint()..color = myStar.color,
      );

    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


class MyStar {
  bool isEnable;
  int innerCirclePoints; //how many edges you need?
  double beamLength;
  double
      innerOuterRadiusRatio; // outter circle is x2 the inner // set star sharpness/chubbiness
  double angleOffsetToCenterStar;
  Offset center;
  Offset velocity;
  Color color;

  MyStar(
      {required this.isEnable,
      required this.innerCirclePoints,
      required this.beamLength,
      required this.innerOuterRadiusRatio,
      required this.angleOffsetToCenterStar,
      required this.center,
      required this.velocity,
      required this.color});
}

