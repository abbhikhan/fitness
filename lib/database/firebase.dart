import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAccess {
  static late FirebaseAuth firebaseAuthInstance;
  static late FirebaseFirestore firebaseFirestoreInstance;
  static late FirebaseStorage firebaseStorageInstance;
  static late SharedPreferences sharedPreferences;
}

class FirebaseEndPoints {
  static final userCollection = FirebaseAccess.firebaseFirestoreInstance
      .collection(FirebaseCollectionNames.userCollection);

  static final userReceipeCollection = FirebaseAccess.firebaseFirestoreInstance
      .collection(FirebaseCollectionNames.userReceipeCollection);

  static final adminReceipeCollection = FirebaseAccess.firebaseFirestoreInstance
      .collection(FirebaseCollectionNames.adminReceipeCollection);      

  // static final teacherCollectionById = FirebaseAccess.firebaseFirestoreInstance
  //     .collection(FirebaseCollectionNames.teacherCollection)
  //     .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid);

  // static final teacherSubjectCollection = FirebaseAccess
  //     .firebaseFirestoreInstance
  //     .collection(FirebaseCollectionNames.teacherCollection)
  //     .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
  //     .collection(FirebaseCollectionNames.teacherSubjectCollection);

  // static final teacherQuizCollection = FirebaseAccess.firebaseFirestoreInstance
  //     .collection(FirebaseCollectionNames.teacherCollection)
  //     .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
  //     .collection(FirebaseCollectionNames.teacherQuizCollection);

  // static final teacherViewStudentQuizCollection = FirebaseAccess
  //     .firebaseFirestoreInstance
  //     .collectionGroup(FirebaseCollectionNames.studentQuizCollection);

  // static final studentCollection = FirebaseAccess.firebaseFirestoreInstance
  //     .collection(FirebaseCollectionNames.studentCollection);

  // static final studentQuizCollection = FirebaseAccess.firebaseFirestoreInstance
  //     .collection(FirebaseCollectionNames.studentCollection)
  //     .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
  //     .collection(FirebaseCollectionNames.studentQuizCollection);

  // static final studentDirectQuizCollection = FirebaseAccess
  //     .firebaseFirestoreInstance
  //     .collectionGroup(FirebaseCollectionNames.studentQuizCollection);      

  // static final teacherQuizCollectionGroup = FirebaseAccess
  //     .firebaseFirestoreInstance
  //     .collectionGroup(FirebaseCollectionNames.teacherQuizCollection);

}

class FirebaseCollectionNames {
  static String userCollection = 'userCollection';
  static String userReceipeCollection = 'userReceipeCollection';
  static String adminReceipeCollection = 'adminReceipeCollection';
}
