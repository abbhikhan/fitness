import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/extensions/shared_extensions.dart';
import 'package:fitness/helpers/admin_helpers.dart';
import 'package:fitness/helpers/shared_helpers.dart';
import 'package:fitness/views/authentication/login_view.dart';
import 'package:fitness/widgets/scaffold_widget.dart';
import 'package:flutter/material.dart';

import '../../../database/firebase.dart';
import '../../../services/navigation_service.dart';
import '../../../widgets/text_field_widget.dart';
import 'admin_add_receipes.dart';
import 'admin_edit_receipes.dart';

class AdminListReceipes extends StatefulWidget {
  const AdminListReceipes({super.key});

  @override
  State<AdminListReceipes> createState() => _AdminListReceipesState();
}

class _AdminListReceipesState extends State<AdminListReceipes> {
  final TextEditingController searchTextEditingController =
      TextEditingController();
  List<QueryDocumentSnapshot<Object?>>? filteredData;
  QuerySnapshot? snapshotData;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ScaffoldWidget(
        useSingleChildScrollView: true,
        useCustomPadding: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: context.height * 0.05,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  SharedHelpers.logout();
                },
                child: const Icon(
                  Icons.logout,
                ),
              ),
            ),
            SizedBox(
              height: context.height * 0.03,
            ),
            TextFieldWidget(
              hintText: 'Search',
              onChanged: (value) {
                setState(() {
                  filteredData = snapshotData?.docs.where((data) {
                    final email = data['name'] as String;
                    return email.toLowerCase().contains(value.toLowerCase());
                  }).toList();
                });
              },
            ),
            SizedBox(
              height: context.height * 0.03,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  NavigationService().push(const AdminAddReceipes());
                },
                style: ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(
                    Size(context.width * 0.3, context.height * 0.05),
                  ),
                ),
                child: Text(
                  'Add Receipe',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                ),
              ),
            ),
            FutureBuilder(
                future: FirebaseEndPoints.adminReceipeCollection
                    .orderBy(
                      'dateTime',
                      descending: true,
                    )
                    .get(),
                builder: (context, snapshot) {
                  snapshotData = snapshot.data;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      children: [
                        SizedBox(
                          height: context.height * 0.3,
                        ),
                        const Center(child: CircularProgressIndicator()),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    if (snapshot.error is SocketException) {
                      return const Text('No internet connection.');
                    } else {
                      return Text('An error occurred: ${snapshot.error}');
                    }
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredData?.length ??
                          snapshotData?.docs.length ??
                          0,
                      itemBuilder: (context, index) {
                        final data =
                            filteredData?[index] ?? snapshotData?.docs[index];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(data!['imageUrl']),
                            backgroundColor: Colors.pink.shade100,
                          ),
                          title: Text(
                            data['name'],
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 16,
                                ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  AdminHelpers.deleteReceipe(
                                    context: context,
                                    documentId: data.id,
                                  );
                                },
                                child: const Icon(
                                  Icons.delete_forever,
                                ),
                              ),
                              SizedBox(
                                width: context.width * 0.06,
                              ),
                              GestureDetector(
                                onTap: () {
                                  // List<String> myData = [];
                                  // data['weekdays'].forEach((element) {
                                  //   myData.add(element.toString());
                                  // });
                                  List<String> myData =
                                      data['weekdays'].cast<String>();
                                  List<String> myPlan =
                                      data['plan'].cast<String>();
                                  NavigationService().push(
                                    AdminEditReceipes(
                                      receipeId: data.id,
                                      intialimage: data['imageUrl'],
                                      intialselectedDays: myData,
                                      intialplan: myPlan,
                                      intialhalfDay: data['halfDay'],
                                      intialname: data['name'],
                                      intialprotiens: data['protiens'],
                                      intialcarbs: data['carbs'],
                                      intialfats: data['fats'],
                                      intialinstructions: data['instructions'],
                                      intialingredients: data['ingredients'],
                                      intialcalories: data['calories'],
                                      intialtime: data['time'],
                                      intialprice: data['price'],
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.edit,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Text('No data available.');
                  }
                }),
            // ListView.builder(
            //   shrinkWrap: true,
            //   itemBuilder: (context, index) {
            //     return ListTile(
            //       leading: CircleAvatar(
            //         backgroundColor: Colors.pink.shade100,
            //       ),
            //       title: Text(
            //         'Cream Bowl',
            //         style: Theme.of(context).textTheme.bodyMedium,
            //       ),
            //       trailing: Icon(
            //         Icons.delete_forever,

            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
