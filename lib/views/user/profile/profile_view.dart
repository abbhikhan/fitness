import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/extensions/shared_extensions.dart';
import 'package:fitness/helpers/user_helpers.dart';
import 'package:fitness/widgets/scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:provider/provider.dart';

import '../../../controllers/users_controller.dart';
import '../../../database/firebase.dart';
import '../../../services/navigation_service.dart';
import '../../../widgets/text_field_widget.dart';
import '../../user_information/components/widgets/title_text_field_row_widget.dart';
import '../home/home_view.dart';
import 'components/widgets/goal_selectable_widget.dart';
import 'components/widgets/meal_slider_widget.dart';
import 'components/widgets/profile_custom_theme.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController morningWeightTextEditingController =
      TextEditingController();
  double weightGoal = 0.0;
  double mealsPerDay = 0.0;
  final TextEditingController breakfastTextEditingController =
      TextEditingController();
  final TextEditingController lunchTextEditingController =
      TextEditingController();
  final TextEditingController dinnerTextEditingController =
      TextEditingController();
  final TextEditingController snackTextEditingController =
      TextEditingController();
  final TextEditingController snack2extEditingController =
      TextEditingController();
  final TextEditingController amountTextEditingController =
      TextEditingController();
  final TextEditingController allergy1TextEditingController =
      TextEditingController();
  final TextEditingController allergy2TextEditingController =
      TextEditingController();
  final TextEditingController allergy3TextEditingController =
      TextEditingController();

  final AsyncMemoizer _memoizer = AsyncMemoizer();
  final AsyncMemoizer _memoizerSet = AsyncMemoizer();

  _getFutureFirebase() {
    return _memoizer.runOnce(() async {
      return FirebaseEndPoints.userCollection
          .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
          .get();
    });
  }

  Future<void> newMethod(
      BuildContext context, DocumentSnapshot<Object?> futureDocs) {
    return Future.delayed(
      Duration.zero,
      () {
        _memoizerSet.runOnce(() async {
          context.read<UsersController>().mealsPerDay =
              double.parse(futureDocs['mealsPerDay']);
          context.read<UsersController>().weightGoal =
              double.parse(futureDocs['weightGoal']);
          morningWeightTextEditingController.text = futureDocs['morningWeight'];
          breakfastTextEditingController.text = futureDocs['breakfast'];

          lunchTextEditingController.text = futureDocs['lunch'];

          dinnerTextEditingController.text = futureDocs['dinner'];

          snackTextEditingController.text = futureDocs['snack'];

          snack2extEditingController.text = futureDocs['snack2'];

          amountTextEditingController.text = futureDocs['amount'];

          allergy1TextEditingController.text = futureDocs['allergy1'];

          allergy2TextEditingController.text = futureDocs['allergy2'];

          allergy3TextEditingController.text = futureDocs['allergy3'];
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        NavigationService().pushAndRemoveUntil(HomeView());
        return true;
      },
      child: ScaffoldWidget(
        useCustomPadding: true,
        useSingleChildScrollView: true,
        child: FutureBuilder(
            future: _getFutureFirebase(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  children: [
                    SizedBox(
                      height: context.height * 0.5,
                    ),
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              } else if (snapshot.hasError) {
                if (snapshot.error is SocketException) {
                  return const Text('No internet connection.');
                } else {
                  return Text('An error occurred: ${snapshot.error}');
                }
              } else if (snapshot.hasData) {
                final futureDocs = snapshot.data as DocumentSnapshot;
                newMethod(context, futureDocs);
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: context.height * 0.08,
                      ),
                      Text(
                        'User',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 20,
                            ),
                      ),
                      SizedBox(
                        height: context.height * 0.074,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: ColoredBox(
                          color: Colors.white,
                          child: ProfileCustomTheme(
                            child: ExpansionTile(
                              tilePadding: EdgeInsets.only(
                                left: context.width * 0.024,
                                right: context.width * 0.04,
                              ),
                              childrenPadding: EdgeInsets.only(
                                left: context.width * 0.024,
                                right: context.width * 0.04,
                              ),
                              iconColor: Colors.black,
                              collapsedIconColor: Colors.black,
                              title: Text(
                                'Number of meals',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontSize: 20,
                                    ),
                              ),
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.start,
                              expandedAlignment: Alignment.topLeft,
                              children: [
                                MealSliderWidget(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: ColoredBox(
                          color: Colors.white,
                          child: ProfileCustomTheme(
                            child: ExpansionTile(
                              tilePadding: EdgeInsets.only(
                                left: context.width * 0.024,
                                right: context.width * 0.04,
                              ),
                              iconColor: Colors.black,
                              collapsedIconColor: Colors.black,
                              childrenPadding: EdgeInsets.only(
                                left: context.width * 0.11,
                                right: context.width * 0.14,
                              ),
                              title: Text(
                                'Prepare time',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontSize: 20,
                                    ),
                              ),
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.start,
                              expandedAlignment: Alignment.topLeft,
                              children: [
                                TitleTextFieldRowWidget(
                                  initialValue: futureDocs['breakfast'],
                                  title: 'breakfast',
                                  hintText: '20 min',
                                  textInputType: TextInputType.number,
                                  onSaved: (value) {
                                    breakfastTextEditingController.text =
                                        value!;
                                  },
                                ),
                                SizedBox(
                                  height: context.height * 0.01,
                                ),
                                TitleTextFieldRowWidget(
                                  title: 'lunch',
                                  hintText: '20 min',
                                  textInputType: TextInputType.number,
                                  initialValue: futureDocs['lunch'],
                                  onSaved: (value) {
                                    lunchTextEditingController.text = value!;
                                  },
                                ),
                                SizedBox(
                                  height: context.height * 0.01,
                                ),
                                TitleTextFieldRowWidget(
                                  title: 'dinner',
                                  hintText: '20 min',
                                  textInputType: TextInputType.number,
                                  initialValue: futureDocs['dinner'],
                                  onSaved: (value) {
                                    dinnerTextEditingController.text = value!;
                                  },
                                ),
                                SizedBox(
                                  height: context.height * 0.01,
                                ),
                                TitleTextFieldRowWidget(
                                  title: 'snack',
                                  hintText: '20 min',
                                  textInputType: TextInputType.number,
                                  initialValue: futureDocs['snack'],
                                  onSaved: (value) {
                                    snackTextEditingController.text = value!;
                                  },
                                ),
                                SizedBox(
                                  height: context.height * 0.01,
                                ),
                                TitleTextFieldRowWidget(
                                  title: 'snack2',
                                  hintText: '20 min',
                                  textInputType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  initialValue: futureDocs['snack2'],
                                  onSaved: (value) {
                                    snack2extEditingController.text = value!;
                                  },
                                ),
                                SizedBox(
                                  height: context.height * 0.02,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: ColoredBox(
                          color: Colors.white,
                          child: ProfileCustomTheme(
                            child: ExpansionTile(
                              tilePadding: EdgeInsets.only(
                                left: context.width * 0.024,
                                right: context.width * 0.04,
                              ),
                              childrenPadding: EdgeInsets.only(
                                left: context.width * 0.024,
                                right: context.width * 0.04,
                              ),
                              iconColor: Colors.black,
                              collapsedIconColor: Colors.black,
                              title: Text(
                                'Daily budget',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontSize: 20,
                                    ),
                              ),
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.center,
                              expandedAlignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: context.width * 0.5,
                                  child: TextFormFieldWidget(
                                    hintText: '10 Euro',
                                    textAlign: TextAlign.center,
                                    textInputType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                    initialValue: futureDocs['amount'],
                                    onSaved: (value) {
                                      amountTextEditingController.text = value!;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: context.height * 0.02,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: ColoredBox(
                          color: Colors.white,
                          child: ProfileCustomTheme(
                            child: ExpansionTile(
                              tilePadding: EdgeInsets.only(
                                left: context.width * 0.024,
                                right: context.width * 0.04,
                              ),
                              iconColor: Colors.black,
                              collapsedIconColor: Colors.black,
                              childrenPadding: EdgeInsets.only(
                                left: context.width * 0.024,
                                right: context.width * 0.04,
                              ),
                              title: Text(
                                'Weight',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontSize: 20,
                                    ),
                              ),
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.center,
                              expandedAlignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: context.width * 0.5,
                                  child: TextFormFieldWidget(
                                    hintText: '90 Kg',
                                    textAlign: TextAlign.center,
                                    textInputType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                    readOnly: futureDocs['weightCount'] == 1
                                        ? true
                                        : false,
                                    initialValue: futureDocs['morningWeight'],
                                    onSaved: (value) {
                                      morningWeightTextEditingController.text =
                                          value!;
                                    },
                                  ),
                                ),
                                if (futureDocs['weightCount'] == 1)
                                  SizedBox(
                                    height: context.height * 0.01,
                                  ),
                                if (futureDocs['weightCount'] == 1)
                                  Text(
                                    'You can update your weight next week',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          fontSize: 9,
                                        ),
                                  ),
                                SizedBox(
                                  height: context.height * 0.02,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: ColoredBox(
                          color: Colors.white,
                          child: ProfileCustomTheme(
                            child: ExpansionTile(
                              tilePadding: EdgeInsets.only(
                                left: context.width * 0.024,
                                right: context.width * 0.04,
                              ),
                              iconColor: Colors.black,
                              collapsedIconColor: Colors.black,
                              childrenPadding: EdgeInsets.only(
                                left: context.width * 0.024,
                                right: context.width * 0.04,
                              ),
                              title: Text(
                                'Goal',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontSize: 20,
                                    ),
                              ),
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.center,
                              expandedAlignment: Alignment.center,
                              children: [
                                GoalSelectableWidget(
                                  title: 'Extreme weight gain',
                                  onTap: () {
                                    context.read<UsersController>().weightGoal =
                                        0.0;
                                  },
                                  backgroundColor: context
                                              .watch<UsersController>()
                                              .weightGoal ==
                                          0.0
                                      ? const Color(0xffDEE7E8)
                                      : Color.fromARGB(255, 240, 243, 243),
                                ),
                                SizedBox(
                                  height: context.height * 0.01,
                                ),
                                GoalSelectableWidget(
                                  title: 'Weight gain',
                                  backgroundColor: context
                                              .watch<UsersController>()
                                              .weightGoal ==
                                          0.25
                                      ? const Color(0xffDEE7E8)
                                      : Color.fromARGB(255, 240, 243, 243),
                                  onTap: () {
                                    context.read<UsersController>().weightGoal =
                                        0.25;
                                  },
                                ),
                                SizedBox(
                                  height: context.height * 0.01,
                                ),
                                GoalSelectableWidget(
                                  title: 'Maintenance',
                                  backgroundColor: context
                                              .watch<UsersController>()
                                              .weightGoal ==
                                          0.5
                                      ? const Color(0xffDEE7E8)
                                      : Color.fromARGB(255, 240, 243, 243),
                                  onTap: () {
                                    context.read<UsersController>().weightGoal =
                                        0.5;
                                  },
                                ),
                                SizedBox(
                                  height: context.height * 0.01,
                                ),
                                GoalSelectableWidget(
                                  title: 'Weight loss',
                                  backgroundColor: context
                                              .watch<UsersController>()
                                              .weightGoal ==
                                          0.75
                                      ? const Color(0xffDEE7E8)
                                      : Color.fromARGB(255, 240, 243, 243),
                                  onTap: () {
                                    context.read<UsersController>().weightGoal =
                                        0.75;
                                  },
                                ),
                                SizedBox(
                                  height: context.height * 0.01,
                                ),
                                GoalSelectableWidget(
                                  title: 'Extreme weight loss',
                                  backgroundColor: context
                                              .watch<UsersController>()
                                              .weightGoal ==
                                          1.0
                                      ? const Color(0xffDEE7E8)
                                      : Color.fromARGB(255, 240, 243, 243),
                                  onTap: () {
                                    context.read<UsersController>().weightGoal =
                                        1.0;
                                  },
                                ),
                                SizedBox(
                                  height: context.height * 0.02,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: ColoredBox(
                          color: Colors.white,
                          child: ProfileCustomTheme(
                            child: ExpansionTile(
                              tilePadding: EdgeInsets.only(
                                left: context.width * 0.024,
                                right: context.width * 0.04,
                              ),
                              iconColor: Colors.black,
                              collapsedIconColor: Colors.black,
                              childrenPadding: EdgeInsets.only(
                                left: context.width * 0.024,
                                right: context.width * 0.04,
                              ),
                              title: Text(
                                'Allergens',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontSize: 20,
                                    ),
                              ),
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.center,
                              expandedAlignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: context.width * 0.5,
                                  child: TextFormFieldWidget(
                                    hintText: '',
                                    textAlign: TextAlign.center,
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                    initialValue: futureDocs['allergy1'],
                                    onSaved: (value) {
                                      allergy1TextEditingController.text =
                                          value!;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: context.height * 0.01,
                                ),
                                SizedBox(
                                  width: context.width * 0.5,
                                  child: TextFormFieldWidget(
                                    hintText: '',
                                    textAlign: TextAlign.center,
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                    initialValue: futureDocs['allergy2'],
                                    onSaved: (value) {
                                      allergy2TextEditingController.text =
                                          value!;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: context.height * 0.01,
                                ),
                                SizedBox(
                                  width: context.width * 0.5,
                                  child: TextFormFieldWidget(
                                    hintText: '',
                                    textAlign: TextAlign.center,
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                    textInputAction: TextInputAction.done,
                                    initialValue: futureDocs['allergy3'],
                                    onSaved: (value) {
                                      allergy3TextEditingController.text =
                                          value!;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: context.height * 0.02,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _formKey.currentState?.save();

                          UserHelpers.updateUserInformation(
                            context: context,
                            morningWeightTextEditingController:
                                morningWeightTextEditingController,
                            oldMorningWeight: futureDocs['morningWeight'],
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
                          );
                        },
                        child: Text(
                          'Update',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                    ],
                  ),
                );
              } else {
                return const Text('No data available.');
              }
            }),
      ),
    );
  }
}
