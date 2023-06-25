import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/views/authentication/authentication_view.dart';
import 'package:provider/provider.dart';

import 'package:fitness/controllers/users_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../database/firebase.dart';
import '../services/navigation_service.dart';
import '../views/user/home/home_view.dart';
import 'shared_helpers.dart';

class UserHelpers {
  static void makePayment({
    required BuildContext context,
    required String amount,
    required String type,
  }) async {
    Map<String, dynamic>? paymentIntent;
    try {
      paymentIntent = await createPaymentIntent(
        amount: amount,
      );

      var gpay = const PaymentSheetGooglePay(
        merchantCountryCode: "CZ",
        currencyCode: "EUR",
        testEnv: true,
      );
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!["client_secret"],
        style: ThemeMode.light,
        merchantDisplayName: "Test",
        googlePay: gpay,
      ));

      Future.delayed(
        Duration.zero,
        () {
          displayPaymentSheet(
            context: context,
            amount: amount,
            type: type,
          );
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> displayPaymentSheet({
    required BuildContext context,
    required String amount,
    required String type,
  }) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      Future.delayed(
        Duration.zero,
        () {
          context.read<UsersController>().paymentStatus = true;
        },
      );
      Future.delayed(
        Duration.zero,
        () {
          context.read<UsersController>().amount = amount;
          context.read<UsersController>().type = type;
        },
      );
    } catch (e) {
      print("Failed");
    }
  }

