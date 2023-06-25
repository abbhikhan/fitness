import 'package:fitness/extensions/shared_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../../constants/app_images.dart';

class PlanSmallInfoWidget extends StatelessWidget {
  const PlanSmallInfoWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.proteins,
    required this.carbs,
    required this.fat,
    required this.onTap,
    required this.detailOnTap,
  });

  final String imagePath;
  final String title;
  final String proteins;
  final String carbs;
  final String fat;
  final VoidCallback onTap;
  final VoidCallback detailOnTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: detailOnTap,
            child: Container(
              width: context.width * 0.795,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              padding: EdgeInsets.symmetric(
                vertical: context.height * 0.006,
                horizontal: context.width * 0.011,
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      25,
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        imagePath,
                        // height: context.height * 0.097,
                        // width: context.width * 0.097,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: context.width * 0.012,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: context.width * 0.43,
                        child: Text(
                          '$title  ',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 12,
                                  ),
                        ),
                      ),
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      Text(
                        'Protien   $proteins',
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 14,
                                ),
                      ),
                      Text(
                        'Carbs      $carbs',
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 14,
                                ),
                      ),
                      Text(
                        'Fat          $fat',
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 14,
                                ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // const Spacer(),
          SizedBox(
            width: context.width * 0.004,
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              // padding: const EdgeInsets.all(3),
              height: double.infinity,
              width: context.width * 0.095,
              alignment: Alignment.center,
              child: Image.asset(
                AppImages.bothArrows,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
