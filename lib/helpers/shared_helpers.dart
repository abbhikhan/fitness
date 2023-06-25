import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness/controllers/users_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/firebase.dart';
import '../firebase_options.dart';
import '../services/navigation_service.dart';
import '../views/authentication/authentication_view.dart';

class SharedHelpers {
  static Future<void> initilizeApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseAccess.firebaseAuthInstance = FirebaseAuth.instance;
    FirebaseAccess.firebaseFirestoreInstance = FirebaseFirestore.instance;
    FirebaseAccess.firebaseStorageInstance = FirebaseStorage.instance;
    FirebaseAccess.sharedPreferences = await SharedPreferences.getInstance();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  final List<SingleChildWidget> controllers = [
    ChangeNotifierProvider(
      create: (context) => UsersController(),
    ),
  ];

  static void successPopUp({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
  }) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: text,
      onConfirmBtnTap: onTap,
      barrierDismissible: false,
    );
  }

  static void loadingPopUp({
    required BuildContext context,
    required String text,
  }) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: text,
      text: 'Please Wait',
    );
  }

  static void errorPopUp({
    required BuildContext context,
    required String text,
  }) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: text,
    );
  }

  static void confirmPopUp({
    required BuildContext context,
    required String text,
    required VoidCallback onYes,
  }) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      barrierDismissible: false,
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      title: 'Are you sure?',
      text: text,
      onConfirmBtnTap: onYes,
    );
  }

  static void logout() async {
    final googleSignin = GoogleSignIn();
    final facebookSignin = await FacebookAuth.instance.accessToken;
    SharedHelpers.textFieldsPopup(text: 'Signing out');
    if (await googleSignin.isSignedIn()) {
      await googleSignin.disconnect();
      FirebaseAccess.firebaseAuthInstance.signOut();
      FirebaseAccess.sharedPreferences.clear();
    }
    if (facebookSignin != null) {
      await FacebookAuth.instance.logOut();
      FirebaseAccess.sharedPreferences.clear();
      FirebaseAccess.firebaseAuthInstance.signOut();
    } else {
      FirebaseAccess.sharedPreferences.clear();
      FirebaseAccess.firebaseAuthInstance.signOut();
    }
    Future.delayed(
      const Duration(seconds: 2),
      () {
        NavigationService().pushAndRemoveUntil(const AuthenticationView());
      },
    );
  }

  // static void logout({
  //   required BuildContext context,
  // }) {
  //   confirmPopUp(
  //     context: context,
  //     text: 'Do you want to log out?',
  //     onYes: () async {
  //       NavigationService().pop();
  //       try {
  //         // await FirebaseAccess.firebaseAuthInstance.signOut();
  //         Future.delayed(
  //           Duration.zero,
  //           () {
  //             loadingPopUp(context: context, text: 'Signing out');
  //           },
  //         );
  //         Future.delayed(
  //           const Duration(seconds: 2),
  //           () async {
  //             // await FirebaseAccess.sharedPreferences.clear();
  //             // NavigationService().pushAndRemoveUntil(LoginView());
  //           },
  //         );
  //       } on FirebaseAuthException catch (error) {
  //         String errorMessage =
  //             FirebaseAuthExceptionHandler.getMessage(error.code);
  //         SharedHelpers.errorPopUp(context: context, text: errorMessage);
  //       }
  //     },
  //   );
  // }

  static void textFieldsPopup({
    required String text,
  }) {
    BotToast.showText(
      text: text,
      textStyle: GoogleFonts.montserrat(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Colors.white,
      ),
    );
  }

  // static void firebaseFirestoreStorage({
  //   required BuildContext context,
  //   required VoidCallback method,
  // }) async {
  //   try {
  //     if (!await checkInternetAvailable()) {
  //       NavigationService().pop();
  //       Future.delayed(
  //         Duration.zero,
  //         () {
  //           SharedHelpers.errorPopUp(
  //               context: context, text: 'Internet not available.');
  //         },
  //       );
  //       return;
  //     }

  //     // Future.delayed(
  //     //   Duration.zero,
  //     //   () {
  //         method();
  //       // },
  //     // );
  //   } on SocketException catch (_) {
  //     NavigationService().pop();
  //     SharedHelpers.errorPopUp(
  //         context: context, text: 'Internet not available.');
  //   } on FirebaseException catch (e) {
  //     NavigationService().pop();
  //     String errorMessage = FirebaseAuthExceptionHandler.getMessage(e.code);
  //     SharedHelpers.errorPopUp(context: context, text: errorMessage);
  //   } catch (e) {
  //     NavigationService().pop();
  //     SharedHelpers.errorPopUp(context: context, text: e.toString());
  //   }
  // }

  // static Future<bool> checkInternetAvailable() async {
  //   final connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile ||
  //       connectivityResult == ConnectivityResult.wifi) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
}
