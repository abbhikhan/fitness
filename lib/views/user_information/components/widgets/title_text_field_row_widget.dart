import 'package:fitness/extensions/shared_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/text_field_widget.dart';

class TitleTextFieldRowWidget extends StatelessWidget {
  const TitleTextFieldRowWidget({
    super.key,
    required this.title,
    this.hideTitle = false,
    this.textAlign,
    this.hintText,
    this.hintStyle,
    this.textEditingController,
    this.textInputAction,
    this.textInputType,
    this.onSaved,
    this.initialValue,
    this.focusNode,
  });

  final String title;
  final bool hideTitle;
  final TextAlign? textAlign;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final void Function(String?)? onSaved;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (hideTitle == false)
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        SizedBox(
          width: context.width * 0.35,
          child: TextFormFieldWidget(
            initialValue: initialValue,
            hintText: hintText ?? '',
            textAlign: textAlign ?? TextAlign.center,
            hintStyle: hintStyle ?? Theme.of(context).textTheme.headlineMedium,
            focusNode: focusNode,
            textEditingController: textEditingController,
            textInputAction: textInputAction ?? TextInputAction.next,
            textInputType: textInputType ?? TextInputType.text,
            onSaved: onSaved,
          ),
        ),
        // SizedBox(
        //   width: context.width * 0.12,
        // ),
      ],
    );
  }
}