  static createPaymentIntent({
    required String amount,
  }) async {
    try {
      final totalAmount = '${amount}00';
      Map<String, dynamic> body = {
        "amount": totalAmount,
        "currency": "EUR",
      };

      http.Response response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization":
                "Bearer sk_test_51N2Q82FfIlC0deje2qwaxF9fLBeCI0H2quy1b7eEYUEYfQw7Um1QBSV5D17b2yYabs85oMuI1YsKHyZrQhGltylK00CdP5X2uH",
            "Content-Type": "application/x-www-form-urlencoded",
          });
      return json.decode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static void userInformation({
    required BuildContext context,
    required bool isUpdating,
    required TextEditingController morningWeightTextEditingController,
    required String weightGoal,
    required String mealsPerDay,
    required TextEditingController breakfastTextEditingController,
    required TextEditingController lunchTextEditingController,
    required TextEditingController dinnerTextEditingController,
    required TextEditingController snackTextEditingController,
    required TextEditingController snack2TextEditingController,
    required TextEditingController amountTextEditingController,
    required TextEditingController allergy1TextEditingController,
    required TextEditingController allergy2TextEditingController,
    required TextEditingController allergy3TextEditingController,
    required bool paymentStatus,
    required String amount,
    required String type,
  }) async {
    // breakfastTextEditingController.text.replaceAll('min', '').trim();
    // lunchTextEditingController.text.replaceAll('min', '').trim();
    // dinnerTextEditingController.text.replaceAll('min', '').trim();
    // snackTextEditingController.text.replaceAll('min', '').trim();
    // snackTextEditingController.text.replaceAll('min', '').trim();
// // context.read<UsersController>().paymentStatus
//     if (morningWeightTextEditingController.text.isEmpty) {
//       SharedHelpers.textFieldsPopup(text: 'Enter M');
//       return;
//     }

//     if (breakfastTextEditingController.text.isEmpty) {
//       SharedHelpers.textFieldsPopup(text: 'Enter Email');
//       return;
//     }
//     if (lunchTextEditingController.text.isEmpty) {
//       SharedHelpers.textFieldsPopup(text: 'Enter Email');
//       return;
//     }
//     if (dinnerTextEditingController.text.isEmpty) {
//       SharedHelpers.textFieldsPopup(text: 'Enter Email');
//       return;
//     }
//     if (snackTextEditingController.text.isEmpty) {
//       SharedHelpers.textFieldsPopup(text: 'Enter Email');
//       return;
//     }
//     if (snack2TextEditingController.text.isEmpty) {
//       SharedHelpers.textFieldsPopup(text: 'Enter Email');
//       return;
//     }
//     if (amountTextEditingController.text.isEmpty) {
//       SharedHelpers.textFieldsPopup(text: 'Enter Email');
//       return;
//     }
//     if (allergy1TextEditingController.text.isEmpty) {
//       SharedHelpers.textFieldsPopup(text: 'Enter Email');
//       return;
//     }
//     if (allergy2TextEditingController.text.isEmpty) {
//       SharedHelpers.textFieldsPopup(text: 'Enter Email');
//       return;
//     }
//     if (allergy3TextEditingController.text.isEmpty) {
//       SharedHelpers.textFieldsPopup(text: 'Enter Email');
//       return;
//     }

    if (isUpdating) {
      try {
        await FirebaseEndPoints.userCollection
            .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
            .update({
          'morningWeight': morningWeightTextEditingController.text,
          'weightGoal': weightGoal,
          'mealsPerDay': mealsPerDay,
          'breakfast': breakfastTextEditingController.text,
          'lunch': lunchTextEditingController.text,
          'dinner': dinnerTextEditingController.text,
          'snack': snackTextEditingController.text,
          'snack2': snack2TextEditingController.text,
          'amount': amountTextEditingController.text,
          'allergy1': allergy1TextEditingController.text,
          'allergy2': allergy2TextEditingController.text,
          'allergy3': allergy3TextEditingController.text,
          'weightAddedDateTime': FieldValue.serverTimestamp(),
          'weightCount': 0,
          'paymentStatus': paymentStatus,
        }).catchError((onError) {
          SharedHelpers.textFieldsPopup(text: onError.toString());
        }).then((_) {
          Future.delayed(
            Duration.zero,
            () {
              context.read<UsersController>().paymentStatus = false;
              context.read<UsersController>().amount = '';
              context.read<UsersController>().type = '';
            },
          );
          FirebaseAccess.sharedPreferences.setString('userInformation', 'true');
          NavigationService().pushAndRemoveUntil(const HomeView());
        });
      } on FirebaseException catch (error) {
        SharedHelpers.textFieldsPopup(text: error.message.toString());
      }
    } else {
      if (paymentStatus == false) {
        SharedHelpers.textFieldsPopup(text: 'Choose pricing plan');
        return;
      }

      try {
        await FirebaseEndPoints.userCollection
            .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
            .update({
          'morningWeight': morningWeightTextEditingController.text,
          'weightGoal': weightGoal,
          'mealsPerDay': mealsPerDay,
          'breakfast': breakfastTextEditingController.text,
          'lunch': lunchTextEditingController.text,
          'dinner': dinnerTextEditingController.text,
          'snack': snackTextEditingController.text,
          'snack2': snack2TextEditingController.text,
          'amount': amountTextEditingController.text,
          'allergy1': allergy1TextEditingController.text,
          'allergy2': allergy2TextEditingController.text,
          'allergy3': allergy3TextEditingController.text,
          'paymentStatus': paymentStatus,
          'paidAmount': amount,
          'paidType': type,
          'weightAddedDateTime': FieldValue.serverTimestamp(),
          'weightCount': 0,
          'paidDateTime': DateTime.now(),
        }).catchError((onError) {
          SharedHelpers.textFieldsPopup(text: onError.toString());
        }).then((_) {
          Future.delayed(
            Duration.zero,
            () {
              context.read<UsersController>().paymentStatus = false;
              context.read<UsersController>().amount = '';
              context.read<UsersController>().type = '';
            },
          );
          FirebaseAccess.sharedPreferences.setString('userInformation', 'true');
          NavigationService().pushAndRemoveUntil(const HomeView());
        });
      } on FirebaseException catch (error) {
        SharedHelpers.textFieldsPopup(text: error.message.toString());
      }
    }
  }

