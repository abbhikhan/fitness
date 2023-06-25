import 'package:fitness/helpers/shared_helpers.dart';
import 'package:flutter/material.dart';

import '../../../../constants/app_images.dart';

class ForwardButtonWidget extends StatelessWidget {
  const ForwardButtonWidget({
    super.key,
    required this.pageController,
    this.textEditingController,
    this.text2EditingController,
    this.text3EditingController,
    this.text4EditingController,
    this.text5EditingController,
    this.validatorText,
    this.validatorText2,
    this.validatorText3,
    this.validatorText4,
    this.validatorText5,
    this.onTap,
  });

  final PageController pageController;
  final TextEditingController? textEditingController;
  final TextEditingController? text2EditingController;
  final TextEditingController? text3EditingController;
  final TextEditingController? text4EditingController;
  final TextEditingController? text5EditingController;
  final String? validatorText;
  final String? validatorText2;
  final String? validatorText3;
  final String? validatorText4;
  final String? validatorText5;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        if (textEditingController != null) {
          if (textEditingController!.text.isEmpty) {
            SharedHelpers.textFieldsPopup(
              text: 'Enter $validatorText',
            );
            return;
          }
        }

        if (text2EditingController != null) {
          if (text2EditingController!.text.isEmpty) {
            SharedHelpers.textFieldsPopup(
              text: 'Enter $validatorText2',
            );
            return;
          }
        }

        if (text3EditingController != null) {
          if (text3EditingController!.text.isEmpty) {
            SharedHelpers.textFieldsPopup(
              text: 'Enter $validatorText3',
            );
            return;
          }
        }

        if (text4EditingController != null) {
          if (text4EditingController!.text.isEmpty) {
            SharedHelpers.textFieldsPopup(
              text: 'Enter $validatorText4',
            );
            return;
          }
        }

        if (text5EditingController != null) {
          if (text5EditingController!.text.isEmpty) {
            SharedHelpers.textFieldsPopup(
              text: 'Enter $validatorText5',
            );
            return;
          }
        }

        pageController.nextPage(
          duration: const Duration(seconds: 1),
          curve: Curves.easeIn,
        );
      },
      child: Image.asset(
        AppImages.forwardArrow,
      ),
    );
  }
}
