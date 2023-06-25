import 'dart:math';

import 'package:fitness/controllers/users_controller.dart';
import 'package:fitness/extensions/shared_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoalSliderWidget extends StatefulWidget {
  const GoalSliderWidget({super.key});

  @override
  State<GoalSliderWidget> createState() => _GoalSliderWidgetState();
}

class _GoalSliderWidgetState extends State<GoalSliderWidget> {
  double _value = 0.0;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
        trackHeight: 3,
        trackShape: RectangularSliderTrackShape(),
      ),
      child: Container(
        height: context.height * 0.6,
        child: RotatedBox(
          quarterTurns: 1,
          child: Slider(
            value: context.watch<UsersController>().weightGoal,
            thumbColor: Colors.black,
            activeColor: Colors.black,
            inactiveColor: Colors.black,
            overlayColor: const MaterialStatePropertyAll(Colors.transparent),
            secondaryActiveColor: Colors.black,
            onChanged: (double value) {
              print(value);
              context.read<UsersController>().weightGoal = value;
            },
            min: 0.0,
            max: 1.0,
            divisions: 4,
          ),
        ),
      ),
    );
  }
}
