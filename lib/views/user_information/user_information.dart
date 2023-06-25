import 'dart:io';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/extensions/shared_extensions.dart';
import 'package:fitness/helpers/user_helpers.dart';
import 'package:fitness/widgets/scaffold_widget.dart';
import 'package:fitness/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_images.dart';
import '../../controllers/users_controller.dart';
import '../../database/firebase.dart';
import '../../helpers/shared_helpers.dart';
import '../user/profile/components/widgets/meal_slider_widget.dart';
import 'components/widgets/forward_button_widget.dart';
import 'components/widgets/goal_slider_widget.dart';
import 'components/widgets/pricing_container_widget.dart';
import 'components/widgets/title_text_field_row_widget.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({super.key});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final PageController pageController = PageController();
  double circlePosition = 0.0;
  double minCirclePosition = -1.0;
  double maxCirclePosition = 1.0;

  final TextEditingController morningWeightTextEditingController =
      TextEditingController();
  int weightGoal = 2;
  int mealsPerDay = 0;
  final TextEditingController breakfastTextEditingController =
      TextEditingController()..text = '20';
  final TextEditingController lunchTextEditingController =
      TextEditingController()..text = '20';
  final TextEditingController dinnerTextEditingController =
      TextEditingController()..text = '20';
  final TextEditingController snackTextEditingController =
      TextEditingController()..text = '20';
  final TextEditingController snack2extEditingController =
      TextEditingController()..text = '20';
  final TextEditingController amountTextEditingController =
      TextEditingController();
  final TextEditingController allergy1TextEditingController =
      TextEditingController();
  final TextEditingController allergy2TextEditingController =
      TextEditingController();
  final TextEditingController allergy3TextEditingController =
      TextEditingController();

  final FocusNode morningWeightFocusNode = FocusNode();
  final FocusNode breakfastFocusNode = FocusNode();
  final FocusNode lunchFocusNode = FocusNode();
  final FocusNode dinnerFocusNode = FocusNode();
  final FocusNode snackFocusNode = FocusNode();
  final FocusNode snack2FocusNode = FocusNode();
  final FocusNode amountFocusNode = FocusNode();
  final FocusNode allergy1FocusNode = FocusNode();
  final FocusNode allergy2FocusNode = FocusNode();
  final FocusNode allergy3FocusNode = FocusNode();

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  _getFutureFirebase() {
    return _memoizer.runOnce(() async {
      return FirebaseEndPoints.userCollection
          .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
          .get();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ScaffoldWidget(
          useSingleChildScrollView: true,
          edgeInsets: EdgeInsets.symmetric(
            horizontal: context.width * 0.084,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder(
                future: _getFutureFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    if (snapshot.error is SocketException) {
                      return const Text('No internet connection.');
                    } else {
                      return Text('An error occurred: ${snapshot.error}');
                    }
                  } else if (snapshot.hasData) {
                    final ss = snapshot.data as DocumentSnapshot;
                    final futureDocs = ss.data() as Map<String, dynamic>;
                    return PageView(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: context.height * 0.1,
                            ),
                            Text(
                              'What is your morning weight?',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const Spacer(),
                            SizedBox(
                              width: context.width * 0.4,
                              child: TextFieldWidget(
                                hintText: '90 Kg',
                                focusNode: morningWeightFocusNode,
                                textAlign: TextAlign.center,
                                textInputType: TextInputType.number,
                                textEditingController:
                                    morningWeightTextEditingController,
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                            SizedBox(
                              height: context.height * 0.057,
                            ),
                            ForwardButtonWidget(
                              pageController: pageController,
                              textEditingController:
                                  morningWeightTextEditingController,
                              validatorText: 'morning weight',
                            ),
                            SizedBox(
                              height: context.height * 0.062,
                            ),
                          ],
                        ),
                        
                        Column(
                          children: [
                            SizedBox(
                              height: context.height * 0.1,
                            ),
                            Text(
                              'What is your goal?',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            SizedBox(
                              height: context.height * 0.12,
                            ),
                            SizedBox(
                              width: context.width * 0.9,
                              height: context.height * 0.55,
                              child: Stack(
                                children: [
                                  Positioned(
                                    child: Image.asset(
                                      AppImages.scale,
                                      height: context.height * 0.55,
                                      width: context.width * 0.18,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Positioned(
                                    left: context.width * 0.23,
                                    top: context.height * 0.01,
                                    bottom: context.height * 0.01,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            context
                                                .read<UsersController>()
                                                .weightGoal = 0.0;
                                          },
                                          child: Text(
                                            'Extreme weight gain',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            context
                                                .read<UsersController>()
                                                .weightGoal = 0.25;
                                          },
                                          child: Text(
                                            'Weight gain',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            context
                                                .read<UsersController>()
                                                .weightGoal = 0.50;
                                          },
                                          child: Text(
                                            'Maintenance',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            context
                                                .read<UsersController>()
                                                .weightGoal = 0.75;
                                          },
                                          child: Text(
                                            'Weight loss',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            context
                                                .read<UsersController>()
                                                .weightGoal = 1.0;
                                          },
                                          child: Text(
                                            'Extreme Weight loss',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: context.width * 0.08,
                                    right: context.width * 0.52,
                                    top: context.height * 0.022,
                                    bottom: context.height * 0.022,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: context.width * 0.025,
                                          height: context.height * 0.003,
                                          color: Colors.black,
                                        ),
                                        Container(
                                          width: context.width * 0.025,
                                          height: context.height * 0.003,
                                          color: Colors.black,
                                        ),
                                        Container(
                                          width: context.width * 0.025,
                                          height: context.height * 0.003,
                                          color: Colors.black,
                                        ),
                                        Container(
                                          width: context.width * 0.025,
                                          height: context.height * 0.003,
                                          color: Colors.black,
                                        ),
                                        Container(
                                          width: context.width * 0.035,
                                          height: context.height * 0.003,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: context.width * 0.17,
                                    top: context.height * 0.009,
                                    bottom: context.height * 0.01,
                                    child: GoalSliderWidget(),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            ForwardButtonWidget(
                              pageController: pageController,
                            ),
                            SizedBox(
                              height: context.height * 0.062,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: context.height * 0.1,
                            ),
                            Text(
                              'How many meals would you like to have per day?',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const Spacer(),
                            MealSliderWidget(),
                            SizedBox(
                              height: context.height * 0.041,
                            ),
                            ForwardButtonWidget(pageController: pageController),
                            SizedBox(
                              height: context.height * 0.062,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: context.height * 0.1,
                            ),
                            Text(
                              'How much time do you have to prepare each meal?',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
                                    fontSize: 30,
                                  ),
                            ),
                            SizedBox(
                              height: context.height * 0.1,
                            ),
                            TitleTextFieldRowWidget(
                              title: 'breakfast',
                              hintText: '20min',
                              textEditingController:
                                  breakfastTextEditingController,
                              focusNode: breakfastFocusNode,
                              textInputType: TextInputType.number,
                            ),
                            SizedBox(
                              height: context.height * 0.02,
                            ),
                            TitleTextFieldRowWidget(
                              title: 'lunch',
                              hintText: '20min',
                              textEditingController: lunchTextEditingController,
                              focusNode: lunchFocusNode,
                              textInputType: TextInputType.number,
                            ),
                            SizedBox(
                              height: context.height * 0.02,
                            ),
                            TitleTextFieldRowWidget(
                              title: 'dinner',
                              hintText: '20min',
                              textEditingController:
                                  dinnerTextEditingController,
                              focusNode: dinnerFocusNode,
                              textInputType: TextInputType.number,
                              textInputAction: context
                                          .watch<UsersController>()
                                          .mealsPerDay ==
                                      3.0
                                  ? TextInputAction.done
                                  : TextInputAction.next,
                            ),
                            SizedBox(
                              height: context.height * 0.02,
                            ),
                            if (context.watch<UsersController>().mealsPerDay ==
                                    4.0 ||
                                context.watch<UsersController>().mealsPerDay ==
                                    5.0)
                              TitleTextFieldRowWidget(
                                title: 'snack',
                                hintText: '20min',
                                textEditingController:
                                    snackTextEditingController,
                                focusNode: snackFocusNode,
                                textInputType: TextInputType.number,
                                textInputAction: context
                                            .watch<UsersController>()
                                            .mealsPerDay ==
                                        4.0
                                    ? TextInputAction.done
                                    : TextInputAction.next,
                              ),
                            SizedBox(
                              height: context.height * 0.02,
                            ),
                            if (context.watch<UsersController>().mealsPerDay ==
                                5.0)
                              TitleTextFieldRowWidget(
                                title: 'snack2',
                                hintText: '20min',
                                textEditingController:
                                    snack2extEditingController,
                                focusNode: snack2FocusNode,
                                textInputType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                              ),
                            const Spacer(),
                            ForwardButtonWidget(
                              pageController: pageController,
                              textEditingController:
                                  breakfastTextEditingController,
                              text2EditingController:
                                  lunchTextEditingController,
                              text3EditingController:
                                  dinnerTextEditingController,
                              // text4EditingController:
                              //     snackTextEditingController,
                              // text5EditingController:
                              //     snack2extEditingController,
                              validatorText: 'breakfast',
                              validatorText2: 'lunch',
                              validatorText3: 'dinner',
                              // validatorText4: 'snack',
                              // validatorText5: 'snack 2',
                            ),
                            SizedBox(
                              height: context.height * 0.062,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: context.height * 0.1,
                            ),
                            Text(
                              'What is the maximum amount you can spend per day?',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const Spacer(),
                            SizedBox(
                                width: context.width * 0.5,
                                child: TextFieldWidget(
                                  hintText: '100 Euros',
                                  textAlign: TextAlign.center,
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                  textEditingController:
                                      amountTextEditingController,
                                  focusNode: amountFocusNode,
                                  textInputType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                )),
                            SizedBox(
                              height: context.height * 0.057,
                            ),
                            ForwardButtonWidget(
                              pageController: pageController,
                              textEditingController:
                                  amountTextEditingController,
                              validatorText: 'amount',
                            ),
                            SizedBox(
                              height: context.height * 0.062,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: context.height * 0.1,
                            ),
                            Text(
                              'Do you have any allergies?',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const Spacer(),
                            SizedBox(
                              width: context.width * 0.5,
                              child: TextFieldWidget(
                                hintText: '',
                                textAlign: TextAlign.center,
                                hintStyle:
                                    Theme.of(context).textTheme.headlineMedium,
                                textEditingController:
                                    allergy1TextEditingController,
                                focusNode: allergy1FocusNode,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            SizedBox(
                              height: context.height * 0.03,
                            ),
                            SizedBox(
                              width: context.width * 0.5,
                              child: TextFieldWidget(
                                hintText: '',
                                textAlign: TextAlign.center,
                                hintStyle:
                                    Theme.of(context).textTheme.headlineMedium,
                                textEditingController:
                                    allergy2TextEditingController,
                                focusNode: allergy2FocusNode,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            SizedBox(
                              height: context.height * 0.03,
                            ),
                            SizedBox(
                              width: context.width * 0.5,
                              child: TextFieldWidget(
                                hintText: '',
                                textAlign: TextAlign.center,
                                hintStyle:
                                    Theme.of(context).textTheme.headlineMedium,
                                textEditingController:
                                    allergy3TextEditingController,
                                focusNode: allergy3FocusNode,
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                            SizedBox(
                              height: context.height * 0.057,
                            ),
                            ForwardButtonWidget(
                              pageController: pageController,
                              // textEditingController:
                              //     allergy1TextEditingController,
                              // text2EditingController:
                              //     allergy2TextEditingController,
                              // text3EditingController:
                              //     allergy3TextEditingController,
                              // validatorText: 'allergy',
                              // validatorText2: 'allergy',
                              // validatorText3: 'allergy',
                              onTap: () {
                                // if (allergy1TextEditingController
                                //     .text.isEmpty) {
                                //   SharedHelpers.textFieldsPopup(
                                //     text: 'Enter allergy',
                                //   );
                                //   return;
                                // }

                                // if (allergy2TextEditingController
                                //     .text.isEmpty) {
                                //   SharedHelpers.textFieldsPopup(
                                //     text: 'Enter allergy',
                                //   );
                                //   return;
                                // }

                                // if (allergy3TextEditingController
                                //     .text.isEmpty) {
                                //   SharedHelpers.textFieldsPopup(
                                //     text: 'Enter allergy',
                                //   );
                                //   return;
                                // }
                                if (futureDocs.containsKey('paymentStatus')) {
                                  UserHelpers.userInformation(
                                    context: context,
                                    isUpdating: true,
                                    morningWeightTextEditingController:
                                        morningWeightTextEditingController,
                                    weightGoal: context
                                        .read<UsersController>()
                                        .weightGoal
                                        .toString(),
                                    mealsPerDay: context
                                        .read<UsersController>()
                                        .mealsPerDay
                                        .toString(),
                                    breakfastTextEditingController:
                                        breakfastTextEditingController,
                                    lunchTextEditingController:
                                        lunchTextEditingController,
                                    dinnerTextEditingController:
                                        dinnerTextEditingController,
                                    snackTextEditingController:
                                        snackTextEditingController,
                                    snack2TextEditingController:
                                        snack2extEditingController,
                                    amountTextEditingController:
                                        amountTextEditingController,
                                    allergy1TextEditingController:
                                        allergy1TextEditingController,
                                    allergy2TextEditingController:
                                        allergy2TextEditingController,
                                    allergy3TextEditingController:
                                        allergy3TextEditingController,
                                    paymentStatus: futureDocs['paymentStatus'],
                                    amount:
                                        context.read<UsersController>().amount,
                                    type: context.read<UsersController>().type,
                                  );
                                } else {
                                  pageController.nextPage(
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.easeIn,
                                  );
                                }
                              },
                            ),
                            SizedBox(
                              height: context.height * 0.062,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: context.height * 0.1,
                            ),
                            Text(
                              'Choose pricing plan',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
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
                                if (context
                                    .read<UsersController>()
                                    .paymentStatus) {
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
                              backgroundColor:
                                  const Color.fromRGBO(237, 237, 237, 1),
                              onTap: () {
                                if (context
                                    .read<UsersController>()
                                    .paymentStatus) {
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
                                UserHelpers.userInformation(
                                  context: context,
                                  isUpdating: false,
                                  morningWeightTextEditingController:
                                      morningWeightTextEditingController,
                                  weightGoal: context
                                      .read<UsersController>()
                                      .weightGoal
                                      .toString(),
                                  mealsPerDay: context
                                      .read<UsersController>()
                                      .mealsPerDay
                                      .toString(),
                                  breakfastTextEditingController:
                                      breakfastTextEditingController,
                                  lunchTextEditingController:
                                      lunchTextEditingController,
                                  dinnerTextEditingController:
                                      dinnerTextEditingController,
                                  snackTextEditingController:
                                      snackTextEditingController,
                                  snack2TextEditingController:
                                      snack2extEditingController,
                                  amountTextEditingController:
                                      amountTextEditingController,
                                  allergy1TextEditingController:
                                      allergy1TextEditingController,
                                  allergy2TextEditingController:
                                      allergy2TextEditingController,
                                  allergy3TextEditingController:
                                      allergy3TextEditingController,
                                  paymentStatus: context
                                      .read<UsersController>()
                                      .paymentStatus,
                                  amount:
                                      context.read<UsersController>().amount,
                                  type: context.read<UsersController>().type,
                                );
                              },
                              child: Text(
                                "Let's hit your goal",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
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
                      ],
                    );
                  } else {
                    return const Text('No data available.');
                  }
                }),
          )),
    );
  }
}

class HorizontalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
