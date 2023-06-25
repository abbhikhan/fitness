import 'package:fitness/controllers/users_controller.dart';
import 'package:fitness/extensions/shared_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoalSelectableWidget extends StatelessWidget {
  const GoalSelectableWidget({
    super.key,
    required this.title,
    required this.onTap,
    required this.backgroundColor,
  });

  final String title;
  final VoidCallback onTap;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          color: backgroundColor,
        ),
        width: context.width * 0.6,
        padding: const EdgeInsets.symmetric(
          vertical: 13,
          horizontal: 16,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 16,
              ),
        ),
      ),
    );
  }
}
