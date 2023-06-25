import 'package:fitness/extensions/shared_extensions.dart';
import 'package:fitness/helpers/user_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../widgets/scaffold_widget.dart';
import '../../../widgets/text_field_widget.dart';

class UpdateWeightView extends StatefulWidget {
  const UpdateWeightView({super.key});

  @override
  State<UpdateWeightView> createState() => _UpdateWeightViewState();
}

class _UpdateWeightViewState extends State<UpdateWeightView> {
  final TextEditingController morningWeightTextEditingController =
      TextEditingController();
  final FocusNode morningWeightFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ScaffoldWidget(
        resizeToAvoidBottomInset: false,
        child: Column(
          children: [
            SizedBox(
              height: context.height * 0.1,
            ),
            Text(
              'Update your weight',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(
              height: context.height * 0.3,
            ),
            TextFieldWidget(
              hintText: '',
              focusNode: morningWeightFocusNode,
              textAlign: TextAlign.center,
              textInputType: TextInputType.number,
              textEditingController: morningWeightTextEditingController,
              textInputAction: TextInputAction.done,
              textInputFormatter: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                UserHelpers.updateUserWeight(
                  context: context,
                  textEditingController: morningWeightTextEditingController,
                );
              },
              child: Text(
                "Update Weight",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 20,
                      color: Colors.white,
                    ),
              ),
            ),
            SizedBox(
              height: context.height * 0.057,
            ),
          ],
        ),
      ),
    );
  }
}