  static void updateUserInformation({
    required BuildContext context,
    required TextEditingController morningWeightTextEditingController,
    required String oldMorningWeight,
    required String weightGoal,
    required String mealsPerDay,
    required TextEditingController breakfastTextEditingController,
    required TextEditingController lunchTextEditingController,
    required TextEditingController dinnerTextEditingController,
    required TextEditingController snackTextEditingController,
    required TextEditingController snack2TextEditingController,
    required TextEditingController amountTextEditingController,
    required TextEditingController allergy1TextEditingController,
    required TextEditingController allergy2TextEditingController,
    required TextEditingController allergy3TextEditingController,
  }) async {
    int weightCount = 0;
    if (oldMorningWeight != morningWeightTextEditingController.text) {
      weightCount = 1;
    }
    if (morningWeightTextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Morning Weight');
      return;
    }

    if (breakfastTextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Breakfast Time');
      return;
    }
    if (lunchTextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Lunch Time');
      return;
    }
    if (dinnerTextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Dinner Time');
      return;
    }
    if (snackTextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Snack Time');
      return;
    }
    if (snack2TextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Snack 2 Time');
      return;
    }
    if (amountTextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Daily Budget');
      return;
    }
    // if (allergy1TextEditingController.text.isEmpty) {
    //   SharedHelpers.textFieldsPopup(text: 'Enter Allergy 1');
    //   return;
    // }
    // if (allergy2TextEditingController.text.isEmpty) {
    //   SharedHelpers.textFieldsPopup(text: 'Enter Allergy 2');
    //   return;
    // }
    // if (allergy3TextEditingController.text.isEmpty) {
    //   SharedHelpers.textFieldsPopup(text: 'Enter Allergy 3');
    //   return;
    // }

    try {
      SharedHelpers.textFieldsPopup(text: 'Updating');
      await FirebaseEndPoints.userCollection
          .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
          .update({
        'morningWeight': morningWeightTextEditingController.text,
        'weightGoal': weightGoal,
        'mealsPerDay': mealsPerDay,
        'breakfast': breakfastTextEditingController.text,
        'lunch': lunchTextEditingController.text,
        'dinner': dinnerTextEditingController.text,
        'snack': snackTextEditingController.text,
        'snack2': snack2TextEditingController.text,
        'amount': amountTextEditingController.text,
        'allergy1': allergy1TextEditingController.text,
        'allergy2': allergy2TextEditingController.text,
        'allergy3': allergy3TextEditingController.text,
        'weightCount': weightCount,
      }).catchError((onError) {
        SharedHelpers.textFieldsPopup(text: onError.toString());
      }).then((_) {
        SharedHelpers.textFieldsPopup(text: 'Updated');
      });
    } on FirebaseException catch (error) {
      SharedHelpers.textFieldsPopup(text: error.message.toString());
    }
  }

