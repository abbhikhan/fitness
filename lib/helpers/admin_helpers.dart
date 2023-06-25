import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness/services/navigation_service.dart';
import 'package:fitness/views/admin/admin_receipes/admin_list_receipes.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../database/firebase.dart';
import 'shared_helpers.dart';

class AdminHelpers {
  static void addReceipe({
    required BuildContext context,
    required XFile? image,
    required List<String> selectedDays,
    required TextEditingController plantextEditingController,
    required TextEditingController halfDaytextEditingController,
    required TextEditingController nametextEditingController,
    required TextEditingController protienstextEditingController,
    required TextEditingController carbstextEditingController,
    required TextEditingController fatstextEditingController,
    required TextEditingController instructionstextEditingController,
    required TextEditingController ingredientstextEditingController,
    required TextEditingController caloriestextEditingController,
    required TextEditingController timetextEditingController,
    required TextEditingController pricetextEditingController,
  }) async {
    if (image == null) {
      SharedHelpers.textFieldsPopup(text: 'Upload Image');
      return;
    }

    // if (plantextEditingController.text.isEmpty) {
    //   SharedHelpers.textFieldsPopup(text: 'Choose Plan');
    //   return;
    // }

    if (halfDaytextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Choose Halfday');
      return;
    }

    if (selectedDays.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Choose Atleast One Plan');
      return;
    }

    if (nametextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Receipe Name');
      return;
    }

    if (protienstextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Protiens');
      return;
    }

    if (carbstextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Carbs');
      return;
    }

    if (fatstextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Fats');
      return;
    }

    if (instructionstextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Instructions');
      return;
    }

    if (ingredientstextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Ingredients');
      return;
    }
    if (caloriestextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Calories');
      return;
    }

    if (timetextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Time');
      return;
    }

    if (pricetextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Price');
      return;
    }

    try {
      SharedHelpers.textFieldsPopup(text: 'Adding Receipe');

      Reference storageReference = FirebaseAccess.firebaseStorageInstance
          .ref()
          .child(DateTime.now().toString());
      UploadTask uploadTask = storageReference.putFile(File(image.path));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      Future.delayed(
        const Duration(seconds: 1),
        () async {
          await FirebaseEndPoints.adminReceipeCollection.add({
            'dateTime': DateTime.now(),
            'userDateTime': DateTime.now(),
            'imageUrl': imageUrl,
            'plan': selectedDays,
            'halfDay': halfDaytextEditingController.text,
            'weekdays': [],
            'name': nametextEditingController.text,
            'protiens': protienstextEditingController.text,
            'carbs': carbstextEditingController.text,
            'fats': fatstextEditingController.text,
            'instructions': instructionstextEditingController.text,
            'ingredients': ingredientstextEditingController.text,
            'calories': caloriestextEditingController.text,
            'time': timetextEditingController.text,
            'price': pricetextEditingController.text,
          }).catchError((onError) {
            SharedHelpers.textFieldsPopup(text: onError.toString());
          }).then((_) {
            SharedHelpers.textFieldsPopup(text: 'Receipe Added');
            NavigationService().pop();
            NavigationService().pushReplacement(AdminListReceipes());
          });
        },
      );
    } on FirebaseException catch (error) {
      SharedHelpers.textFieldsPopup(text: error.message.toString());
    }
  }

  static void updateReceipe({
    required BuildContext context,
    required String id,
    required String image,
    required List<String> selectedPlan,
    // required TextEditingController plantextEditingController,
    required TextEditingController halfDaytextEditingController,
    required TextEditingController nametextEditingController,
    required TextEditingController protienstextEditingController,
    required TextEditingController carbstextEditingController,
    required TextEditingController fatstextEditingController,
    required TextEditingController instructionstextEditingController,
    required TextEditingController ingredientstextEditingController,
    required TextEditingController caloriestextEditingController,
    required TextEditingController timetextEditingController,
    required TextEditingController pricetextEditingController,
  }) async {
    // if (image == null) {
    //   SharedHelpers.textFieldsPopup(text: 'Upload Image');
    //   return;
    // }

    // if (plantextEditingController.text.isEmpty) {
    //   SharedHelpers.textFieldsPopup(text: 'Choose Plan');
    //   return;
    // }

    if (halfDaytextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Choose Halfday');
      return;
    }

    if (selectedPlan.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Choose Atleast One Plan');
      return;
    }

    if (nametextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Receipe Name');
      return;
    }

    if (protienstextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Protiens');
      return;
    }

    if (carbstextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Carbs');
      return;
    }

    if (fatstextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Fats');
      return;
    }

    if (instructionstextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Instructions');
      return;
    }

    if (ingredientstextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Ingredients');
      return;
    }
    if (caloriestextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Calories');
      return;
    }

    if (timetextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Time');
      return;
    }

    if (pricetextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Price');
      return;
    }

    try {
      SharedHelpers.textFieldsPopup(text: 'Updating Receipe');

      String imageUrl = '';
      if (!image.contains('firebasestorage.googleapis.com')) {
        Reference storageReference = FirebaseAccess.firebaseStorageInstance
            .ref()
            .child(DateTime.now().toString());
        UploadTask uploadTask = storageReference.putFile(File(image));
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        imageUrl = await taskSnapshot.ref.getDownloadURL();
      }

      Future.delayed(
        const Duration(seconds: 1),
        () async {
          await FirebaseEndPoints.adminReceipeCollection.doc(id).update({
            'imageUrl': imageUrl == '' ? image : imageUrl,
            'plan': selectedPlan,
            'halfDay': halfDaytextEditingController.text,
            // 'weekdays': selectedDays,
            'name': nametextEditingController.text,
            'protiens': protienstextEditingController.text,
            'carbs': carbstextEditingController.text,
            'fats': fatstextEditingController.text,
            'instructions': instructionstextEditingController.text,
            'ingredients': ingredientstextEditingController.text,
            'calories': caloriestextEditingController.text,
            'time': timetextEditingController.text,
            'price': pricetextEditingController.text,
          }).catchError((onError) {
            SharedHelpers.textFieldsPopup(text: onError.toString());
          }).then((_) {
            SharedHelpers.textFieldsPopup(text: 'Receipe Updated');
            NavigationService().pop();
            NavigationService().pushReplacement(AdminListReceipes());
          });
        },
      );
    } on FirebaseException catch (error) {
      SharedHelpers.textFieldsPopup(text: error.message.toString());
    }
  }

  static void deleteReceipe({
    required BuildContext context,
    required String documentId,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirmation',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 16,
              ),
        ),
        content: Text(
          'Are you sure you want to delete',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 14,
              ),
        ),
        actions: [
          TextButton(
            child: Text(
              'No',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'Yes',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onPressed: () {
              FirebaseEndPoints.adminReceipeCollection
                  .doc(documentId)
                  .delete()
                  .then((value) {
                SharedHelpers.textFieldsPopup(
                  text: 'Receipe Deleted',
                );
                NavigationService().pushAndRemoveUntil(
                  const AdminListReceipes(),
                );
              }).catchError((error) {
                SharedHelpers.textFieldsPopup(
                  text: error.toString(),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
