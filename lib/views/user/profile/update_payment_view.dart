import 'package:fitness/extensions/shared_extensions.dart';
import 'package:fitness/helpers/user_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../controllers/users_controller.dart';
import '../../../helpers/shared_helpers.dart';
import '../../../widgets/scaffold_widget.dart';
import '../../../widgets/text_field_widget.dart';
import '../../user_information/components/widgets/pricing_container_widget.dart';

class UpdatePaymentView extends StatefulWidget {
  const UpdatePaymentView({super.key});

  @override
  State<UpdatePaymentView> createState() => _UpdatePaymentViewState();
}

class _UpdatePaymentViewState extends State<UpdatePaymentView> {
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
              'Choose pricing plan',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontSize: 30,
                  ),
            ),
            SizedBox(
              height: context.height * 0.05,
            ),
            PricingContainerWidget(
              title: 'Monthly',
              amount: '€75.00/mo',
              subtitle: '',
              backgroundColor: Colors.white,
              onTap: () {
                if (context.read<UsersController>().paymentStatus) {
                  SharedHelpers.textFieldsPopup(
                    text: 'You have already paid',
                  );
                  return;
                }
                UserHelpers.makePayment(
                  amount: '75',
                  context: context,
                  type: 'monthly',
                );
              },
            ),
            SizedBox(
              height: context.height * 0.05,
            ),
            PricingContainerWidget(
              title: 'Yearly',
              amount: '€75.00/mo',
              subtitle: 'You save €300 per year',
              backgroundColor: const Color.fromRGBO(237, 237, 237, 1),
              onTap: () {
                if (context.read<UsersController>().paymentStatus) {
                  SharedHelpers.textFieldsPopup(
                    text: 'You have already paid',
                  );
                  return;
                }
                UserHelpers.makePayment(
                  amount: '75',
                  context: context,
                  type: 'yearly',
                );
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                UserHelpers.updatePayment(
                  context: context,
                  paidAmount: context.read<UsersController>().amount,
                  paidType: context.read<UsersController>().type,
                  paymentStatus: context.read<UsersController>().paymentStatus,
                );
              },
              child: Text(
                "Let's hit your goal",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 20,
                      color: Colors.white,
                    ),
              ),
            ),
            SizedBox(
              height: context.height * 0.062,
            ),
          ],
        ),
      ),
    );
  }
}