  static Future<bool> updateReceipeWeekDays({
    required BuildContext context,
    required String weekDayName,
    required String recepieId,
    required String protien,
    required String carbs,
    required String fat,
    required String amount,
    required String calorie,
    required String halfDay,
  }) async {
    // try {
    final documentReference = FirebaseEndPoints.userCollection
        .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
        .collection(FirebaseCollectionNames.userReceipeCollection)
        // .where('receipeId', isEqualTo: recepieId)
        .where('halfDay', isEqualTo: halfDay);
    // .where('weekdays', arrayContains: weekDayName);

    final querySnapshot = await documentReference.get();
    if (querySnapshot.docs.isNotEmpty) {
      bool thirdTime = true;
      for (var element in querySnapshot.docs) {
        if (element.get('receipeId') == recepieId) {
          thirdTime = false;
          if (!element.get('weekdays').asMap().values.contains(weekDayName)) {
            await element.reference.update({
              'weekdays': FieldValue.arrayUnion([weekDayName]),
              'userDateTime': FieldValue.serverTimestamp(),
            });
          }
        }
      }
      FirebaseEndPoints.userCollection
          .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
          .collection(FirebaseCollectionNames.userReceipeCollection)
          .get()
          .then((value) async {
        for (var element in value.docs) {
          if (element.get('receipeId') != recepieId) {
            if (element.get('weekdays').asMap().values.contains(weekDayName)) {
              await element.reference.update({
                'weekdays': FieldValue.arrayRemove([weekDayName]),
              });
            }
          }
        }
      });
      // FirebaseEndPoints.userCollection
      //     .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
      //     .collection(FirebaseCollectionNames.userReceipeCollection)
      //     .get()
      //     .then((value) async {
      //   for (var element in value.docs) {
      //     if (element.get('receipeId') != recepieId) {
      //       print(element.get('weekdays'));
      //       if (element.get('weekdays').asMap().isEmpty) {
      //         element.reference.delete();
      //       }
      //     }
      //   }
      // });
      if (thirdTime == true) {
        await FirebaseEndPoints.userCollection
            .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
            .collection(FirebaseCollectionNames.userReceipeCollection)
            .add({
          'receipeId': recepieId,
          'weekdays': FieldValue.arrayUnion([weekDayName]),
          'userDateTime': FieldValue.serverTimestamp(),
          'protien': protien,
          'carbs': carbs,
          'fat': fat,
          'amount': amount,
          'calorie': calorie,
          'halfDay': halfDay,
        });

        // FirebaseEndPoints.userCollection
        //     .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
        //     .collection(FirebaseCollectionNames.userReceipeCollection)
        //     .get()
        //     .then((value) async {
        //   for (var element in value.docs) {
        //     if (element.get('receipeId') != recepieId) {
        //       if (element
        //           .get('weekdays')
        //           .asMap()
        //           .values
        //           .contains(weekDayName)) {
        //         await element.reference.update({
        //           'weekdays': FieldValue.arrayRemove([weekDayName]),
        //         });
        //       }
        //     }
        //   }
        // });

        // FirebaseEndPoints.userCollection
        //     .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
        //     .collection(FirebaseCollectionNames.userReceipeCollection)
        //     .get()
        //     .then((value) async {
        //   for (var element in value.docs) {
        //     if (element.get('receipeId') != recepieId) {
        //       if (element.get('weekdays').asMap().isEmpty) {
        //         element.reference.delete();
        //       }
        //     }
        //   }
        // });

        //
        //
        // FirebaseEndPoints.userCollection
        //     .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
        //     .collection(FirebaseCollectionNames.userReceipeCollection)
        //     .doc(element.id)
        //     .get()
        //     .then((value) {
        //   if (value.get('weekdays').asMap().isEmpty) {
        //     value.reference.delete();
        //   }
        // });
      }
      // FirebaseEndPoints.userCollection
      //     .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
      //     .collection(FirebaseCollectionNames.userReceipeCollection)
      //     .doc(element.id)
      //     .get()
      //     .then((value) {
      //   if (value.get('weekdays').asMap().isEmpty) {
      //     value.reference.delete();
      //   }
      // });
      // }
      // await FirebaseEndPoints.userCollection
      //     .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
      //     .collection(FirebaseCollectionNames.userReceipeCollection)
      //     .add({
      //   'receipeId': recepieId,
      //   'weekdays': FieldValue.arrayUnion([weekDayName]),
      //   'userDateTime': FieldValue.serverTimestamp(),
      //   'protien': protien,
      //   'carbs': carbs,
      //   'fat': fat,
      //   'amount': amount,
      //   'calorie': calorie,
      //   'halfDay': halfDay,
      // });
      // SharedHelpers.textFieldsPopup(text: 'Day Added');
      return true;

      // final documentSnapshot = querySnapshot.docs.first;

      // if (documentSnapshot
      //     .get('weekdays')
      //     .asMap()
      //     .values
      //     .contains(weekDayName)) {
      //   await documentSnapshot.reference.update({
      //     'weekdays': FieldValue.arrayRemove([weekDayName]),
      //   });
      //   SharedHelpers.textFieldsPopup(text: 'Day Removed');
      //   return true;
      // } else {
      //   await documentSnapshot.reference.update({
      //     'weekdays': FieldValue.arrayUnion([weekDayName]),
      //     'userDateTime': FieldValue.serverTimestamp(),
      //     'protien': protien,
      //     'carbs': carbs,
      //     'fat': fat,
      //     'amount': amount,
      //     'calorie': calorie,
      //     'halfDay': halfDay,
      //   });
      //   SharedHelpers.textFieldsPopup(text: 'Day Added');
      //   return true;
      // }
    } else {
      await FirebaseEndPoints.userCollection
          .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
          .collection(FirebaseCollectionNames.userReceipeCollection)
          .add({
        'receipeId': recepieId,
        'weekdays': FieldValue.arrayUnion([weekDayName]),
        'userDateTime': FieldValue.serverTimestamp(),
        'protien': protien,
        'carbs': carbs,
        'fat': fat,
        'amount': amount,
        'calorie': calorie,
        'halfDay': halfDay,
      });
      return true;
    }

    // final DocumentSnapshot snapshot = await FirebaseEndPoints.userReceipeCollection
    //     .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
    //     .get();

    // if (snapshot.exists) {
    // List<dynamic> listt = snapshot.get('forSorting');
    // for (var element in listt) {
    //   print(element);
    //   // if (element['weekDays'].asMap().values.contains(weekDayName)) {
    //   //   print('object');
    //   // } else {
    //   //   print('no');
    //   // }
    // }
    // final asTheMap = listt as Map<String, dynamic>;
    // print(asTheMap);
    // if (listt.asMap().values.contains(weekDayName)) {
    // await FirebaseEndPoints.adminReceipeCollection.doc(recepieId).update({
    //   'weekdays': FieldValue.arrayRemove([weekDayName]),
    // });
    // SharedHelpers.textFieldsPopup(text: 'Day Removed');
    // return true;
    // } else {
    // await FirebaseEndPoints.adminReceipeCollection.doc(recepieId).update({
    //   'weekdays': FieldValue.arrayUnion([weekDayName]),
    //   'userDateTime': FieldValue.serverTimestamp(),
    // });
    // SharedHelpers.textFieldsPopup(text: 'Day added');
    // return true;

    // await FirebaseEndPoints.userCollection
    //     .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
    //     .collection(FirebaseCollectionNames.userReceipeCollection)
    //     .add({
    //   'receipeId': recepieId,
    //   'week': FieldValue.arrayUnion([weekDayName]),
    // });

    // await FirebaseEndPoints.userReceipeCollection
    //     .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
    //     .set({
    //   'recipe': {
    //     'id': FieldValue.arrayUnion([recepieId]),
    //     'week': FieldValue.arrayUnion([weekDayName]),
    //   }
    //   // 'userDateTime': FieldValue.serverTimestamp(),
    // });
    // SharedHelpers.textFieldsPopup(text: 'Day added');
    // return true;
    // }
    // } else {
    //   return false;
    // }
    // } on FirebaseException catch (error) {
    //   SharedHelpers.textFieldsPopup(text: error.message.toString());
    // }
  }

