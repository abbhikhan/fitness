import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/extensions/shared_extensions.dart';
import 'package:fitness/widgets/scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/app_images.dart';
import '../../../database/firebase.dart';
import '../plans/components/widgets/progress_bar.dart';

class NutritionPlanView extends StatefulWidget {
  const NutritionPlanView({
    super.key,
    required this.currentDay,
  });

  final String currentDay;

  @override
  State<NutritionPlanView> createState() => _NutritionPlanViewState();
}

class _NutritionPlanViewState extends State<NutritionPlanView> {
  late String currentDayName;

  @override
  initState() {
    super.initState();
    DateTime now = DateTime.now();
    currentDayName = DateFormat('EEEE').format(now);
  }

  @override
  Widget build(BuildContext context) {
    print(currentDayName);
    return ScaffoldWidget(
        child: Column(
      children: [
        SizedBox(
          height: context.height * 0.04,
        ),
        Text(
          'Nutrition Overview',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 28,
              ),
        ),
        SizedBox(
          height: context.height * 0.097,
        ),
        FutureBuilder(
            future: FirebaseEndPoints.userCollection
                .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
                .get(),
            builder: (context, userInfoSnapShot) {
              if (userInfoSnapShot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              } else if (userInfoSnapShot.hasError) {
                if (userInfoSnapShot.error is SocketException) {
                  return const Text('No internet connection.');
                } else {
                  return Text('An error occurred: ${userInfoSnapShot.error}');
                }
              } else if (userInfoSnapShot.hasData) {
                final futureDocs = userInfoSnapShot.data as DocumentSnapshot;
                double totalCalories = 0;
                if (futureDocs['weightGoal'] == '0.0') {
                  totalCalories =
                      double.parse(futureDocs['morningWeight']) * 44.0;
                }
                if (futureDocs['weightGoal'] == '0.25') {
                  totalCalories =
                      double.parse(futureDocs['morningWeight']) * 38.0;
                }
                if (futureDocs['weightGoal'] == '0.5') {
                  totalCalories =
                      double.parse(futureDocs['morningWeight']) * 32.0;
                }
                if (futureDocs['weightGoal'] == '0.75') {
                  totalCalories =
                      double.parse(futureDocs['morningWeight']) * 26.0;
                }
                if (futureDocs['weightGoal'] == '1.0') {
                  totalCalories =
                      double.parse(futureDocs['morningWeight']) * 21.0;
                }
                final nowCalories =
                    totalCalories / double.parse(futureDocs['mealsPerDay']);

                return FutureBuilder(
                    future: FirebaseEndPoints.userCollection
                        .doc(FirebaseAccess
                            .firebaseAuthInstance.currentUser?.uid)
                        .collection(
                            FirebaseCollectionNames.userReceipeCollection)
                        .get(),
                    builder: (context, snapshot1) {
                      if (snapshot1.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot1.hasError) {
                        if (snapshot1.error is SocketException) {
                          return const Text('No internet connection.');
                        } else {
                          return Text('An error occurred: ${snapshot1.error}');
                        }
                      } else if (snapshot1.hasData) {
                        if (snapshot1.data?.size != 0) {
                          return FutureBuilder(
                              future: FirebaseEndPoints.adminReceipeCollection
                                  .get(),
                              builder: (context, adminReceipeSnapshot) {
                                if (adminReceipeSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (adminReceipeSnapshot.hasError) {
                                  if (adminReceipeSnapshot.error
                                      is SocketException) {
                                    return const Text(
                                        'No internet connection.');
                                  } else {
                                    return Text(
                                        'An error occurred: ${adminReceipeSnapshot.error}');
                                  }
                                } else if (adminReceipeSnapshot.hasData) {
                                  double price = 0;
                                  double calorie = 0;
                                  double protien = 0;
                                  double carbs = 0;
                                  double fats = 0;

                                  if (adminReceipeSnapshot.data?.size != 0) {
                                    snapshot1.data?.docs.forEach((userReceipe) {
                                      adminReceipeSnapshot.data?.docs
                                          .forEach((adminRec) {
                                        if (userReceipe.get('receipeId') ==
                                            adminRec.id) {
                                          if (userReceipe
                                              .get('weekdays')
                                              .asMap()
                                              .isNotEmpty) {
                                            if (userReceipe
                                                .get('weekdays')
                                                .asMap()
                                                .values
                                                .contains(widget.currentDay)) {
                                              price = price +
                                                  double.parse(
                                                      adminRec.get('price'));
                                              calorie = calorie +
                                                  double.parse(
                                                      adminRec.get('calories'));
                                              protien = protien +
                                                  double.parse(
                                                      adminRec.get('protiens'));
                                              carbs = carbs +
                                                  double.parse(
                                                      adminRec.get('carbs'));
                                              fats = fats +
                                                  double.parse(
                                                      adminRec.get('fats'));
                                            } else {
                                              print('else');
                                            }
                                          }
                                        }
                                      });
                                    });
                                    final maxProtien = (double.parse(
                                            futureDocs['morningWeight']) *
                                        2.4);
                                    final minProtien = (double.parse(
                                            futureDocs['morningWeight']) *
                                        1.8);

                                    final maxProtienC = maxProtien * 4;
                                    final minProtienC = minProtien * 4;

                                    final maxCarbsC = (nowCalories / 100) * 65;
                                    final minCarbsC = (nowCalories / 100) * 45;

                                    final maxCarbs = maxCarbsC / 4;
                                    final minCarbs = minCarbsC / 4;

                                    final maxFatsC = (nowCalories / 100) * 35;
                                    final minFatsC = (nowCalories / 100) * 20;

                                    final maxFats = maxFatsC / 9;
                                    final minFats = minFatsC / 9;
                                    print(maxFats - minFats);
                                    return Column(
                                      children: [
                                        //Protein Row
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Protein',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                        fontSize: 24,
                                                        color: (protien >=
                                                                        minProtien &&
                                                                    calorie <=
                                                                        maxProtien) ==
                                                                true
                                                            ? Colors.purple
                                                            : Colors.red,
                                                      ),
                                                ),
                                                Text(
                                                  '${protien.toStringAsFixed(0)}g',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        fontSize: 16,
                                                        color: (protien >=
                                                                        minProtien &&
                                                                    calorie <=
                                                                        maxProtien) ==
                                                                true
                                                            ? Colors.purple
                                                            : Colors.red,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: context.width * 0.1,
                                            ),
                                            // Column(
                                            //   mainAxisAlignment: MainAxisAlignment.end,
                                            //   crossAxisAlignment: CrossAxisAlignment.end,
                                            //   children: [
                                            //     Row(
                                            //       mainAxisAlignment:
                                            //           MainAxisAlignment.spaceEvenly,
                                            //       children: [
                                            //         Text(
                                            //           '${minCarbs.toStringAsFixed(0)}g',
                                            //           style: Theme.of(context)
                                            //               .textTheme
                                            //               .bodyLarge!
                                            //               .copyWith(
                                            //                 fontSize: 16,
                                            //               ),
                                            //         ),
                                            //         Text(
                                            //           '${maxCarbs.toStringAsFixed(0)}g',
                                            //           style: Theme.of(context)
                                            //               .textTheme
                                            //               .bodyLarge!
                                            //               .copyWith(
                                            //                 fontSize: 16,
                                            //               ),
                                            //         ),
                                            //       ],
                                            //     ),
                                            //     SizedBox(
                                            //       width: context.width * 0.5,
                                            //       child: ProgressBar(
                                            //         barHeight: context.height * 0.015,
                                            //         color: (minCarbsC >= calorie &&
                                            //                     maxCarbsC <= calorie) ==
                                            //                 true
                                            //             ? Colors.green
                                            //             : Color.fromRGBO(69, 173, 69, 1),
                                            //         backgroundColor:
                                            //             Color.fromRGBO(243, 147, 147, 1),
                                            //         maxValue: 400,
                                            //         value: carbs,
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),

                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: context.height * 0.06,
                                                  width: context.width * 0.5,
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        bottom: context.height *
                                                            0.015,
                                                        child: SizedBox(
                                                          width: context.width *
                                                              0.5,
                                                          child: ProgressBar(
                                                            barHeight:
                                                                context.height *
                                                                    0.015,
                                                            color: (protien >=
                                                                            minProtien &&
                                                                        calorie <=
                                                                            maxProtien) ==
                                                                    true
                                                                ? Colors.purple
                                                                : Colors.red,
                                                            backgroundColor:
                                                                const Color
                                                                        .fromRGBO(
                                                                    243,
                                                                    147,
                                                                    147,
                                                                    1),
                                                            maxValue:
                                                                maxProtien,
                                                            value: protien,
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: context.height *
                                                            0.015,
                                                        left: 0,
                                                        width:
                                                            context.width * 0.5,
                                                        // right: 0,
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                                flex: minProtien
                                                                    .toInt(),
                                                                child:
                                                                    Container(
                                                                  height: 10,
                                                                  // color: Colors.green,
                                                                )),
                                                            Flexible(
                                                              flex: (maxProtien -
                                                                      minProtien)
                                                                  .toInt(),
                                                              child: Container(
                                                                // width: context.width *
                                                                //     0.25,
                                                                height: context
                                                                        .height *
                                                                    0.015,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: const Color
                                                                        .fromRGBO(
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      1,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            // Flexible(
                                                            //     flex: 30,
                                                            //     child:
                                                            //         Container(
                                                            //       height: 10,
                                                            //       // color: Colors.green,
                                                            //     )),
                                                          ],
                                                        ),
                                                      ),
                                                      Positioned(
                                                        // bottom: context.height *
                                                        //     0.015,
                                                        // left: minCarbs,
                                                        width:
                                                            context.width * 0.5,
                                                        right: 0,
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                                flex: minProtien
                                                                        .round() -
                                                                    (minProtien <
                                                                                5
                                                                            ? 2
                                                                            : minProtien /
                                                                                4)
                                                                        .round(),
                                                                child:
                                                                    Container(
                                                                  height: 10,
                                                                  // color: Colors.green,
                                                                )),
                                                            Flexible(
                                                                flex: (maxProtien -
                                                                        minProtien)
                                                                    .round(),
                                                                child: Text(
                                                                  '${minProtien.toStringAsFixed(0)}g',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall!
                                                                      .copyWith(
                                                                        fontSize:
                                                                            10,
                                                                      ),
                                                                )) // Flexible(
                                                            //     flex: 28,
                                                            //     child:
                                                            //         Container(
                                                            //       height: 10,
                                                            //       // color: Colors.green,
                                                            //     )),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: context.height * 0.03,
                                                ),
                                                // Text(
                                                //   'get into range',
                                                //   style: Theme.of(context)
                                                //       .textTheme
                                                //       .bodySmall!
                                                //       .copyWith(
                                                //         fontSize: 14,
                                                //       ),
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: context.height * 0.046,
                                        ),
                                        //Carbs Row
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Carbs',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                        fontSize: 24,
                                                        color: (calorie >=
                                                                        minCarbsC &&
                                                                    calorie <=
                                                                        maxCarbsC) ==
                                                                true
                                                            ? Colors.purple
                                                            : Colors.red,
                                                      ),
                                                ),
                                                Text(
                                                  '${carbs.toStringAsFixed(0)}g',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        fontSize: 16,
                                                        color: (calorie >=
                                                                        minCarbsC &&
                                                                    calorie <=
                                                                        maxCarbsC) ==
                                                                true
                                                            ? Colors.purple
                                                            : Colors.red,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: context.width * 0.16,
                                            ),
                                            // Column(
                                            //   mainAxisAlignment: MainAxisAlignment.end,
                                            //   crossAxisAlignment: CrossAxisAlignment.end,
                                            //   children: [
                                            //     Row(
                                            //       mainAxisAlignment:
                                            //           MainAxisAlignment.spaceEvenly,
                                            //       children: [
                                            //         Text(
                                            //           '${minCarbs.toStringAsFixed(0)}g',
                                            //           style: Theme.of(context)
                                            //               .textTheme
                                            //               .bodyLarge!
                                            //               .copyWith(
                                            //                 fontSize: 16,
                                            //               ),
                                            //         ),
                                            //         Text(
                                            //           '${maxCarbs.toStringAsFixed(0)}g',
                                            //           style: Theme.of(context)
                                            //               .textTheme
                                            //               .bodyLarge!
                                            //               .copyWith(
                                            //                 fontSize: 16,
                                            //               ),
                                            //         ),
                                            //       ],
                                            //     ),
                                            //     SizedBox(
                                            //       width: context.width * 0.5,
                                            //       child: ProgressBar(
                                            //         barHeight: context.height * 0.015,
                                            //         color: (minCarbsC >= calorie &&
                                            //                     maxCarbsC <= calorie) ==
                                            //                 true
                                            //             ? Colors.green
                                            //             : Color.fromRGBO(69, 173, 69, 1),
                                            //         backgroundColor:
                                            //             Color.fromRGBO(243, 147, 147, 1),
                                            //         maxValue: 400,
                                            //         value: carbs,
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),

                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: context.height * 0.06,
                                                  width: context.width * 0.5,
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        bottom: context.height *
                                                            0.015,
                                                        child: SizedBox(
                                                          width: context.width *
                                                              0.5,
                                                          child: ProgressBar(
                                                            barHeight:
                                                                context.height *
                                                                    0.015,
                                                            color: (carbs >=
                                                                            minCarbs &&
                                                                        carbs <=
                                                                            maxCarbs) ==
                                                                    true
                                                                ? Colors.purple
                                                                : Colors.red,
                                                            backgroundColor:
                                                                const Color
                                                                        .fromRGBO(
                                                                    243,
                                                                    147,
                                                                    147,
                                                                    1),
                                                            maxValue: maxCarbs +
                                                                (minCarbs < 30
                                                                    ? minCarbs
                                                                    : 30),
                                                            value: carbs,
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: context.height *
                                                            0.015,
                                                        left: 0,
                                                        width:
                                                            context.width * 0.5,
                                                        // right: 0,
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                                flex: minCarbs
                                                                    .round(),
                                                                child:
                                                                    Container(
                                                                  height: 10,
                                                                  // color: Colors.green,
                                                                )),
                                                            Flexible(
                                                              flex: (maxCarbs -
                                                                      minCarbs)
                                                                  .round(),
                                                              child: Container(
                                                                // width: context.width *
                                                                //     0.25,
                                                                height: context
                                                                        .height *
                                                                    0.015,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: const Color
                                                                        .fromRGBO(
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      1,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Flexible(
                                                                flex: (minCarbs <
                                                                            30
                                                                        ? minCarbs
                                                                        : 30)
                                                                    .round(),
                                                                child:
                                                                    Container(
                                                                  height: 10,
                                                                  // color: Colors.green,
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      // Align(
                                                      //   alignment: Alignment.bottomCenter,
                                                      //   child: Row(
                                                      //     mainAxisAlignment:
                                                      //         MainAxisAlignment
                                                      //             .spaceAround,
                                                      //     children: [
                                                      //       Container(
                                                      //         width:
                                                      //             context.width * 0.003,
                                                      //         height:
                                                      //             context.height * 0.023,
                                                      //         color: Color.fromRGBO(
                                                      //             0, 0, 0, 1),
                                                      //       ),
                                                      //       Container(
                                                      //         width:
                                                      //             context.width * 0.003,
                                                      //         height:
                                                      //             context.height * 0.023,
                                                      //         color: Color.fromRGBO(
                                                      //             0, 0, 0, 1),
                                                      //       ),
                                                      //     ],
                                                      //   ),
                                                      // ),
                                                      Positioned(
                                                        // bottom: context.height *
                                                        //     0.015,
                                                        // left: minCarbs,
                                                        width:
                                                            context.width * 0.5,
                                                        right: 0,
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                                flex: (minCarbs -
                                                                        (minCarbs <
                                                                                5
                                                                            ? 2
                                                                            : minCarbs /
                                                                                4))
                                                                    .round(),
                                                                child:
                                                                    Container(
                                                                  height: 10,
                                                                  // color: Colors.green,
                                                                )),
                                                            Flexible(
                                                                flex: ((maxCarbs -
                                                                            minCarbs) +
                                                                        (minCarbs <
                                                                                5
                                                                            ? 2
                                                                            : minCarbs /
                                                                                4))
                                                                    .round(),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      '${minCarbs.toStringAsFixed(0)}g',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodySmall!
                                                                          .copyWith(
                                                                            fontSize:
                                                                                10,
                                                                          ),
                                                                    ),
                                                                    Text(
                                                                      '${maxCarbs.toStringAsFixed(0)}g',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodySmall!
                                                                          .copyWith(
                                                                            fontSize:
                                                                                10,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                )),
                                                            Flexible(
                                                                flex: ((minCarbs <
                                                                                30
                                                                            ? minCarbs
                                                                            : 30) -
                                                                        (minCarbs <
                                                                                5
                                                                            ? 2
                                                                            : minCarbs /
                                                                                4))
                                                                    .round(),
                                                                child:
                                                                    Container(
                                                                  height: 10,
                                                                  // color: Colors.green,
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: context.height * 0.03,
                                                ),
                                                // Text(
                                                //   'get into range',
                                                //   style: Theme.of(context)
                                                //       .textTheme
                                                //       .bodySmall!
                                                //       .copyWith(
                                                //         fontSize: 14,
                                                //       ),
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: context.height * 0.046,
                                        ),
                                        //Fats Row
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Fat',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                        fontSize: 24,
                                                        color: (calorie >=
                                                                        minFats &&
                                                                    calorie <=
                                                                        maxFats) ==
                                                                true
                                                            ? Colors.yellow
                                                            : Colors.red,
                                                      ),
                                                ),
                                                Text(
                                                  '${fats.toStringAsFixed(0)}g',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        fontSize: 16,
                                                        color: (calorie >=
                                                                        minFats &&
                                                                    calorie <=
                                                                        maxFats) ==
                                                                true
                                                            ? Colors.yellow
                                                            : Colors.red,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: context.width * 0.26,
                                            ),
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: context.height * 0.06,
                                                  width: context.width * 0.5,
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        bottom: context.height *
                                                            0.015,
                                                        child: SizedBox(
                                                          width: context.width *
                                                              0.5,
                                                          child: ProgressBar(
                                                            barHeight:
                                                                context.height *
                                                                    0.015,
                                                            color: (fats >= minFats &&
                                                                        fats <=
                                                                            maxFats) ==
                                                                    true
                                                                ? Colors.yellow
                                                                : Colors.red,
                                                            maxValue: maxFats +
                                                                (minFats < 30
                                                                    ? minFats
                                                                    : 30),
                                                            value: fats,
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: context.height *
                                                            0.015,
                                                        left: 0,
                                                        width:
                                                            context.width * 0.5,
                                                        // right: 0,
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                                flex: minFats
                                                                    .round(),
                                                                child:
                                                                    Container(
                                                                  height: 10,
                                                                  // color: Colors.cyan,
                                                                )),
                                                            Flexible(
                                                              flex: (maxFats -
                                                                      minFats)
                                                                  .round(),
                                                              child: Container(
                                                                // width: context.width *
                                                                //     0.25,
                                                                height: context
                                                                        .height *
                                                                    0.015,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: const Color
                                                                        .fromRGBO(
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      1,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Flexible(
                                                                flex: (minFats <
                                                                            30
                                                                        ? minFats
                                                                        : 30)
                                                                    .round(),
                                                                child:
                                                                    Container(
                                                                  height: 10,
                                                                  // color: Colors.yellow,
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      Positioned(
                                                        // bottom: context.height *
                                                        //     0.015,
                                                        // left: minCarbs,
                                                        width:
                                                            context.width * 0.5,
                                                        left: 0,
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                                flex: minFats
                                                                    .round(),
                                                                child:
                                                                    Container(
                                                                  height: 10,
                                                                  // color: Colors.green,
                                                                )),
                                                            Flexible(
                                                                flex: (maxFats -
                                                                        minFats)
                                                                    .round(),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      '${minFats.toStringAsFixed(0)}g',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodySmall!
                                                                          .copyWith(
                                                                            fontSize:
                                                                                10,
                                                                          ),
                                                                    ),
                                                                    Text(
                                                                      '${maxFats.toStringAsFixed(0)}g',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodySmall!
                                                                          .copyWith(
                                                                            fontSize:
                                                                                10,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                )),
                                                            Flexible(
                                                                flex: (minFats <
                                                                            30
                                                                        ? minFats
                                                                        : 30)
                                                                    .round(),
                                                                child:
                                                                    Container(
                                                                  height: 10,
                                                                  // color: Colors.yellow,
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: context.height * 0.03,
                                                ),
                                                // Text(
                                                //   'get into range',
                                                //   style: Theme.of(context)
                                                //       .textTheme
                                                //       .bodySmall!
                                                //       .copyWith(
                                                //         fontSize: 14,
                                                //       ),
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: context.height * 0.1,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            border: Border.all(
                                              color: const Color.fromRGBO(
                                                  0, 0, 0, 1),
                                              width: 2,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  context.height * 0.051,
                                              vertical: context.width * 0.035,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Image.asset(
                                                      AppImages.pricee,
                                                    ),
                                                    Text(
                                                      '$price',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                            fontSize: 24,
                                                          ),
                                                    ),
                                                    Text(
                                                      '€',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displayMedium!
                                                          .copyWith(
                                                            fontSize: 24,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Image.asset(
                                                      AppImages.calori,
                                                    ),
                                                    Text(
                                                      '$calorie',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                            fontSize: 24,
                                                          ),
                                                    ),
                                                    Text(
                                                      'Kcal',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displayMedium!
                                                          .copyWith(
                                                            fontSize: 24,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return const Text('No data available.');
                                  }
                                } else {
                                  return const Text('No data available.');
                                }
                              });
                        } else {
                          return const SizedBox();
                        }
                      } else {
                        return const Text('No data available.');
                      }
                    });
              } else {
                return const Text('No data available.');
              }
            }),
      ],
    ));
  }
}
