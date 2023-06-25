import 'package:fitness/controllers/users_controller.dart';
import 'package:fitness/extensions/shared_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MealSliderWidget extends StatefulWidget {
  const MealSliderWidget({super.key});

  @override
  State<MealSliderWidget> createState() => _MealSliderWidgetState();
}

class _MealSliderWidgetState extends State<MealSliderWidget> {
  double _value = 0.0;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
        trackHeight: 3,
        trackShape: RectangularSliderTrackShape(),
      ),
      child: SizedBox(
        height: context.height * 0.118,
        child: Stack(
          children: [
            Positioned(
              left: context.width * 0.025,
              right: context.width * 0.025,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '3',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontSize: 20,
                        ),
                  ),
                  Text(
                    '4',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontSize: 20,
                        ),
                  ),
                  Text(
                    '5',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontSize: 20,
                        ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: context.width * 0.035,
              right: context.width * 0.035,
              top: context.height * 0.046,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 3,
                    height: 20,
                    color: Colors.black,
                  ),
                  Container(
                    width: 3,
                    height: 20,
                    color: Colors.black,
                  ),
                  Container(
                    width: 3,
                    height: 20,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            Slider(
              value: context.watch<UsersController>().mealsPerDay,
              thumbColor: Colors.black,
              activeColor: Colors.black,
              inactiveColor: Colors.black,
              overlayColor: const MaterialStatePropertyAll(Colors.transparent),
              secondaryActiveColor: Colors.black,
              onChanged: (double value) {
                context.read<UsersController>().mealsPerDay = value;
                // setState(() {
                //   _value = value;
                // });
              },
              min: 3.0,
              max: 5.0,
              divisions: 2,
              // label: _value.toStringAsFixed(2),
            ),
          ],
        ),
      ),
    );
  }
}