  static void updateUserWeight({
    required BuildContext context,
    required TextEditingController textEditingController,
  }) async {
    try {
      if (textEditingController.text.isEmpty) {
        SharedHelpers.textFieldsPopup(text: 'Enter Weight');
        return;
      }
      final DocumentSnapshot snapshot = await FirebaseEndPoints.userCollection
          .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
          .get();

      if (snapshot.exists) {
        await FirebaseEndPoints.userCollection
            .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
            .update({
          'weightAddedDateTime': FieldValue.serverTimestamp(),
          'morningWeight': textEditingController.text,
          'weightCount': 0,
        });
        SharedHelpers.textFieldsPopup(text: 'Weight Updated');
        NavigationService().pushAndRemoveUntil(HomeView());
      }
    } on FirebaseException catch (error) {
      SharedHelpers.textFieldsPopup(text: error.message.toString());
    }
  }

  static void updatePayment({
    required BuildContext context,
    required bool paymentStatus,
    required String paidAmount,
    required String paidType,
  }) async {
    try {
      if (paymentStatus == false) {
        SharedHelpers.textFieldsPopup(text: 'Buy a plan');
        return;
      }
      final DocumentSnapshot snapshot = await FirebaseEndPoints.userCollection
          .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
          .get();

      if (snapshot.exists) {
        await FirebaseEndPoints.userCollection
            .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
            .update({
          'paymentStatus': paymentStatus,
          'paidAmount': paidAmount,
          'paidType': paidType,
          'paidDateTime': FieldValue.serverTimestamp(),
        });
        NavigationService().pushAndRemoveUntil(HomeView());
      }
    } on FirebaseException catch (error) {
      SharedHelpers.textFieldsPopup(text: error.message.toString());
    }
  }
}
