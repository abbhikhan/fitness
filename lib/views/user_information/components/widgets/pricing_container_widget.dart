import 'package:fitness/extensions/shared_extensions.dart';
import 'package:flutter/material.dart';

class PricingContainerWidget extends StatelessWidget {
  const PricingContainerWidget({
    super.key,
    required this.title,
    required this.amount,
    this.subtitle,
    required this.backgroundColor,
    required this.onTap,
  });

  final String title;
  final String amount;
  final String? subtitle;
  final Color backgroundColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.width * 0.99,
        // height: context.height * 0.123,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(25),
        ),
        padding: EdgeInsets.only(
          left: context.width * 0.08,
          right: context.width * 0.03,
          top: context.height * 0.03,
          bottom: context.height * 0.03,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    // fontSize: 18,
                    ),
              ),
              SizedBox(
                height: context.height * 0.02,
              ),
              Text(
                amount,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontSize: 18,
                    ),
              ),
              if (subtitle != '')
                SizedBox(
                  height: context.height * 0.008,
                ),
              if (subtitle != '')
                Text(
                  subtitle ?? '',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      // fontSize: 18,
                      ),
                ),
            ]),
      ),
    );
  }
}
