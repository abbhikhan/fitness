import 'package:fitness/extensions/shared_extensions.dart';
import 'package:flutter/material.dart';


class InformationBodyWidget extends StatelessWidget {
  const InformationBodyWidget({
    super.key,
    required this.pageController,
    required this.body,
  });

  final PageController pageController;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: context.height * 0.1,
        ),
        Text(
          'What is your morning weight',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        body,
        GestureDetector(
          onTap: () {
            pageController.nextPage(
              duration: const Duration(seconds: 1),
              curve: Curves.easeIn,
            );
          },
          child: const Icon(
            Icons.arrow_circle_right_outlined,
            size: 48,
          ),
        ),
        SizedBox(
          height: context.height * 0.05,
        ),
      ],
    );
  }
}
