import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/constants/app_images.dart';
import 'package:fitness/extensions/shared_extensions.dart';
import 'package:fitness/helpers/shared_helpers.dart';
import 'package:fitness/helpers/user_helpers.dart';
import 'package:fitness/services/navigation_service.dart';
import 'package:fitness/views/user/plans/plans_list_view.dart';
import 'package:fitness/widgets/scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../database/firebase.dart';
import '../plans/plans_detail_view.dart';
import '../profile/nutrition_plan_view.dart';
import '../profile/profile_view.dart';
import '../profile/update_payment_view.dart';
import '../profile/update_weight_view.dart';
import 'components/widgets/plan_small_info_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late String currentDayName;

  @override
  initState() {
    super.initState();
    getCurrentUserWeightDateTime();
    DateTime now = DateTime.now();
    currentDayName = DateFormat('EEEE').format(now);
  }

  void getCurrentUserWeightDateTime() async {
    DateTime currentDate = DateTime.now();
    DocumentSnapshot snapshot = await FirebaseEndPoints.userCollection
        .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
        .get();
    final userWeightDateTime = snapshot.get('weightAddedDateTime').toDate();
    final paidDateTime = snapshot.get('paidDateTime').toDate();
    final paidType = snapshot.get('paidType');

    Duration paidifference = currentDate.difference(paidDateTime);
    int daypaidDifference = paidifference.inDays;

    Duration difference = currentDate.difference(userWeightDateTime);
    int dayDifference = difference.inDays;
    if (paidType == 'monthly') {
      if (daypaidDifference > 30) {
        NavigationService().pushAndRemoveUntil(UpdatePaymentView());
      }
    } else if (paidType == 'yearly') {
      if (daypaidDifference > 364) {
        NavigationService().pushAndRemoveUntil(UpdatePaymentView());
      }
    }

if (dayDifference > 7) {
        NavigationService().pushAndRemoveUntil(UpdateWeightView());
      }

  }

  int selectedTabIndex = 0;

  String selectedDay = 'Thursday';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: ScaffoldWidget(
          useCustomPadding: true,
          child: Column(
            children: [
              SizedBox(
                height: context.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      NavigationService().push(const ProfileView());
                    },
                    icon: Icon(
                      Icons.settings,
                    ),
                  ),
                  FutureBuilder(
                      future: FirebaseEndPoints.userCollection
                          .doc(FirebaseAccess
                              .firebaseAuthInstance.currentUser?.uid)
                          .get(),
                      builder: (context, userInfoSnapShot) {
                        if (userInfoSnapShot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox();
                        } else if (userInfoSnapShot.hasError) {
                          if (userInfoSnapShot.error is SocketException) {
                            return const Text('No internet connection.');
                          } else {
                            return Text(
                                'An error occurred: ${userInfoSnapShot.error}');
                          }
                        } else if (userInfoSnapShot.hasData) {
                          final futureDocs =
                              userInfoSnapShot.data as DocumentSnapshot;
                          double totalCalories = 0;
                          if (futureDocs['weightGoal'] == '0.0') {
                            totalCalories =
                                double.parse(futureDocs['morningWeight']) *
                                    44.0;
                          }
                          if (futureDocs['weightGoal'] == '0.25') {
                            totalCalories =
                                double.parse(futureDocs['morningWeight']) *
                                    38.0;
                          }
                          if (futureDocs['weightGoal'] == '0.5') {
                            totalCalories =
                                double.parse(futureDocs['morningWeight']) *
                                    32.0;
                          }
                          if (futureDocs['weightGoal'] == '0.75') {
                            totalCalories =
                                double.parse(futureDocs['morningWeight']) *
                                    26.0;
                          }
                          if (futureDocs['weightGoal'] == '1.0') {
                            totalCalories =
                                double.parse(futureDocs['morningWeight']) *
                                    21.0;
                          }
                          final nowCalories = totalCalories /
                              double.parse(futureDocs['mealsPerDay']);

                          return FutureBuilder(
                              future: FirebaseEndPoints.userCollection
                                  .doc(FirebaseAccess
                                      .firebaseAuthInstance.currentUser?.uid)
                                  .collection(FirebaseCollectionNames
                                      .userReceipeCollection)
                                  .get(),
                              builder: (context, snapshot1) {
                                if (snapshot1.connectionState ==
                                    ConnectionState.waiting) {
                                  return SizedBox();
                                } else if (snapshot1.hasError) {
                                  if (snapshot1.error is SocketException) {
                                    return const Text(
                                        'No internet connection.');
                                  } else {
                                    return Text(
                                        'An error occurred: ${snapshot1.error}');
                                  }
                                } else if (snapshot1.hasData) {
                                  if (snapshot1.data?.size != 0) {
                                    return FutureBuilder(
                                        future: FirebaseEndPoints
                                            .adminReceipeCollection
                                            .get(),
                                        builder:
                                            (context, adminReceipeSnapshot) {
                                          if (adminReceipeSnapshot
                                                  .connectionState ==
                                              ConnectionState.waiting) {
                                            return SizedBox();
                                          } else if (adminReceipeSnapshot
                                              .hasError) {
                                            if (adminReceipeSnapshot.error
                                                is SocketException) {
                                              return const Text(
                                                  'No internet connection.');
                                            } else {
                                              return Text(
                                                  'An error occurred: ${adminReceipeSnapshot.error}');
                                            }
                                          } else if (adminReceipeSnapshot
                                              .hasData) {
                                            double price = 0;
                                            double calorie = 0;
                                            double protien = 0;
                                            double carbs = 0;
                                            double fats = 0;

                                            if (adminReceipeSnapshot
                                                    .data?.size !=
                                                0) {
                                              snapshot1.data?.docs
                                                  .forEach((userReceipe) {
                                                adminReceipeSnapshot.data?.docs
                                                    .forEach((adminRec) {
                                                  if (userReceipe
                                                          .get('receipeId') ==
                                                      adminRec.id) {
                                                    if (userReceipe
                                                        .get('weekdays')
                                                        .asMap()
                                                        .isNotEmpty) {
                                                      if (userReceipe
                                                          .get('weekdays')
                                                          .asMap()
                                                          .values
                                                          .contains(
                                                              currentDayName)) {
                                                        price = price +
                                                            double.parse(
                                                                adminRec.get(
                                                                    'price'));
                                                        calorie = calorie +
                                                            double.parse(
                                                                adminRec.get(
                                                                    'calories'));
                                                        protien = protien +
                                                            double.parse(
                                                                adminRec.get(
                                                                    'protiens'));
                                                        carbs = carbs +
                                                            double.parse(
                                                                adminRec.get(
                                                                    'carbs'));
                                                        fats = fats +
                                                            double.parse(
                                                                adminRec.get(
                                                                    'fats'));
                                                      } else {
                                                        print('else');
                                                      }
                                                    }
                                                  }
                                                });
                                              });
                                              final maxProtien = (double.parse(
                                                      futureDocs[
                                                          'morningWeight']) *
                                                  2.4);
                                              final minProtien = (double.parse(
                                                      futureDocs[
                                                          'morningWeight']) *
                                                  1.8);

                                              final maxProtienC =
                                                  maxProtien * 4;
                                              final minProtienC =
                                                  minProtien * 4;

                                              final maxCarbsC =
                                                  (nowCalories / 100) * 65;
                                              final minCarbsC =
                                                  (nowCalories / 100) * 45;

                                              final maxCarbs = maxCarbsC / 4;
                                              final minCarbs = minCarbsC / 4;

                                              final maxFatsC =
                                                  (nowCalories / 100) * 35;
                                              final minFatsC =
                                                  (nowCalories / 100) * 20;

                                              final maxFats = maxFatsC / 9;
                                              final minFats = minFatsC / 9;

                                              bool pTrue =
                                                  (calorie >= minProtienC &&
                                                      calorie <= maxProtienC);
                                              bool cTrue =
                                                  (calorie >= minCarbsC &&
                                                      calorie <= maxCarbsC);
                                              bool fTrue =
                                                  (calorie >= minFatsC &&
                                                      calorie <= maxFatsC);

                                              return GestureDetector(
                                                onTap: () {
                                                  NavigationService()
                                                      .push(NutritionPlanView(
                                                    currentDay:
                                                        selectedTabIndex == 0
                                                            ? currentDayName
                                                            : selectedDay,
                                                  ));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    border: Border.all(
                                                      color: pTrue == false ||
                                                              cTrue == false ||
                                                              fTrue == false
                                                          ? Colors.red
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(3),
                                                  child: Icon(
                                                    Icons.question_mark,
                                                    color: pTrue == false ||
                                                            cTrue == false ||
                                                            fTrue == false
                                                        ? Colors.red
                                                        : Colors.black,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return const Text(
                                                  'No data available.');
                                            }
                                          } else {
                                            return const Text(
                                                'No data available.');
                                          }
                                        });
                                  } else {
                                    return SizedBox();
                                  }
                                } else {
                                  return const Text('No data available.');
                                }
                              });
                        } else {
                          return const Text('No data available.');
                        }
                      }),
                  IconButton(
                    onPressed: () {
                      SharedHelpers.logout();
                    },
                    icon: Icon(
                      Icons.logout,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: context.height * 0.01,
              ),
              TabBar(
                labelColor: const Color.fromRGBO(0, 0, 0, 1),
                indicator: const BoxDecoration(),
                indicatorPadding: EdgeInsets.zero,
                overlayColor: MaterialStatePropertyAll(
                  Colors.transparent,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                padding: EdgeInsets.zero,
                labelPadding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 20,
                    ),
                onTap: (value) {
                  setState(() {
                    selectedTabIndex = value;
                  });
                },
                tabs: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.width * 0.029,
                      vertical: context.height * 0.01,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                      color: selectedTabIndex == 0
                          ? const Color.fromRGBO(237, 237, 237, 1)
                          : Colors.white,
                    ),
                    child: const Tab(
                      text: 'Daily plan',
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.width * 0.029,
                      vertical: context.height * 0.01,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                      color: selectedTabIndex == 1
                          ? const Color.fromRGBO(237, 237, 237, 1)
                          : Colors.white,
                    ),
                    child: const Tab(
                      text: 'Weekly plan',
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: context.height * 0.028,
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                 
                        Text(
                          'Breakfast',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 16,
                                  ),
                        ),
                        SizedBox(
                          height: context.height * 0.008,
                        ),
                        FutureBuilder(
                            future: FirebaseEndPoints.userCollection
                                .doc(FirebaseAccess
                                    .firebaseAuthInstance.currentUser?.uid)
                                .get(),
                            builder: (context, snapshot1) {
                              if (snapshot1.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot1.hasError) {
                                if (snapshot1.error is SocketException) {
                                  return const Text('No internet connection.');
                                } else {
                                  return Text(
                                      'An error occurred: ${snapshot1.error}');
                                }
                              } else if (snapshot1.hasData) {
                                final futureDocs =
                                    snapshot1.data as DocumentSnapshot;
                                double totalCalories = 0;
                                if (futureDocs['weightGoal'] == '0.0') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      44.0;
                                }
                                if (futureDocs['weightGoal'] == '0.25') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      38.0;
                                }
                                if (futureDocs['weightGoal'] == '0.5') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      32.0;
                                }
                                if (futureDocs['weightGoal'] == '0.75') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      26.0;
                                }
                                if (futureDocs['weightGoal'] == '1.0') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      21.0;
                                }
                                final nowCalories = totalCalories /
                                    double.parse(futureDocs['mealsPerDay']);
                                final lessCalories = nowCalories - 50.0;
                                final greaterCalories = nowCalories + 50.0;
                                return FutureBuilder(
                                    future: FirebaseEndPoints.userCollection
                                        .doc(FirebaseAccess.firebaseAuthInstance
                                            .currentUser?.uid)
                                        .collection(FirebaseCollectionNames
                                            .userReceipeCollection)
                                        // .where('receipeId',
                                        //     isEqualTo: 'widget.id')
                                        .get(),
                                    builder: (context, receipeTry) {
                                      if (receipeTry.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (receipeTry.hasError) {
                                        if (receipeTry.error
                                            is SocketException) {
                                          return const Text(
                                              'No internet connection.');
                                        } else {
                                          return Text(
                                              'An error occurred: ${receipeTry.error}');
                                        }
                                      } else if (receipeTry.hasData) {
                                        final receipeTrySize =
                                            receipeTry.data?.size != 0
                                                ? true
                                                : false;
                                        return FutureBuilder(
                                          future: FirebaseEndPoints
                                              .adminReceipeCollection
                                              .where('halfDay',
                                                  isEqualTo: 'Breakfast')
                                              .where('plan',
                                                  arrayContains: 'Daily')
                                      
                                              .get(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              if (snapshot.error
                                                  is SocketException) {
                                                return const Text(
                                                    'No internet connection.');
                                              } else {
                                                return Text(
                                                    'An error occurred: ${snapshot.error}');
                                              }
                                            } else if (snapshot.hasData) {
                                              final documents =
                                                  snapshot.data!.docs;
                                              String hideReceipeId = '';
                                              if (documents.isNotEmpty) {
                                                List<
                                                        QueryDocumentSnapshot<
                                                            Map<String,
                                                                dynamic>>>
                                                    filteredDocuments =
                                                    documents.where((doc) {
                                                  bool isDayPresent = false;
                                                  Timestamp? timestamp1;
                                                  Timestamp timestamp2 =
                                                      doc['dateTime'];
                                                  if (receipeTry.data?.size !=
                                                      0) {
                                                    receipeTry.data?.docs
                                                        .forEach((element) {
                                                      if (doc.id ==
                                                          element.get(
                                                              'receipeId')) {
                                                        hideReceipeId = element
                                                            .get('receipeId');
                                                        if (element
                                                                    .get(
                                                                        'weekdays')
                                                                    .asMap()
                                                                    .values
                                                                    .contains(
                                                                        currentDayName) ==
                                                                true &&
                                                            element.get(
                                                                    'halfDay') ==
                                                                'Breakfast') {
                                                          isDayPresent = true;
                                                          timestamp1 =
                                                              element.get(
                                                                  'userDateTime');
                                                        }

                                                        return;
                                                      }
                                                    });
                                                  }

                                                  return int.parse(doc['time']) <=
                                                          int.parse(futureDocs[
                                                              'breakfast']) &&
                                                      double.parse(doc['price']) <=
                                                          double.parse(
                                                              futureDocs[
                                                                  'amount']) &&
                                                      ((double.parse(doc['calories'])) >=
                                                                  lessCalories ==
                                                              true
                                                          ? true
                                                          : false) &&
                                                      ((double.parse(doc['calories']) <=
                                                                  greaterCalories ==
                                                              true
                                                          ? true
                                                          : false)) &&
                                         
                                                      (isDayPresent == true
                                                          ? timestamp1!.compareTo(
                                                                      timestamp2) >
                                                                  0
                                                              ? true
                                                              : false
                                                          : false) &&
                                            
                                                      (futureDocs['allergy1']
                                                                  .toString() !=
                                                              ''
                                                          ? doc['ingredients']
                                                                      .toString()
                                                                      .toLowerCase()
                                                                      .contains(futureDocs['allergy1'].toString().toLowerCase()) ==
                                                                  true
                                                              ? false
                                                              : true
                                                          : true) &&
                                                      (futureDocs['allergy2'].toString() != ''
                                                          ? doc['ingredients'].toString().toLowerCase().contains(futureDocs['allergy2'].toString().toLowerCase()) == true
                                                              ? false
                                                              : true
                                                          : true) &&
                                                      (futureDocs['allergy3'].toString() != ''
                                                          ? doc['ingredients'].toString().toLowerCase().contains(futureDocs['allergy3'].toString().toLowerCase()) == true
                                                              ? false
                                                              : true
                                                          : true);
                                                }).toList();
                                                if (filteredDocuments.isEmpty) {
                                                  filteredDocuments =
                                                      documents.where((doc) {
                                                    return int.parse(doc['time']) <=
                                                            int.parse(futureDocs[
                                                                'breakfast']) &&
                                                        double.parse(doc['price']) <=
                                                            double.parse(
                                                                futureDocs[
                                                                    'amount']) &&
                                                        ((double.parse(doc['calories'])) >= lessCalories == true
                                                            ? true
                                                            : false) &&
                                                        ((double.parse(doc['calories']) <= greaterCalories == true
                                                            ? true
                                                            : false)) &&
                                                        // (isDayPresent == true
                                                        //     ? timestamp1!.compareTo(
                                                        //                 timestamp2) >
                                                        //             0
                                                        //         ? true
                                                        //         : false
                                                        //     : false) &&
                                                        //     (isDayPresent == true
                                                        //         ? true
                                                        //         : true) &&
                                                        (futureDocs['allergy1']
                                                                    .toString() !=
                                                                ''
                                                            ? doc['ingredients']
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .contains(futureDocs['allergy1']
                                                                            .toString()
                                                                            .toLowerCase()) ==
                                                                    true
                                                                ? false
                                                                : true
                                                            : true) &&
                                                        (futureDocs['allergy2']
                                                                    .toString() !=
                                                                ''
                                                            ? doc['ingredients']
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .contains(futureDocs['allergy2'].toString().toLowerCase()) ==
                                                                    true
                                                                ? false
                                                                : true
                                                            : true) &&
                                                        (futureDocs['allergy3'].toString() != ''
                                                            ? doc['ingredients'].toString().toLowerCase().contains(futureDocs['allergy3'].toString().toLowerCase()) == true
                                                                ? false
                                                                : true
                                                            : true);
                                                  }).toList();
                                                }
                                                if (filteredDocuments
                                                    .isNotEmpty) {
                                                  final data =
                                                      filteredDocuments.first;

                                                  return PlanSmallInfoWidget(
                                                    detailOnTap: () {
                                                      List<String> myData =
                                                          data['weekdays']
                                                              .cast<String>();
                                                      NavigationService().push(
                                                        PlansDetailView(
                                                          id: data.id,
                                                  
                                                        ),
                                                      );
                                                    },
                                                    imagePath: data['imageUrl'],
                                                    title: data['name'],
                                                    proteins: data['protiens'],
                                                    carbs: data['carbs'],
                                                    fat: data['fats'],
                                                    onTap: () {
                                                      NavigationService().push(
                                                        PlansListView(
                                                          planName: 'Breakfast',
                                                          plan: 'Daily',
                                                          hideReceipeId:
                                                              data.id,
                                                        ),
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  return SizedBox();
                                                }
                                              } else {
                                                return SizedBox();
                                              }
                                            } else {
                                              return const Text(
                                                  'No data available.');
                                            }
                                          },
                                        );
                                      } else {
                                        return const Text('No data available.');
                                      }
                                    });
                              } else {
                                return const Text('No data available.');
                              }
                            }),

                        SizedBox(
                          height: context.height * 0.03,
                        ),
                        Text(
                          'Lunch',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 16,
                                  ),
                        ),
                        SizedBox(
                          height: context.height * 0.008,
                        ),
                        FutureBuilder(
                            future: FirebaseEndPoints.userCollection
                                .doc(FirebaseAccess
                                    .firebaseAuthInstance.currentUser?.uid)
                                .get(),
                            builder: (context, snapshot1) {
                              if (snapshot1.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot1.hasError) {
                                if (snapshot1.error is SocketException) {
                                  return const Text('No internet connection.');
                                } else {
                                  return Text(
                                      'An error occurred: ${snapshot1.error}');
                                }
                              } else if (snapshot1.hasData) {
                                final futureDocs =
                                    snapshot1.data as DocumentSnapshot;
                                double totalCalories = 0;
                                if (futureDocs['weightGoal'] == '0.0') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      44.0;
                                }
                                if (futureDocs['weightGoal'] == '0.25') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      38.0;
                                }
                                if (futureDocs['weightGoal'] == '0.5') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      32.0;
                                }
                                if (futureDocs['weightGoal'] == '0.75') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      26.0;
                                }
                                if (futureDocs['weightGoal'] == '1.0') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      21.0;
                                }
                                final nowCalories = totalCalories /
                                    double.parse(futureDocs['mealsPerDay']);
                                final lessCalories = nowCalories - 50.0;
                                final greaterCalories = nowCalories + 50.0;
                                return FutureBuilder(
                                    future: FirebaseEndPoints.userCollection
                                        .doc(FirebaseAccess.firebaseAuthInstance
                                            .currentUser?.uid)
                                        .collection(FirebaseCollectionNames
                                            .userReceipeCollection)
                               
                                        .get(),
                                    builder: (context, receipeTry) {
                                      if (receipeTry.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (receipeTry.hasError) {
                                        if (receipeTry.error
                                            is SocketException) {
                                          return const Text(
                                              'No internet connection.');
                                        } else {
                                          return Text(
                                              'An error occurred: ${receipeTry.error}');
                                        }
                                      } else if (receipeTry.hasData) {
                                        final receipeTrySize =
                                            receipeTry.data?.size != 0
                                                ? true
                                                : false;
                                        return FutureBuilder(
                                          future: FirebaseEndPoints
                                              .adminReceipeCollection
                                              .where('halfDay',
                                                  isEqualTo: 'Lunch')
                                              .where('plan',
                                                  arrayContains: 'Daily')
                                    
                                              .get(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              if (snapshot.error
                                                  is SocketException) {
                                                return const Text(
                                                    'No internet connection.');
                                              } else {
                                                return Text(
                                                    'An error occurred: ${snapshot.error}');
                                              }
                                            } else if (snapshot.hasData) {
                                              final documents =
                                                  snapshot.data!.docs;
                                              String hideReceipeId = '';
                                              if (documents.isNotEmpty) {
                                                List<
                                                        QueryDocumentSnapshot<
                                                            Map<String,
                                                                dynamic>>>
                                                    filteredDocuments =
                                                    documents.where((doc) {
                                                  bool isDayPresent = false;
                                                  Timestamp? timestamp1;
                                                  Timestamp timestamp2 =
                                                      doc['dateTime'];
                                                  if (receipeTry.data?.size !=
                                                      0) {
                                                    receipeTry.data?.docs
                                                        .forEach((element) {
                                                      if (doc.id ==
                                                          element.get(
                                                              'receipeId')) {
                                                        hideReceipeId = element
                                                            .get('receipeId');
                                                        if (element
                                                                    .get(
                                                                        'weekdays')
                                                                    .asMap()
                                                                    .values
                                                                    .contains(
                                                                        currentDayName) ==
                                                                true &&
                                                            element.get(
                                                                    'halfDay') ==
                                                                'Lunch') {
                                                          isDayPresent = true;
                                                          timestamp1 =
                                                              element.get(
                                                                  'userDateTime');
                                                        }

                                                        return;
                                                      }
                                                    });
                                                  }

                                                  return int.parse(doc['time']) <=
                                                          int.parse(futureDocs[
                                                              'lunch']) &&
                                                      double.parse(doc['price']) <=
                                                          double.parse(
                                                              futureDocs[
                                                                  'amount']) &&
                                                      ((double.parse(doc['calories'])) >=
                                                                  lessCalories ==
                                                              true
                                                          ? true
                                                          : false) &&
                                                      ((double.parse(doc['calories']) <=
                                                                  greaterCalories ==
                                                              true
                                                          ? true
                                                          : false)) &&
                                                      //   (  timestamp1 != null
                                                      // ?
                                                      // (timestamp1!.compareTo(timestamp2) > 0
                                                      //     ? true
                                                      //     : false)
                                                      // // : false)
                                                      // &&
                                                      (isDayPresent == true
                                                          ? timestamp1!.compareTo(
                                                                      timestamp2) >
                                                                  0
                                                              ? true
                                                              : false
                                                          : false) &&
                                                      // (isDayPresent == true
                                                      //     ? true
                                                      //     : true) &&
                                                      (futureDocs['allergy1']
                                                                  .toString() !=
                                                              ''
                                                          ? doc['ingredients']
                                                                      .toString()
                                                                      .toLowerCase()
                                                                      .contains(futureDocs['allergy1'].toString().toLowerCase()) ==
                                                                  true
                                                              ? false
                                                              : true
                                                          : true) &&
                                                      (futureDocs['allergy2'].toString() != ''
                                                          ? doc['ingredients'].toString().toLowerCase().contains(futureDocs['allergy2'].toString().toLowerCase()) == true
                                                              ? false
                                                              : true
                                                          : true) &&
                                                      (futureDocs['allergy3'].toString() != ''
                                                          ? doc['ingredients'].toString().toLowerCase().contains(futureDocs['allergy3'].toString().toLowerCase()) == true
                                                              ? false
                                                              : true
                                                          : true);
                                                }).toList();
                                                if (filteredDocuments.isEmpty) {
                                                  filteredDocuments =
                                                      documents.where((doc) {
                                                    return int.parse(doc['time']) <=
                                                            int.parse(futureDocs[
                                                                'lunch']) &&
                                                        double.parse(doc['price']) <=
                                                            double.parse(
                                                                futureDocs[
                                                                    'amount']) &&
                                                        ((double.parse(doc['calories'])) >= lessCalories == true
                                                            ? true
                                                            : false) &&
                                                        ((double.parse(doc['calories']) <= greaterCalories == true
                                                            ? true
                                                            : false)) &&
                                          
                                                        (futureDocs['allergy1']
                                                                    .toString() !=
                                                                ''
                                                            ? doc['ingredients']
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .contains(futureDocs['allergy1']
                                                                            .toString()
                                                                            .toLowerCase()) ==
                                                                    true
                                                                ? false
                                                                : true
                                                            : true) &&
                                                        (futureDocs['allergy2']
                                                                    .toString() !=
                                                                ''
                                                            ? doc['ingredients']
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .contains(futureDocs['allergy2'].toString().toLowerCase()) ==
                                                                    true
                                                                ? false
                                                                : true
                                                            : true) &&
                                                        (futureDocs['allergy3'].toString() != ''
                                                            ? doc['ingredients'].toString().toLowerCase().contains(futureDocs['allergy3'].toString().toLowerCase()) == true
                                                                ? false
                                                                : true
                                                            : true);
                                                  }).toList();
                                                }
                                                if (filteredDocuments
                                                    .isNotEmpty) {
                                                  final data =
                                                      filteredDocuments.first;

                                                  return PlanSmallInfoWidget(
                                                    detailOnTap: () {
                                                      List<String> myData =
                                                          data['weekdays']
                                                              .cast<String>();
                                                      NavigationService().push(
                                                        PlansDetailView(
                                                          id: data.id,
                                                   
                                                        ),
                                                      );
                                                    },
                                                    imagePath: data['imageUrl'],
                                                    title: data['name'],
                                                    proteins: data['protiens'],
                                                    carbs: data['carbs'],
                                                    fat: data['fats'],
                                                    onTap: () {
                                                      NavigationService().push(
                                                        PlansListView(
                                                          planName: 'Lunch',
                                                          plan: 'Daily',
                                                          hideReceipeId:
                                                              data.id,
                                                        ),
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  return SizedBox();
                                                }
                                              } else {
                                                return SizedBox();
                                              }
                                            } else {
                                              return const Text(
                                                  'No data available.');
                                            }
                                          },
                                        );
                                      } else {
                                        return const Text('No data available.');
                                      }
                                    });
                              } else {
                                return const Text('No data available.');
                              }
                            }),

                        SizedBox(
                          height: context.height * 0.03,
                        ),
                        Text(
                          'Dinner',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 16,
                                  ),
                        ),
                        SizedBox(
                          height: context.height * 0.008,
                        ),
                        FutureBuilder(
                            future: FirebaseEndPoints.userCollection
                                .doc(FirebaseAccess
                                    .firebaseAuthInstance.currentUser?.uid)
                                .get(),
                            builder: (context, snapshot1) {
                              if (snapshot1.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot1.hasError) {
                                if (snapshot1.error is SocketException) {
                                  return const Text('No internet connection.');
                                } else {
                                  return Text(
                                      'An error occurred: ${snapshot1.error}');
                                }
                              } else if (snapshot1.hasData) {
                                final futureDocs =
                                    snapshot1.data as DocumentSnapshot;
                                double totalCalories = 0;
                                if (futureDocs['weightGoal'] == '0.0') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      44.0;
                                }
                                if (futureDocs['weightGoal'] == '0.25') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      38.0;
                                }
                                if (futureDocs['weightGoal'] == '0.5') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      32.0;
                                }
                                if (futureDocs['weightGoal'] == '0.75') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      26.0;
                                }
                                if (futureDocs['weightGoal'] == '1.0') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      21.0;
                                }
                                final nowCalories = totalCalories /
                                    double.parse(futureDocs['mealsPerDay']);
                                final lessCalories = nowCalories - 50.0;
                                final greaterCalories = nowCalories + 50.0;
                                return FutureBuilder(
                                    future: FirebaseEndPoints.userCollection
                                        .doc(FirebaseAccess.firebaseAuthInstance
                                            .currentUser?.uid)
                                        .collection(FirebaseCollectionNames
                                            .userReceipeCollection)
                                 
                                        .get(),
                                    builder: (context, receipeTry) {
                                      if (receipeTry.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (receipeTry.hasError) {
                                        if (receipeTry.error
                                            is SocketException) {
                                          return const Text(
                                              'No internet connection.');
                                        } else {
                                          return Text(
                                              'An error occurred: ${receipeTry.error}');
                                        }
                                      } else if (receipeTry.hasData) {
                                        final receipeTrySize =
                                            receipeTry.data?.size != 0
                                                ? true
                                                : false;
                                        return FutureBuilder(
                                          future: FirebaseEndPoints
                                              .adminReceipeCollection
                                              .where('halfDay',
                                                  isEqualTo: 'Dinner')
                                              .where('plan',
                                                  arrayContains: 'Daily')
                                      
                                              .get(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              if (snapshot.error
                                                  is SocketException) {
                                                return const Text(
                                                    'No internet connection.');
                                              } else {
                                                return Text(
                                                    'An error occurred: ${snapshot.error}');
                                              }
                                            } else if (snapshot.hasData) {
                                              final documents =
                                                  snapshot.data!.docs;
                                              String hideReceipeId = '';
                                              if (documents.isNotEmpty) {
                                                List<
                                                        QueryDocumentSnapshot<
                                                            Map<String,
                                                                dynamic>>>
                                                    filteredDocuments =
                                                    documents.where((doc) {
                                                  bool isDayPresent = false;
                                                  Timestamp? timestamp1;
                                                  Timestamp timestamp2 =
                                                      doc['dateTime'];
                                                  if (receipeTry.data?.size !=
                                                      0) {
                                                    receipeTry.data?.docs
                                                        .forEach((element) {
                                                      if (doc.id ==
                                                          element.get(
                                                              'receipeId')) {
                                                        hideReceipeId = element
                                                            .get('receipeId');
                                                        if (element
                                                                    .get(
                                                                        'weekdays')
                                                                    .asMap()
                                                                    .values
                                                                    .contains(
                                                                        currentDayName) ==
                                                                true &&
                                                            element.get(
                                                                    'halfDay') ==
                                                                'Dinner') {
                                                          isDayPresent = true;
                                                          timestamp1 =
                                                              element.get(
                                                                  'userDateTime');
                                                        }

                                                        return;
                                                      }
                                                    });
                                                  }

                                                  return int.parse(doc['time']) <=
                                                          int.parse(futureDocs[
                                                              'dinner']) &&
                                                      double.parse(doc['price']) <=
                                                          double.parse(
                                                              futureDocs[
                                                                  'amount']) &&
                                                      ((double.parse(doc['calories'])) >=
                                                                  lessCalories ==
                                                              true
                                                          ? true
                                                          : false) &&
                                                      ((double.parse(doc['calories']) <=
                                                                  greaterCalories ==
                                                              true
                                                          ? true
                                                          : false)) &&
                                            
                                                      (isDayPresent == true
                                                          ? timestamp1!.compareTo(
                                                                      timestamp2) >
                                                                  0
                                                              ? true
                                                              : false
                                                          : false) &&
                                                  
                                                      (futureDocs['allergy1']
                                                                  .toString() !=
                                                              ''
                                                          ? doc['ingredients']
                                                                      .toString()
                                                                      .toLowerCase()
                                                                      .contains(futureDocs['allergy1'].toString().toLowerCase()) ==
                                                                  true
                                                              ? false
                                                              : true
                                                          : true) &&
                                                      (futureDocs['allergy2'].toString() != ''
                                                          ? doc['ingredients'].toString().toLowerCase().contains(futureDocs['allergy2'].toString().toLowerCase()) == true
                                                              ? false
                                                              : true
                                                          : true) &&
                                                      (futureDocs['allergy3'].toString() != ''
                                                          ? doc['ingredients'].toString().toLowerCase().contains(futureDocs['allergy3'].toString().toLowerCase()) == true
                                                              ? false
                                                              : true
                                                          : true);
                                                }).toList();
                                                if (filteredDocuments.isEmpty) {
                                                  filteredDocuments =
                                                      documents.where((doc) {
                                                    return int.parse(doc['time']) <=
                                                            int.parse(futureDocs[
                                                                'dinner']) &&
                                                        double.parse(doc['price']) <=
                                                            double.parse(
                                                                futureDocs[
                                                                    'amount']) &&
                                                        ((double.parse(doc['calories'])) >= lessCalories == true
                                                            ? true
                                                            : false) &&
                                                        ((double.parse(doc['calories']) <= greaterCalories == true
                                                            ? true
                                                            : false)) &&
                                        
                                                        (futureDocs['allergy1']
                                                                    .toString() !=
                                                                ''
                                                            ? doc['ingredients']
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .contains(futureDocs['allergy1']
                                                                            .toString()
                                                                            .toLowerCase()) ==
                                                                    true
                                                                ? false
                                                                : true
                                                            : true) &&
                                                        (futureDocs['allergy2']
                                                                    .toString() !=
                                                                ''
                                                            ? doc['ingredients']
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .contains(futureDocs['allergy2'].toString().toLowerCase()) ==
                                                                    true
                                                                ? false
                                                                : true
                                                            : true) &&
                                                        (futureDocs['allergy3'].toString() != ''
                                                            ? doc['ingredients'].toString().toLowerCase().contains(futureDocs['allergy3'].toString().toLowerCase()) == true
                                                                ? false
                                                                : true
                                                            : true);
                                                  }).toList();
                                                }
                                                if (filteredDocuments
                                                    .isNotEmpty) {
                                                  final data =
                                                      filteredDocuments.first;

                                                  return PlanSmallInfoWidget(
                                                    detailOnTap: () {
                                                      List<String> myData =
                                                          data['weekdays']
                                                              .cast<String>();
                                                      NavigationService().push(
                                                        PlansDetailView(
                                                          id: data.id,
                                
                                                        ),
                                                      );
                                                    },
                                                    imagePath: data['imageUrl'],
                                                    title: data['name'],
                                                    proteins: data['protiens'],
                                                    carbs: data['carbs'],
                                                    fat: data['fats'],
                                                    onTap: () {
                                                      NavigationService().push(
                                                        PlansListView(
                                                          planName: 'Dinner',
                                                          plan: 'Daily',
                                                          hideReceipeId:
                                                              data.id,
                                                        ),
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  return SizedBox();
                                                }
                                              } else {
                                                return SizedBox();
                                              }
                                            } else {
                                              return const Text(
                                                  'No data available.');
                                            }
                                          },
                                        );
                                      } else {
                                        return const Text('No data available.');
                                      }
                                    });
                              } else {
                                return const Text('No data available.');
                              }
                            }),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: context.height * 0.092,
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: weeksList.length,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) => SizedBox(
                              width: context.width * 0.01,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedDay = weeksList[index];
                                  });
                                },
                                child: Container(
                                  width: context.width * 0.12,
                                  height: context.height * 0.092,
                                  decoration: BoxDecoration(
                                    color: selectedDay == weeksList[index]
                                        ? Colors.white
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Wrap(
                                    direction: Axis.vertical,
                                    runAlignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    alignment: WrapAlignment.center,
                                    children: [
                                      Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 3,
                                            ),
                                          ),
                                          child: selectedDay == weeksList[index]
                                              ? Container(
                                   
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                        222, 231, 232, 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                              
                                                  ),
                                                )
                                              : Container(
                                                  height: 20,
                                                  width: 20,
                                                  // padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 2,
                                                    ),
                                                  ),
                                                )),
                                      SizedBox(
                                        height: context.height * 0.009,
                                      ),
                                      Text(
                                        weeksList[index].substring(0, 3),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontSize: 14,
                                            ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                           
                            },
                          ),
                        ),
                        SizedBox(
                          height: context.height * 0.02,
                        ),
                 
                        Text(
                          'Breakfast',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 16,
                                  ),
                        ),
                        SizedBox(
                          height: context.height * 0.008,
                        ),
                        FutureBuilder(
                            future: FirebaseEndPoints.userCollection
                                .doc(FirebaseAccess
                                    .firebaseAuthInstance.currentUser?.uid)
                                .get(),
                            builder: (context, snapshot1) {
                              if (snapshot1.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot1.hasError) {
                                if (snapshot1.error is SocketException) {
                                  return const Text('No internet connection.');
                                } else {
                                  return Text(
                                      'An error occurred: ${snapshot1.error}');
                                }
                              } else if (snapshot1.hasData) {
                                final futureDocs =
                                    snapshot1.data as DocumentSnapshot;
                                double totalCalories = 0;
                                if (futureDocs['weightGoal'] == '0.0') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      44.0;
                                }
                                if (futureDocs['weightGoal'] == '0.25') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      38.0;
                                }
                                if (futureDocs['weightGoal'] == '0.5') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      32.0;
                                }
                                if (futureDocs['weightGoal'] == '0.75') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      26.0;
                                }
                                if (futureDocs['weightGoal'] == '1.0') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      21.0;
                                }
                                final nowCalories = totalCalories /
                                    double.parse(futureDocs['mealsPerDay']);
                                final lessCalories = nowCalories - 50.0;
                                final greaterCalories = nowCalories + 50.0;
                                print(nowCalories);
                                return FutureBuilder(
                                    future: FirebaseEndPoints.userCollection
                                        .doc(FirebaseAccess.firebaseAuthInstance
                                            .currentUser?.uid)
                                        .collection(FirebaseCollectionNames
                                            .userReceipeCollection)
                 
                                        .get(),
                                    builder: (context, receipeTry) {
                                      if (receipeTry.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (receipeTry.hasError) {
                                        if (receipeTry.error
                                            is SocketException) {
                                          return const Text(
                                              'No internet connection.');
                                        } else {
                                          return Text(
                                              'An error occurred: ${receipeTry.error}');
                                        }
                                      } else if (receipeTry.hasData) {
                                        return FutureBuilder(
                                          future: FirebaseEndPoints
                                              .adminReceipeCollection
                                              .where('halfDay',
                                                  isEqualTo: 'Breakfast')
                                              .where('plan',
                                                  arrayContains: 'Weekly')
                 
                                              .get(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              if (snapshot.error
                                                  is SocketException) {
                                                return const Text(
                                                    'No internet connection.');
                                              } else {
                                                return Text(
                                                    'An error occurred: ${snapshot.error}');
                                              }
                                            } else if (snapshot.hasData) {
                                              final documents =
                                                  snapshot.data!.docs;
                                              String hideReceipeId = '';
                                              if (documents.isNotEmpty) {
                                                List<
                                                        QueryDocumentSnapshot<
                                                            Map<String,
                                                                dynamic>>>
                                                    filteredDocuments =
                                                    documents.where((doc) {
                                                  bool isDayPresent = false;
                                                  Timestamp? timestamp1;
                                                  Timestamp timestamp2 =
                                                      doc['dateTime'];
                                                  if (receipeTry.data?.size !=
                                                      0) {
                                                    receipeTry.data?.docs
                                                        .forEach((element) {
                                                      if (doc.id ==
                                                          element.get(
                                                              'receipeId')) {
                                                        hideReceipeId = element
                                                            .get('receipeId');
                                                        if (element
                                                                    .get(
                                                                        'weekdays')
                                                                    .asMap()
                                                                    .values
                                                                    .contains(
                                                                        selectedDay) ==
                                                                true &&
                                                            element.get(
                                                                    'halfDay') ==
                                                                'Breakfast') {
                                                          isDayPresent = true;
                                                          timestamp1 =
                                                              element.get(
                                                                  'userDateTime');
                                                        }

                                                        return;
                                                      }
                                                    });
                                                  }

                                                  return int.parse(doc['time']) <=
                                                          int.parse(futureDocs[
                                                              'breakfast']) &&
                                                      double.parse(doc['price']) <=
                                                          double.parse(
                                                              futureDocs[
                                                                  'amount']) &&
                                                      ((double.parse(doc['calories'])) >=
                                                                  lessCalories ==
                                                              true
                                                          ? true
                                                          : false) &&
                                                      ((double.parse(doc['calories']) <=
                                                                  greaterCalories ==
                                                              true
                                                          ? true
                                                          : false)) &&
                                        
                                                      (isDayPresent == true
                                                          ? timestamp1!.compareTo(
                                                                      timestamp2) >
                                                                  0
                                                              ? true
                                                              : false
                                                          : false) &&
                                               
                                                      (futureDocs['allergy1']
                                                                  .toString() !=
                                                              ''
                                                          ? doc['ingredients']
                                                                      .toString()
                                                                      .toLowerCase()
                                                                      .contains(futureDocs['allergy1'].toString().toLowerCase()) ==
                                                                  true
                                                              ? false
                                                              : true
                                                          : true) &&
                                                      (futureDocs['allergy2'].toString() != ''
                                                          ? doc['ingredients'].toString().toLowerCase().contains(futureDocs['allergy2'].toString().toLowerCase()) == true
                                                              ? false
                                                              : true
                                                          : true) &&
                                                      (futureDocs['allergy3'].toString() != ''
                                                          ? doc['ingredients'].toString().toLowerCase().contains(futureDocs['allergy3'].toString().toLowerCase()) == true
                                                              ? false
                                                              : true
                                                          : true);
                                                }).toList();
                                                if (filteredDocuments.isEmpty) {
                                                  filteredDocuments =
                                                      documents.where((doc) {
                                                    return int.parse(doc['time']) <=
                                                            int.parse(futureDocs[
                                                                'breakfast']) &&
                                                        double.parse(doc['price']) <=
                                                            double.parse(
                                                                futureDocs[
                                                                    'amount']) &&
                                                        ((double.parse(doc['calories'])) >= lessCalories == true
                                                            ? true
                                                            : false) &&
                                                        ((double.parse(doc['calories']) <= greaterCalories == true
                                                            ? true
                                                            : false)) &&
                          
                                                        (futureDocs['allergy1']
                                                                    .toString() !=
                                                                ''
                                                            ? doc['ingredients']
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .contains(futureDocs['allergy1']
                                                                            .toString()
                                                                            .toLowerCase()) ==
                                                                    true
                                                                ? false
                                                                : true
                                                            : true) &&
                                                        (futureDocs['allergy2']
                                                                    .toString() !=
                                                                ''
                                                            ? doc['ingredients']
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .contains(futureDocs['allergy2'].toString().toLowerCase()) ==
                                                                    true
                                                                ? false
                                                                : true
                                                            : true) &&
                                                        (futureDocs['allergy3'].toString() != ''
                                                            ? doc['ingredients'].toString().toLowerCase().contains(futureDocs['allergy3'].toString().toLowerCase()) == true
                                                                ? false
                                                                : true
                                                            : true);
                                                  }).toList();
                                                }
                                                if (filteredDocuments
                                                    .isNotEmpty) {
                                                  final data =
                                                      filteredDocuments.first;

                                                  return PlanSmallInfoWidget(
                                                    detailOnTap: () {
                                                      List<String> myData =
                                                          data['weekdays']
                                                              .cast<String>();
                                                      NavigationService().push(
                                                        PlansDetailView(
                                                          id: data.id,
                             
                                    
                                                        ),
                                                      );
                                                    },
                                                    imagePath: data['imageUrl'],
                                                    title: data['name'],
                                                    proteins: data['protiens'],
                                                    carbs: data['carbs'],
                                                    fat: data['fats'],
                                                    onTap: () {
                                                      NavigationService().push(
                                                        PlansListView(
                                                          planName: 'Breakfast',
                                                          plan: 'Weekly',
                                                          hideReceipeId:
                                                              data.id,
                                                        ),
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  return SizedBox();
                                                }
                                              } else {
                                                return SizedBox();
                                              }
                                            } else {
                                              return const Text(
                                                  'No data available.');
                                            }
                                          },
                                        );
                                      } else {
                                        return const Text('No data available.');
                                      }
                                    });
                              } else {
                                return const Text('No data available.');
                              }
                            }),

                        SizedBox(
                          height: context.height * 0.04,
                        ),
                        Text(
                          'Lunch',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 16,
                                  ),
                        ),
                        SizedBox(
                          height: context.height * 0.008,
                        ),
                        FutureBuilder(
                            future: FirebaseEndPoints.userCollection
                                .doc(FirebaseAccess
                                    .firebaseAuthInstance.currentUser?.uid)
                                .get(),
                            builder: (context, snapshot1) {
                              if (snapshot1.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot1.hasError) {
                                if (snapshot1.error is SocketException) {
                                  return const Text('No internet connection.');
                                } else {
                                  return Text(
                                      'An error occurred: ${snapshot1.error}');
                                }
                              } else if (snapshot1.hasData) {
                                final futureDocs =
                                    snapshot1.data as DocumentSnapshot;
                                double totalCalories = 0;
                                if (futureDocs['weightGoal'] == '0.0') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      44.0;
                                }
                                if (futureDocs['weightGoal'] == '0.25') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      38.0;
                                }
                                if (futureDocs['weightGoal'] == '0.5') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      32.0;
                                }
                                if (futureDocs['weightGoal'] == '0.75') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      26.0;
                                }
                                if (futureDocs['weightGoal'] == '1.0') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      21.0;
                                }
                                final nowCalories = totalCalories /
                                    double.parse(futureDocs['mealsPerDay']);
                                final lessCalories = nowCalories - 50.0;
                                final greaterCalories = nowCalories + 50.0;
                                return FutureBuilder(
                                    future: FirebaseEndPoints.userCollection
                                        .doc(FirebaseAccess.firebaseAuthInstance
                                            .currentUser?.uid)
                                        .collection(FirebaseCollectionNames
                                            .userReceipeCollection)
                                        // .where('receipeId',
                                        //     isEqualTo: 'widget.id')
                                        .get(),
                                    builder: (context, receipeTry) {
                                      if (receipeTry.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (receipeTry.hasError) {
                                        if (receipeTry.error
                                            is SocketException) {
                                          return const Text(
                                              'No internet connection.');
                                        } else {
                                          return Text(
                                              'An error occurred: ${receipeTry.error}');
                                        }
                                      } else if (receipeTry.hasData) {
                                        return FutureBuilder(
                                          future: FirebaseEndPoints
                                              .adminReceipeCollection
                                              .where('halfDay',
                                                  isEqualTo: 'Lunch')
                                              .where('plan',
                                                  arrayContains: 'Weekly')
                           
                                              .get(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              if (snapshot.error
                                                  is SocketException) {
                                                return const Text(
                                                    'No internet connection.');
                                              } else {
                                                return Text(
                                                    'An error occurred: ${snapshot.error}');
                                              }
                                            } else if (snapshot.hasData) {
                                              final documents =
                                                  snapshot.data!.docs;
                                              String hideReceipeId = '';
                                              if (documents.isNotEmpty) {
                                                List<
                                                        QueryDocumentSnapshot<
                                                            Map<String,
                                                                dynamic>>>
                                                    filteredDocuments =
                                                    documents.where((doc) {
                                                  bool isDayPresent = false;
                                                  Timestamp? timestamp1;
                                                  Timestamp timestamp2 =
                                                      doc['dateTime'];
                                                  if (receipeTry.data?.size !=
                                                      0) {
                                                    receipeTry.data?.docs
                                                        .forEach((element) {
                                                      if (doc.id ==
                                                          element.get(
                                                              'receipeId')) {
                                                        hideReceipeId = element
                                                            .get('receipeId');
                                                        if (element
                                                                    .get(
                                                                        'weekdays')
                                                                    .asMap()
                                                                    .values
                                                                    .contains(
                                                                        selectedDay) ==
                                                                true &&
                                                            element.get(
                                                                    'halfDay') ==
                                                                'Lunch') {
                                                          isDayPresent = true;
                                                          timestamp1 =
                                                              element.get(
                                                                  'userDateTime');
                                                        }

                                                        return;
                                                      }
                                                    });
                                                  }

                                                  return int.parse(doc['time']) <=
                                                          int.parse(futureDocs[
                                                              'lunch']) &&
                                                      double.parse(doc['price']) <=
                                                          double.parse(
                                                              futureDocs[
                                                                  'amount']) &&
                                                      ((double.parse(doc['calories'])) >=
                                                                  lessCalories ==
                                                              true
                                                          ? true
                                                          : false) &&
                                                      ((double.parse(doc['calories']) <=
                                                                  greaterCalories ==
                                                              true
                                                          ? true
                                                          : false)) &&
                                               
                                                      (isDayPresent == true
                                                          ? timestamp1!.compareTo(
                                                                      timestamp2) >
                                                                  0
                                                              ? true
                                                              : false
                                                          : false) &&
                                                      // (isDayPresent == true
                                                      //     ? true
                                                      //     : true) &&
                                                      (futureDocs['allergy1']
                                                                  .toString() !=
                                                              ''
                                                          ? doc['ingredients']
                                                                      .toString()
                                                                      .toLowerCase()
                                                                      .contains(futureDocs['allergy1'].toString().toLowerCase()) ==
                                                                  true
                                                              ? false
                                                              : true
                                                          : true) &&
                                                      (futureDocs['allergy2'].toString() != ''
                                                          ? doc['ingredients'].toString().toLowerCase().contains(futureDocs['allergy2'].toString().toLowerCase()) == true
                                                              ? false
                                                              : true
                                                          : true) &&
                                                      (futureDocs['allergy3'].toString() != ''
                                                          ? doc['ingredients'].toString().toLowerCase().contains(futureDocs['allergy3'].toString().toLowerCase()) == true
                                                              ? false
                                                              : true
                                                          : true);
                                                }).toList();
                                                if (filteredDocuments.isEmpty) {
                                                  filteredDocuments =
                                                      documents.where((doc) {
                                                    return int.parse(doc['time']) <=
                                                            int.parse(futureDocs[
                                                                'lunch']) &&
                                                        double.parse(doc['price']) <=
                                                            double.parse(
                                                                futureDocs[
                                                                    'amount']) &&
                                                        ((double.parse(doc['calories'])) >= lessCalories == true
                                                            ? true
                                                            : false) &&
                                                        ((double.parse(doc['calories']) <= greaterCalories == true
                                                            ? true
                                                            : false)) &&
                                  
                                                        (futureDocs['allergy1']
                                                                    .toString() !=
                                                                ''
                                                            ? doc['ingredients']
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .contains(futureDocs['allergy1']
                                                                            .toString()
                                                                            .toLowerCase()) ==
                                                                    true
                                                                ? false
                                                                : true
                                                            : true) &&
                                                        (futureDocs['allergy2']
                                                                    .toString() !=
                                                                ''
                                                            ? doc['ingredients']
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .contains(futureDocs['allergy2'].toString().toLowerCase()) ==
                                                                    true
                                                                ? false
                                                                : true
                                                            : true) &&
                                                        (futureDocs['allergy3'].toString() != ''
                                                            ? doc['ingredients'].toString().toLowerCase().contains(futureDocs['allergy3'].toString().toLowerCase()) == true
                                                                ? false
                                                                : true
                                                            : true);
                                                  }).toList();
                                                }
                                                if (filteredDocuments
                                                    .isNotEmpty) {
                                                  final data =
                                                      filteredDocuments.first;

                                                  return PlanSmallInfoWidget(
                                                    detailOnTap: () {
                                                      List<String> myData =
                                                          data['weekdays']
                                                              .cast<String>();
                                                      NavigationService().push(
                                                        PlansDetailView(
                                                          id: data.id,
                                                       
                                   
                                                        ),
                                                      );
                                                    },
                                                    imagePath: data['imageUrl'],
                                                    title: data['name'],
                                                    proteins: data['protiens'],
                                                    carbs: data['carbs'],
                                                    fat: data['fats'],
                                                    onTap: () {
                                                      NavigationService().push(
                                                        PlansListView(
                                                          planName: 'Lunch',
                                                          plan: 'Weekly',
                                                          hideReceipeId:
                                                              data.id,
                                                        ),
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  return SizedBox();
                                                }
                                              } else {
                                                return SizedBox();
                                              }
                                            } else {
                                              return const Text(
                                                  'No data available.');
                                            }
                                          },
                                        );
                                      } else {
                                        return const Text('No data available.');
                                      }
                                    });
                              } else {
                                return const Text('No data available.');
                              }
                            }),

                        SizedBox(
                          height: context.height * 0.04,
                        ),
                        Text(
                          'Dinner',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 16,
                                  ),
                        ),
                        SizedBox(
                          height: context.height * 0.008,
                        ),
                        FutureBuilder(
                            future: FirebaseEndPoints.userCollection
                                .doc(FirebaseAccess
                                    .firebaseAuthInstance.currentUser?.uid)
                                .get(),
                            builder: (context, snapshot1) {
                              if (snapshot1.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot1.hasError) {
                                if (snapshot1.error is SocketException) {
                                  return const Text('No internet connection.');
                                } else {
                                  return Text(
                                      'An error occurred: ${snapshot1.error}');
                                }
                              } else if (snapshot1.hasData) {
                                final futureDocs =
                                    snapshot1.data as DocumentSnapshot;
                                double totalCalories = 0;
                                if (futureDocs['weightGoal'] == '0.0') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      44.0;
                                }
                                if (futureDocs['weightGoal'] == '0.25') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      38.0;
                                }
                                if (futureDocs['weightGoal'] == '0.5') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      32.0;
                                }
                                if (futureDocs['weightGoal'] == '0.75') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      26.0;
                                }
                                if (futureDocs['weightGoal'] == '1.0') {
                                  totalCalories = double.parse(
                                          futureDocs['morningWeight']) *
                                      21.0;
                                }
                                final nowCalories = totalCalories /
                                    double.parse(futureDocs['mealsPerDay']);
                                final lessCalories = nowCalories - 50.0;
                                final greaterCalories = nowCalories + 50.0;
                                return FutureBuilder(
                                    future: FirebaseEndPoints.userCollection
                                        .doc(FirebaseAccess.firebaseAuthInstance
                                            .currentUser?.uid)
                                        .collection(FirebaseCollectionNames
                                            .userReceipeCollection)
                                        // .where('receipeId',
                                        //     isEqualTo: 'widget.id')
                                        .get(),
                                    builder: (context, receipeTry) {
                                      if (receipeTry.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (receipeTry.hasError) {
                                        if (receipeTry.error
                                            is SocketException) {
                                          return const Text(
                                              'No internet connection.');
                                        } else {
                                          return Text(
                                              'An error occurred: ${receipeTry.error}');
                                        }
                                      } else if (receipeTry.hasData) {
                                        final receipeTrySize =
                                            receipeTry.data?.size != 0
                                                ? true
                                                : false;
                                        return FutureBuilder(
                                          future: FirebaseEndPoints
                                              .adminReceipeCollection
                                              .where('halfDay',
                                                  isEqualTo: 'Dinner')
                                              .where('plan',
                                                  arrayContains: 'Weekly')
                           
                                              .get(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              if (snapshot.error
                                                  is SocketException) {
                                                return const Text(
                                                    'No internet connection.');
                                              } else {
                                                return Text(
                                                    'An error occurred: ${snapshot.error}');
                                              }
                                            } else if (snapshot.hasData) {
                                              final documents =
                                                  snapshot.data!.docs;
                                              String hideReceipeId = '';
                                              if (documents.isNotEmpty) {
                                                List<
                                                        QueryDocumentSnapshot<
                                                            Map<String,
                                                                dynamic>>>
                                                    filteredDocuments =
                                                    documents.where((doc) {
                                                  bool isDayPresent = false;
                                                  Timestamp? timestamp1;
                                                  Timestamp timestamp2 =
                                                      doc['dateTime'];
                                                  if (receipeTry.data?.size !=
                                                      0) {
                                                    receipeTry.data?.docs
                                                        .forEach((element) {
                                                      if (doc.id ==
                                                          element.get(
                                                              'receipeId')) {
                                                        hideReceipeId = element
                                                            .get('receipeId');
                                                        if (element
                                                                    .get(
                                                                        'weekdays')
                                                                    .asMap()
                                                                    .values
                                                                    .contains(
                                                                        selectedDay) ==
                                                                true &&
                                                            element.get(
                                                                    'halfDay') ==
                                                                'Dinner') {
                                                          isDayPresent = true;
                                                          timestamp1 =
                                                              element.get(
                                                                  'userDateTime');
                                                        }

                                                        return;
                                                      }
                                                    });
                                                  }

                                                  return int.parse(doc['time']) <=
                                                          int.parse(futureDocs[
                                                              'dinner']) &&
                                                      double.parse(doc['price']) <=
                                                          double.parse(
                                                              futureDocs[
                                                                  'amount']) &&
                                                      ((double.parse(doc['calories'])) >=
                                                                  lessCalories ==
                                                              true
                                                          ? true
                                                          : false) &&
                                                      ((double.parse(doc['calories']) <=
                                                                  greaterCalories ==
                                                              true
                                                          ? true
                                                          : false)) &&
                                             
                                                      (isDayPresent == true
                                                          ? timestamp1!.compareTo(
                                                                      timestamp2) >
                                                                  0
                                                              ? true
                                                              : false
                                                          : false) &&
                                                
                                                      (futureDocs['allergy1']
                                                                  .toString() !=
                                                              ''
                                                          ? doc['ingredients']
                                                                      .toString()
                                                                      .toLowerCase()
                                                                      .contains(futureDocs['allergy1'].toString().toLowerCase()) ==
                                                                  true
                                                              ? false
                                                              : true
                                                          : true) &&
                                                      (futureDocs['allergy2'].toString() != ''
                                                          ? doc['ingredients'].toString().toLowerCase().contains(futureDocs['allergy2'].toString().toLowerCase()) == true
                                                              ? false
                                                              : true
                                                          : true) &&
                                                      (futureDocs['allergy3'].toString() != ''
                                                          ? doc['ingredients'].toString().toLowerCase().contains(futureDocs['allergy3'].toString().toLowerCase()) == true
                                                              ? false
                                                              : true
                                                          : true);
                                                }).toList();
                                                if (filteredDocuments.isEmpty) {
                                                  filteredDocuments =
                                                      documents.where((doc) {
                                                    return int.parse(doc['time']) <=
                                                            int.parse(futureDocs[
                                                                'dinner']) &&
                                                        double.parse(doc['price']) <=
                                                            double.parse(
                                                                futureDocs[
                                                                    'amount']) &&
                                                        ((double.parse(doc['calories'])) >= lessCalories == true
                                                            ? true
                                                            : false) &&
                                                        ((double.parse(doc['calories']) <= greaterCalories == true
                                                            ? true
                                                            : false)) &&
                                           
                                                 
                                                        (futureDocs['allergy1']
                                                                    .toString() !=
                                                                ''
                                                            ? doc['ingredients']
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .contains(futureDocs['allergy1']
                                                                            .toString()
                                                                            .toLowerCase()) ==
                                                                    true
                                                                ? false
                                                                : true
                                                            : true) &&
                                                        (futureDocs['allergy2']
                                                                    .toString() !=
                                                                ''
                                                            ? doc['ingredients']
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .contains(futureDocs['allergy2'].toString().toLowerCase()) ==
                                                                    true
                                                                ? false
                                                                : true
                                                            : true) &&
                                                        (futureDocs['allergy3'].toString() != ''
                                                            ? doc['ingredients'].toString().toLowerCase().contains(futureDocs['allergy3'].toString().toLowerCase()) == true
                                                                ? false
                                                                : true
                                                            : true);
                                                  }).toList();
                                                }
                                                if (filteredDocuments
                                                    .isNotEmpty) {
                                                  final data =
                                                      filteredDocuments.first;

                                                  return PlanSmallInfoWidget(
                                                    detailOnTap: () {
                                                      List<String> myData =
                                                          data['weekdays']
                                                              .cast<String>();
                                                      NavigationService().push(
                                                        PlansDetailView(
                                                          id: data.id,
                                             
                                                      
                                                        ),
                                                      );
                                                    },
                                                    imagePath: data['imageUrl'],
                                                    title: data['name'],
                                                    proteins: data['protiens'],
                                                    carbs: data['carbs'],
                                                    fat: data['fats'],
                                                    onTap: () {
                                                      NavigationService().push(
                                                        PlansListView(
                                                          planName: 'Dinner',
                                                          plan: 'Weekly',
                                                          hideReceipeId:
                                                              data.id,
                                                        ),
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  return SizedBox();
                                                }
                                              } else {
                                                return SizedBox();
                                              }
                                            } else {
                                              return const Text(
                                                  'No data available.');
                                            }
                                          },
                                        );
                                      } else {
                                        return const Text('No data available.');
                                      }
                                    });
                              } else {
                                return const Text('No data available.');
                              }
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
