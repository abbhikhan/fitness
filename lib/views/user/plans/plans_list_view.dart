import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/constants/app_images.dart';
import 'package:fitness/extensions/shared_extensions.dart';
import 'package:fitness/services/navigation_service.dart';
import 'package:fitness/views/user/plans/components/widgets/progress_bar.dart';
import 'package:fitness/widgets/scaffold_widget.dart';
import 'package:flutter/material.dart';

import '../../../database/firebase.dart';
import 'plans_detail_view.dart';

class PlansListView extends StatelessWidget {
  const PlansListView({
    super.key,
    required this.planName,
    required this.plan,
    this.weekDay = '',
    this.hideReceipeId,
  });

  final String planName;
  final String plan;
  final String weekDay;
  final String? hideReceipeId;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      useCustomPadding: true,
      child: Column(
        children: [
          SizedBox(
            height: context.height * 0.08,
          ),
          Text(
            planName,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 20,
                ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  NavigationService().pop();
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.close,
                  ),
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.all(3),
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     border: Border.all(
              //       color: Colors.black,
              //       width: 2,
              //     ),
              //   ),
              //   child: const Icon(
              //     Icons.check,
              //   ),
              // ),
            ],
          ),
          SizedBox(
            height: context.height * 0.03,
          ),
          Expanded(
            child: FutureBuilder(
                future: FirebaseEndPoints.userCollection
                    .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
                    .get(),
                builder: (context, snapshot1) {
                  if (snapshot1.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot1.hasError) {
                    if (snapshot1.error is SocketException) {
                      return const Text('No internet connection.');
                    } else {
                      return Text('An error occurred: ${snapshot1.error}');
                    }
                  } else if (snapshot1.hasData) {
                    final futureDocs = snapshot1.data as DocumentSnapshot;
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
                    final lessCalories = nowCalories - 50.0;
                    final greaterCalories = nowCalories + 50.0;
                    return FutureBuilder(
                        future: FirebaseEndPoints.adminReceipeCollection
                            .where('halfDay', isEqualTo: planName)
                            .where('plan', arrayContains: plan)
                            .orderBy('dateTime', descending: true)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            if (snapshot.error is SocketException) {
                              return const Text('No internet connection.');
                            } else {
                              return Text(
                                  'An error occurred: ${snapshot.error}');
                            }
                          } else if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              padding: EdgeInsets.zero,
                              // separatorBuilder: (context, index) => SizedBox(
                              //   height: context.height * 0.03,
                              // ),
                              itemBuilder: (context, index) {
                                final documents = snapshot.data!.docs;

                                if (documents.isNotEmpty) {
                                  final data = documents[index];
                                  // final filteredDocuments = documents
                                  //     .where((doc) =>
                                  //         int.parse(doc['time']) <= int.parse(futureDocs['breakfast']) &&
                                  //             double.parse(doc['price']) <=
                                  //                 double.parse(
                                  //                     futureDocs['amount']) &&
                                  //             double.parse(doc['calories']) >=
                                  //                 lessCalories ||
                                  //         double.parse(doc['calories']) <=
                                  //                 greaterCalories
                                  // &&
                                  //             !
                                  // doc['ingredients']
                                  //                 .toString()
                                  //                 .toLowerCase()
                                  //                 .contains(futureDocs['allergy1']
                                  //                     .toString()
                                  //                     .toLowerCase()) &&
                                  //             !doc['ingredients']
                                  //                 .toString()
                                  //                 .toLowerCase()
                                  //                 .contains(futureDocs['allergy2']
                                  //                     .toString()
                                  //                     .toLowerCase()) &&
                                  //             !doc['ingredients']
                                  //                 .toString()
                                  //                 .toLowerCase()
                                  //                 .contains(futureDocs['allergy3']
                                  //                     .toString()
                                  //                     .toLowerCase()))
                                  //     .toList();
                                  // if (documents.isNotEmpty) {
                                  //   final data = documents[index];

                                  if (int.parse(data['time']) <=
                                              int.parse(futureDocs[
                                                  planName.toLowerCase()]) &&
                                          double.parse(data['price']) <=
                                              double.parse(
                                                  futureDocs['amount']) &&
                                          ((double.parse(data['calories'])) >=
                                                      lessCalories ==
                                                  true
                                              ? true
                                              : false) &&
                                          ((double.parse(data['calories'])) <=
                                                      greaterCalories ==
                                                  true
                                              ? true
                                              : false) &&

                                          // (double.parse(data['calories']) <=
                                          //     greaterCalories) &&
                                          //     weekDay != ''
                                          // ? (data['weekdays'].isNotEmpty
                                          //     ? data['weekdays'].asMap().values.contains(weekDay) ==
                                          //             true
                                          //         ? true
                                          //         : false
                                          //     : true)
                                          // : true

                                          (futureDocs['allergy1'].toString() !=
                                                  ''
                                              ? data['ingredients']
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains(
                                                              futureDocs['allergy1']
                                                                  .toString()
                                                                  .toLowerCase()) ==
                                                      true
                                                  ? false
                                                  : true
                                              : true) &&
                                          (futureDocs['allergy2'].toString() !=
                                                  ''
                                              ? data['ingredients']
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains(futureDocs['allergy2'].toString().toLowerCase()) ==
                                                      true
                                                  ? false
                                                  : true
                                              : true) &&
                                          (futureDocs['allergy3'].toString() != ''
                                              ? data['ingredients'].toString().toLowerCase().contains(futureDocs['allergy3'].toString().toLowerCase()) == true
                                                  ? false
                                                  : true
                                              : true)

                                      // data['ingredients']
                                      //         .toString()
                                      //         .toLowerCase()
                                      //         .contains(futureDocs['allergy1']
                                      //             .toString()
                                      //             .toLowerCase()) ==
                                      //     false &&
                                      // data['ingredients']
                                      //         .toString()
                                      //         .toLowerCase()
                                      //         .contains(futureDocs['allergy2']
                                      //             .toString()
                                      //             .toLowerCase()) ==
                                      //     false &&
                                      // data['ingredients']
                                      //         .toString()
                                      //         .toLowerCase()
                                      //         .contains(futureDocs['allergy3']
                                      //             .toString()
                                      //             .toLowerCase()) ==
                                      //     false
                                      ) {
                                    if (data.id == hideReceipeId) {
                                      return SizedBox.shrink();
                                    } else {
                                      return GestureDetector(
                                        onTap: () {
                                          List<String> myData =
                                              data['weekdays'].cast<String>();
                                          NavigationService().push(
                                            PlansDetailView(
                                              id: data.id,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: context.height * 0.013,
                                            horizontal: context.width * 0.025,
                                          ),
                                          margin: EdgeInsets.only(
                                            bottom: context.height * 0.03,
                                          ),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  25,
                                                ),
                                                child: Image.network(
                                                  data['imageUrl'],
                                                  height: context.height * 0.15,
                                                  width: context.width * 0.28,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(
                                                width: context.width * 0.02,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: context.width * 0.5,
                                                    child: Text(
                                                      data['name'],
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                            fontSize: 14,
                                                          ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        context.height * 0.02,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Protien   ',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            '${data['protiens']}/150',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall,
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                context.width *
                                                                    0.35,
                                                            child: ProgressBar(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      69,
                                                                      173,
                                                                      69,
                                                                      1),
                                                              maxValue: 150,
                                                              value: double
                                                                  .parse(data[
                                                                      'protiens']),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Carbs      ',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            '${data['carbs']}/250',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall,
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                context.width *
                                                                    0.35,
                                                            child: ProgressBar(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      153,
                                                                      63,
                                                                      162,
                                                                      1),
                                                              maxValue: 200,
                                                              value: double
                                                                  .parse(data[
                                                                      'carbs']),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Fat          ',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            '${data['fats']}/250',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall,
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                context.width *
                                                                    0.35,
                                                            child: ProgressBar(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      195,
                                                                      0,
                                                                      1),
                                                              maxValue: 250,
                                                              value: double
                                                                  .parse(data[
                                                                      'fats']),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    return SizedBox();
                                  }
                                } else {
                                  return SizedBox();
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
          ),
        ],
      ),
    );
  }
}
