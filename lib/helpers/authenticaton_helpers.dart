import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/extensions/shared_extensions.dart';
import 'package:fitness/views/admin/admin_receipes/admin_list_receipes.dart';
import 'package:fitness/views/user_information/user_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../database/firebase.dart';
import '../database/firebase_exceptions.dart';
import '../services/navigation_service.dart';
import '../views/authentication/login_view.dart';
import 'shared_helpers.dart';

class AuthenticationHelpers {
  static void loginUser({
    required BuildContext context,
    required TextEditingController emailTextEditingController,
    required TextEditingController paswordTextEditingController,
  }) async {
    if (emailTextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Email');
      return;
    }

    if (!emailTextEditingController.text.isValidEmail) {
      SharedHelpers.textFieldsPopup(text: 'Enter Valid Email');
      return;
    }

    if (paswordTextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Password');
      return;
    }

    SharedHelpers.textFieldsPopup(text: 'Signing in');
    try {
      final List<String> signInMethods = await FirebaseAccess
          .firebaseAuthInstance
          .fetchSignInMethodsForEmail(emailTextEditingController.text);
      bool isGoogleUser = signInMethods.contains('google.com');
      if (isGoogleUser) {
        SharedHelpers.textFieldsPopup(text: 'Continue with google');
        return;
      }
      bool isFacebookUser = signInMethods.contains('facebook.com');
      if (isFacebookUser) {
        SharedHelpers.textFieldsPopup(text: 'Continue with Facebook');
        return;
      }
    } on FirebaseAuthException catch (error) {
      String errorMessage = FirebaseAuthExceptionHandler.getMessage(error.code);
      SharedHelpers.textFieldsPopup(text: errorMessage);
    }
    try {
      final UserCredential userCredential =
          (await FirebaseAccess.firebaseAuthInstance.signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: paswordTextEditingController.text,
      ));
      if (userCredential.user != null) {
        final DocumentReference docRef = FirebaseAccess
            .firebaseFirestoreInstance
            .collection(FirebaseCollectionNames.userCollection)
            .doc(userCredential.user?.uid);

        final DocumentSnapshot docSnap = await docRef.get();

        if (docSnap.exists) {
          Future.delayed(
            Duration.zero,
            () {
              FirebaseAccess.sharedPreferences.setString('userType', 'user');
              NavigationService().pushAndRemoveUntil(
                const UserInformation(),
              );
            },
          );
        } else {
          Future.delayed(
            Duration.zero,
            () {
              FirebaseAccess.sharedPreferences.setString('userType', 'admin');
              NavigationService().pushAndRemoveUntil(
                const AdminListReceipes(),
              );
            },
          );
        }
      }
    } on FirebaseAuthException catch (error) {
      FirebaseAccess.firebaseAuthInstance.signOut();
      String errorMessage = FirebaseAuthExceptionHandler.getMessage(error.code);
      SharedHelpers.textFieldsPopup(text: errorMessage);
    }
  }

  static void forgetPassword({
    required BuildContext context,
    required TextEditingController emailTextEditingController,
  }) async {
    if (emailTextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Email');
      return;
    }

    if (!emailTextEditingController.text.isValidEmail) {
      SharedHelpers.textFieldsPopup(text: 'Enter Valid Email');
      return;
    }

    Future.delayed(
      Duration.zero,
      () {
        SharedHelpers.textFieldsPopup(text: 'Sending Mail');
      },
    );

    try {
      await FirebaseAccess.firebaseAuthInstance
          .sendPasswordResetEmail(email: emailTextEditingController.text);
      Future.delayed(
        Duration.zero,
        () {
          SharedHelpers.textFieldsPopup(
              text: 'Check your inbox/spam folder to recover password');
        },
      );
    } on FirebaseAuthException catch (error) {
      String errorMessage = FirebaseAuthExceptionHandler.getMessage(error.code);
      SharedHelpers.textFieldsPopup(text: errorMessage);
    }
  }

  static void createUser({
    required BuildContext context,
    required TextEditingController emailTextEditingController,
    required TextEditingController paswordTextEditingController,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (emailTextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Email');
      return;
    }

    if (!emailTextEditingController.text.isValidEmail) {
      SharedHelpers.textFieldsPopup(text: 'Enter Valid Email');
      return;
    }

    if (paswordTextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Password');
      return;
    }

    SharedHelpers.textFieldsPopup(text: 'Creating Account');
    try {
      final List<String> signInMethods = await FirebaseAccess
          .firebaseAuthInstance
          .fetchSignInMethodsForEmail(emailTextEditingController.text);
      bool isGoogleUser = signInMethods.contains('google.com');
      if (isGoogleUser) {
        SharedHelpers.textFieldsPopup(text: 'Continue with google');
        return;
      }
      bool isFacebookUser = signInMethods.contains('facebook.com');
      if (isFacebookUser) {
        SharedHelpers.textFieldsPopup(text: 'Continue with Facebook');
        return;
      }
    } on FirebaseAuthException catch (error) {
      String errorMessage = FirebaseAuthExceptionHandler.getMessage(error.code);
      SharedHelpers.textFieldsPopup(text: errorMessage);
    }

    try {
      final UserCredential userCredential = (await FirebaseAccess
          .firebaseAuthInstance
          .createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: paswordTextEditingController.text,
      ));

      if (userCredential.user != null) {
        await FirebaseEndPoints.userCollection
            .doc(userCredential.user?.uid)
            .set({
          'id': userCredential.user?.uid,
          'email': emailTextEditingController.text,
          'password': paswordTextEditingController.text,
        }).catchError((onError) {
          FirebaseAccess.firebaseAuthInstance.signOut();
          SharedHelpers.textFieldsPopup(text: onError.toString());
        }).then((_) {
          FirebaseAccess.firebaseAuthInstance.signOut();
          emailTextEditingController.clear();
          paswordTextEditingController.clear();
          SharedHelpers.textFieldsPopup(
            text: 'Account Created',
          );
          NavigationService().pushReplacement(LoginView());
        });
      }
    } on FirebaseAuthException catch (error) {
      print(error.message);
      FirebaseAccess.firebaseAuthInstance.signOut();
      String errorMessage = FirebaseAuthExceptionHandler.getMessage(error.code);
      SharedHelpers.textFieldsPopup(text: errorMessage);
    }
  }

  static void ggoogleSignIn({
    required BuildContext context,
  }) async {
    final googleSignin = GoogleSignIn();
    GoogleSignInAccount user;

    final googleUser = await googleSignin.signIn();
    if (googleUser == null) return;
    user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      final List<String> signInMethods = await FirebaseAccess
          .firebaseAuthInstance
          .fetchSignInMethodsForEmail(user.email);
      bool isPasswordUser = signInMethods.contains('password');
      if (isPasswordUser) {
        await googleSignin.disconnect();
        SharedHelpers.textFieldsPopup(text: 'Continue with Email & Password');
        return;
      }
      bool isFacebookUser = signInMethods.contains('facebook.com');
      if (isFacebookUser) {
        await googleSignin.disconnect();
        SharedHelpers.textFieldsPopup(text: 'Continue with Facebook');
        return;
      }
    } on FirebaseAuthException catch (error) {
      String errorMessage = FirebaseAuthExceptionHandler.getMessage(error.code);
      SharedHelpers.textFieldsPopup(text: errorMessage);
    }
    try {
      final UserCredential userCredential = await FirebaseAccess
          .firebaseAuthInstance
          .signInWithCredential(credential);

      if (userCredential.user != null) {
        await FirebaseEndPoints.userCollection
            .doc(userCredential.user?.uid)
            .set({
          'id': userCredential.user?.uid,
          'email': user.email,
        }).catchError((onError) async {
          await googleSignin.disconnect();
          FirebaseAccess.firebaseAuthInstance.signOut();
          SharedHelpers.textFieldsPopup(text: onError.toString());
        }).then((_) {
          Future.delayed(
            Duration.zero,
            () {
              FirebaseAccess.sharedPreferences.setString('userType', 'user');
              NavigationService().pushAndRemoveUntil(
                const UserInformation(),
              );
            },
          );
        });
      }
    } on FirebaseAuthException catch (error) {
      await googleSignin.disconnect();
      FirebaseAccess.firebaseAuthInstance.signOut();
      String errorMessage = FirebaseAuthExceptionHandler.getMessage(error.code);
      SharedHelpers.textFieldsPopup(text: errorMessage);
    }
  }

  static void facebookSign({
    required BuildContext context,
  }) async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();

      // userData.forEach((key, value) {
      //   print(key);
      // });
      final List<String> signInMethods = await FirebaseAccess
          .firebaseAuthInstance
          .fetchSignInMethodsForEmail(userData['email']);
      bool isPasswordUser = signInMethods.contains('password');
      if (isPasswordUser) {
        await FacebookAuth.instance.logOut();
        SharedHelpers.textFieldsPopup(text: 'Continue with Email & Password');
        return;
      }
      bool isGoogleUser = signInMethods.contains('google.com');
      if (isGoogleUser) {
        await FacebookAuth.instance.logOut();
        SharedHelpers.textFieldsPopup(text: 'Continue with google');
        return;
      }

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      // https://fitness-mob-app.firebaseapp.com/__/auth/handler

      try {
        final UserCredential userCredential = await FirebaseAccess
            .firebaseAuthInstance
            .signInWithCredential(facebookAuthCredential);

        if (userCredential.user != null) {
          await FirebaseEndPoints.userCollection
              .doc(userCredential.user?.uid)
              .set({
            'id': userCredential.user?.uid,
            'email': userData['email'],
          }).catchError((onError) async {
            await FacebookAuth.instance.logOut();
            FirebaseAccess.firebaseAuthInstance.signOut();
            SharedHelpers.textFieldsPopup(text: onError.toString());
          }).then((_) {
            Future.delayed(
              Duration.zero,
              () {
                FirebaseAccess.sharedPreferences.setString('userType', 'user');
                NavigationService().pushAndRemoveUntil(
                  const UserInformation(),
                );
              },
            );
          });
        }
      } on FirebaseAuthException catch (error) {
        await FacebookAuth.instance.logOut();
        FirebaseAccess.firebaseAuthInstance.signOut();
        String errorMessage =
            FirebaseAuthExceptionHandler.getMessage(error.code);
        SharedHelpers.textFieldsPopup(text: errorMessage);
      }
    } else {
      print(result.message);
    }
  }
}
