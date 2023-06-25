import 'package:fitness/extensions/shared_extensions.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double value;
  final double maxValue;
  final double barHeight;
  final double barWidth;
  final Color color;
  final Color? backgroundColor;
  final bool showTitle;

  const ProgressBar({
    super.key,
    this.value = 0,
    this.maxValue = 150,
    this.barHeight = 5,
    this.barWidth = double.infinity,
    this.color = Colors.green,
    this.backgroundColor,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    double percent = value / maxValue;
    return Container(
      height: barHeight,
      width: barWidth,
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color.fromRGBO(212, 212, 212, 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          FractionallySizedBox(
            widthFactor: percent,
            // heightFactor: percent,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VeticleProgressBar extends StatelessWidget {
  final double value;
  final double maxValue;
  final double barHeight;
  final double barWidth;
  final Color color;
  final Color backgrounColor;
  final bool showTitle;
  final Color textColor;

  const VeticleProgressBar({
    super.key,
    this.value = 0,
    this.maxValue = 150,
    this.barHeight = 5,
    this.barWidth = double.infinity,
    this.color = Colors.green,
    this.backgrounColor = Colors.green,
    this.textColor = Colors.green,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    double percent = value / maxValue;
    return Container(
      // height: 112,
      height: context.height * 0.145,
      width: context.width * 0.27,
      decoration: BoxDecoration(
        color: backgrounColor,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            // width: context.width * 0.22,
            child: FractionallySizedBox(
              heightFactor: percent,
              // widthFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(35),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text("${value.toInt()}%",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: textColor,
                    )),
          ),
        ],
      ),
    );
  }
}

class VerticalProgressBarr extends StatelessWidget {
  final double value;
  final Color color;
  final double width;
  final double height;
  final Color textColor;
  final Color backgroundColor;

  VerticalProgressBarr({
    required this.value,
    this.color = Colors.blue,
    this.width = 10.0,
    this.height = 200.0,
    this.textColor = Colors.green,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height * 0.145,
      width: context.width * 0.27,
      child: Stack(
        children: [
          SizedBox(
            height: context.height * 0.145,
            width: context.width * 0.27,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: RotatedBox(
                quarterTurns: -1,
                child: LinearProgressIndicator(
                  value: (value - 0.1) / (100 - 0),
                  backgroundColor: backgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ),
          ),
          Center(
            child: Text("${value.toInt()}%",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: textColor,
                    )),
          ),
        ],
      ),
    );
  }
}
