import 'dart:io';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/constants/app_images.dart';
import 'package:fitness/extensions/shared_extensions.dart';
import 'package:fitness/helpers/user_helpers.dart';
import 'package:fitness/views/user/plans/components/widgets/progress_bar.dart';
import 'package:fitness/widgets/scaffold_widget.dart';
import 'package:flutter/material.dart';

import '../../../database/firebase.dart';

final weeksList = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

class PlansDetailView extends StatefulWidget {
  const PlansDetailView({
    super.key,
    required this.id,
    // required this.planName,
    // required this.imageUrl,
    // required this.receipeName,
    // required this.protiens,
    // required this.carbs,
    // required this.fats,
    // required this.weekdays,
    // required this.instrunctions,
    // required this.ingredients,
    // required this.calories,
    // required this.time,
    // required this.price,
  });

  final String id;
  // final String planName;
  // final String imageUrl;
  // final String receipeName;
  // final String protiens;
  // final String carbs;
  // final String fats;
  // final List<String> weekdays;
  // final String instrunctions;
  // final String ingredients;
  // final String calories;
  // final String time;
  // final String price;

  @override
  State<PlansDetailView> createState() => _PlansDetailViewState();
}

class _PlansDetailViewState extends State<PlansDetailView> {
  @override
  Widget build(BuildContext context) {
    print(widget.id);
    return ScaffoldWidget(
      edgeInsets: EdgeInsets.zero,
      useSingleChildScrollView: true,
      child: FutureBuilder(
          future: FirebaseEndPoints.userCollection
              .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
              .collection(FirebaseCollectionNames.userReceipeCollection)
              .where('receipeId', isEqualTo: widget.id)
              .get(),
          builder: (context, snapshot1) {
            if (snapshot1.connectionState == ConnectionState.waiting) {
              return SizedBox.shrink();
            } else if (snapshot1.hasError) {
              if (snapshot1.error is SocketException) {
                return const Text('No internet connection.');
              } else {
                return Text('An error occurred: ${snapshot1.error}');
              }
            } else if (snapshot1.hasData) {
              // final firebaseWeekDays = [];
              // if (snapshot1.data?.size != 0) {
              //   firebaseWeekDays.add(snapshot1.data?.docs.first['weekdays']);
              // }
              // firebaseWeekDays.forEach((element) {
              //   print(element);
              // });
              return FutureBuilder(
                  future: FirebaseEndPoints.adminReceipeCollection
                      .doc(widget.id)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        children: [
                          SizedBox(
                            height: context.height * 0.5,
                          ),
                          Center(
                              child: CircularProgressIndicator(
                            backgroundColor: Colors.transparent,
                          )),
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
                      final someTotal = double.parse(futureDocs['protiens']) +
                          double.parse(futureDocs['fats']) +
                          double.parse(futureDocs['carbs']);
                      return Column(
                        children: [
                          Image.network(
                            futureDocs['imageUrl'],
                            height: context.height * 0.4,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.width * 0.06,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: context.height * 0.02,
                                ),
                                Text(
                                  futureDocs['halfDay'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontSize: 20,
                                      ),
                                ),
                                Text(
                                  futureDocs['name'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                ),
                                SizedBox(
                                  height: context.height * 0.041,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        // VeticleProgressBar(
                                        //   maxValue: 100,
                                        //   value: double.parse(protiens) * 100 / someTotal,
                                        //   color: Color.fromRGBO(69, 173, 69, 1),
                                        //   backgrounColor: Color.fromRGBO(222, 255, 231, 1),
                                        //   textColor: const Color.fromRGBO(79, 126, 92, 1),
                                        // ),
                                        VerticalProgressBarr(
                                          value: double.parse(
                                                  futureDocs['protiens']) *
                                              100 /
                                              someTotal,
                                          textColor:
                                              Color.fromRGBO(79, 126, 92, 1),
                                          color: Color.fromRGBO(69, 173, 69, 1),
                                          backgroundColor:
                                              Color.fromRGBO(222, 255, 231, 1),
                                        ),
                                        SizedBox(
                                          height: context.height * 0.006,
                                        ),
                                        Text(
                                          'Proteins',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium!
                                              .copyWith(
                                                fontSize: 16,
                                                color: const Color.fromRGBO(
                                                    120, 116, 116, 1),
                                              ),
                                        ),
                                        Text(
                                          '${futureDocs['protiens']}g',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                fontSize: 20,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        VerticalProgressBarr(
                                          value: double.parse(
                                                  futureDocs['carbs']) *
                                              100 /
                                              someTotal,
                                          color:
                                              Color.fromRGBO(153, 63, 162, 1),
                                          backgroundColor:
                                              Color.fromRGBO(251, 215, 255, 1),
                                          textColor:
                                              Color.fromRGBO(94, 40, 100, 1),
                                        ),
                                        SizedBox(
                                          height: context.height * 0.006,
                                        ),
                                        Text(
                                          'Carbs',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium!
                                              .copyWith(
                                                fontSize: 16,
                                                color: const Color.fromRGBO(
                                                    120, 116, 116, 1),
                                              ),
                                        ),
                                        Text(
                                          '${futureDocs['carbs']}g',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                fontSize: 20,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        VerticalProgressBarr(
                                          value:
                                              double.parse(futureDocs['fats']) *
                                                  100 /
                                                  someTotal,
                                          color: Color.fromRGBO(255, 195, 0, 1),
                                          backgroundColor:
                                              Color.fromRGBO(255, 245, 203, 1),
                                          textColor:
                                              Color.fromRGBO(185, 157, 47, 1),
                                        ),
                                        SizedBox(
                                          height: context.height * 0.006,
                                        ),
                                        Text(
                                          'Fats',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium!
                                              .copyWith(
                                                fontSize: 16,
                                                color: const Color.fromRGBO(
                                                    120, 116, 116, 1),
                                              ),
                                        ),
                                        Text(
                                          '${futureDocs['fats']}g',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                fontSize: 20,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: context.height * 0.03),
                                SizedBox(
                                  width: context.width * 0.99,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: ColoredBox(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: context.height * 0.022,
                                          vertical: context.width * 0.035,
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Weekly meal plan',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    fontSize: 20,
                                                  ),
                                            ),
                                            SizedBox(
                                                height: context.height * 0.011),
                                            SizedBox(
                                              height: context.height * 0.092,
                                              child: ListView.separated(
                                                shrinkWrap: true,
                                                padding: EdgeInsets.zero,
                                                itemCount: weeksList.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                separatorBuilder:
                                                    (context, index) =>
                                                        SizedBox(
                                                  width: context.width * 0.01,
                                                ),
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
// snapshot1
//                                                                             .data
//                                                                             ?.size !=
//                                                                         0
//                                                                     ? snapshot1
//                                                                             .data
//                                                                             ?.docs
//                                                                             .first[
//                                                                                 'weekdays']
//                                                                             .contains(weeksList[index]
//                                                                                 .toString())

                                                    onTap: snapshot1
                                                                .data?.size !=
                                                            0
                                                        ? snapshot1
                                                                .data
                                                                ?.docs
                                                                .first[
                                                                    'weekdays']
                                                                .contains(weeksList[
                                                                        index]
                                                                    .toString())
                                                            ? () async {}
                                                            : () async {
                                                                final res =
                                                                    await UserHelpers
                                                                        .updateReceipeWeekDays(
                                                                  context:
                                                                      context,
                                                                  weekDayName:
                                                                      weeksList[
                                                                          index],
                                                                  recepieId:
                                                                      widget.id,
                                                                  protien:
                                                                      futureDocs[
                                                                          'protiens'],
                                                                  carbs: futureDocs[
                                                                      'carbs'],
                                                                  fat: futureDocs[
                                                                      'fats'],
                                                                  amount:
                                                                      futureDocs[
                                                                          'price'],
                                                                  calorie:
                                                                      futureDocs[
                                                                          'calories'],
                                                                  halfDay:
                                                                      futureDocs[
                                                                          'halfDay'],
                                                                );
                                                                if (res) {
                                                                  setState(
                                                                      () {});
                                                                }
                                                              }
                                                        : () async {
                                                            final res =
                                                                await UserHelpers
                                                                    .updateReceipeWeekDays(
                                                              context: context,
                                                              weekDayName:
                                                                  weeksList[
                                                                      index],
                                                              recepieId:
                                                                  widget.id,
                                                              protien: futureDocs[
                                                                  'protiens'],
                                                              carbs: futureDocs[
                                                                  'carbs'],
                                                              fat: futureDocs[
                                                                  'fats'],
                                                              amount:
                                                                  futureDocs[
                                                                      'price'],
                                                              calorie: futureDocs[
                                                                  'calories'],
                                                              halfDay:
                                                                  futureDocs[
                                                                      'halfDay'],
                                                            );
                                                            if (res) {
                                                              setState(() {});
                                                            }
                                                          },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        20,
                                                      ),
                                                      child: Wrap(
                                                        direction:
                                                            Axis.vertical,
                                                        runAlignment:
                                                            WrapAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .center,
                                                        alignment: WrapAlignment
                                                            .center,
                                                        children: [
                                                          Container(
                                                            height: 35,
                                                            width: 35,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .black,
                                                                width: 3,
                                                              ),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            child: Container(
                                                              height: 20,
                                                              width: 20,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: snapshot1
                                                                            .data
                                                                            ?.size !=
                                                                        0
                                                                    ? snapshot1
                                                                            .data
                                                                            ?.docs
                                                                            .first[
                                                                                'weekdays']
                                                                            .contains(weeksList[index]
                                                                                .toString())
                                                                        ? Colors
                                                                            .black
                                                                        : Colors
                                                                            .white
                                                                    : Colors
                                                                        .white,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            weeksList[index]
                                                                .toString()
                                                                .substring(
                                                                    0, 3),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .displayMedium!
                                                                .copyWith(
                                                                  fontSize: 16,
                                                                ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: context.height * 0.009),
                                SizedBox(
                                  // width: context.width * 0.84,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: ColoredBox(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: context.height * 0.015,
                                          vertical: context.width * 0.035,
                                        ),
                                        child: Theme(
                                          data: ThemeData(
                                            dividerColor: Colors.transparent,
                                          ),
                                          child: ExpansionTile(
                                            tilePadding:
                                                const EdgeInsets.all(3),
                                            childrenPadding: EdgeInsets.only(
                                              left: context.width * 0.09,
                                            ),
                                            title: Text(
                                              'Instructions',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    fontSize: 20,
                                                  ),
                                            ),
                                            iconColor: Colors.black,
                                            collapsedIconColor: Colors.black,
                                            leading: Image.asset(
                                              AppImages.instructions,
                                              height: 150,
                                              fit: BoxFit.fill,
                                            ),
                                            // trailing: Icon(
                                            //   Icons.keyboard_arrow_down,
                                            //   size: 56,
                                            // ),
                                            expandedCrossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            expandedAlignment:
                                                Alignment.topLeft,
                                            children: [
                                              Text(
                                                futureDocs['instructions'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium!
                                                    .copyWith(
                                                      fontSize: 16,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: context.height * 0.01),
                                SizedBox(
                                  // width: context.width * 0.84,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: ColoredBox(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: context.height * 0.015,
                                          vertical: context.width * 0.035,
                                        ),
                                        child: Theme(
                                          data: ThemeData(
                                            dividerColor: Colors.transparent,
                                          ),
                                          child: ExpansionTile(
                                            tilePadding:
                                                const EdgeInsets.all(3),
                                            childrenPadding: EdgeInsets.only(
                                              left: context.width * 0.09,
                                            ),
                                            iconColor: Colors.black,
                                            collapsedIconColor: Colors.black,
                                            title: Text(
                                              'Ingredients list',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    fontSize: 20,
                                                  ),
                                            ),
                                            leading: Image.asset(
                                              AppImages.ingredients,
                                            ),
                                            // trailing: Icon(
                                            //   Icons.keyboard_arrow_down,
                                            //   size: 56,
                                            // ),
                                            expandedCrossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            expandedAlignment:
                                                Alignment.topLeft,
                                            children: [
                                              Text(
                                                futureDocs['ingredients'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium!
                                                    .copyWith(
                                                      fontSize: 16,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: context.height * 0.01),
                                SizedBox(
                                  // width: context.width * 0.84,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: ColoredBox(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: context.height * 0.015,
                                          vertical: context.width * 0.035,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                Image.asset(
                                                  AppImages.calori,
                                                ),
                                                Text(
                                                  futureDocs['calories'],
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
                                            Column(
                                              children: [
                                                Image.asset(
                                                  AppImages.loading,
                                                ),
                                                Text(
                                                  futureDocs['time'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                        fontSize: 24,
                                                      ),
                                                ),
                                                Text(
                                                  'Min',
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
                                                  AppImages.pricee,
                                                ),
                                                Text(
                                                  futureDocs['price'],
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
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: context.height * 0.01),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Text('No data available.');
                    }
                  });
            } else {
              return const Text('No data available.');
            }
          }),
    );
  }
}
