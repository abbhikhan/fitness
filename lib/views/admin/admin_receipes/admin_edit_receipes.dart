import 'dart:io';

import 'package:fitness/extensions/shared_extensions.dart';
import 'package:fitness/helpers/admin_helpers.dart';
import 'package:fitness/widgets/scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:image_picker/image_picker.dart';

import '../../../widgets/selectable_dropdown_widget.dart';
import '../../../widgets/text_field_widget.dart';

final List<String> plan = [
  'Daily',
  'Weekly',
];

final List<String> unTypes = [
  'Breakfast',
  'Lunch',
  'Dinner',
];

class AdminEditReceipes extends StatefulWidget {
  const AdminEditReceipes({
    super.key,
    required this.receipeId,
    required this.intialimage,
    required this.intialselectedDays,
    required this.intialplan,
    required this.intialhalfDay,
    required this.intialname,
    required this.intialprotiens,
    required this.intialcarbs,
    required this.intialfats,
    required this.intialinstructions,
    required this.intialingredients,
    required this.intialcalories,
    required this.intialtime,
    required this.intialprice,
  });
  final String receipeId;
  final String intialimage;
  final List<String> intialselectedDays;

  final List<String> intialplan;
  final String intialhalfDay;
  final String intialname;
  final String intialprotiens;
  final String intialcarbs;
  final String intialfats;
  final String intialinstructions;
  final String intialingredients;
  final String intialcalories;
  final String intialtime;
  final String intialprice;

  @override
  State<AdminEditReceipes> createState() => _AdminEditReceipesState();
}

class _AdminEditReceipesState extends State<AdminEditReceipes> {
  XFile? image;
  List<String> selectedDays = [];
  List<String> selectedPlan = [];

  // TextEditingController plantextEditingController = TextEditingController();
  TextEditingController halfDaytextEditingController = TextEditingController();
  TextEditingController nametextEditingController = TextEditingController();
  TextEditingController protienstextEditingController = TextEditingController();
  TextEditingController carbstextEditingController = TextEditingController();
  TextEditingController fatstextEditingController = TextEditingController();
  TextEditingController instructionstextEditingController =
      TextEditingController();
  TextEditingController ingredientstextEditingController =
      TextEditingController();
  TextEditingController caloriestextEditingController = TextEditingController();
  TextEditingController timetextEditingController = TextEditingController();
  TextEditingController pricetextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    selectedDays = widget.intialselectedDays;
    selectedPlan = widget.intialplan;
    // plantextEditingController.text = widget.intialplan;
    halfDaytextEditingController.text = widget.intialhalfDay;
    nametextEditingController.text = widget.intialname;
    protienstextEditingController.text = widget.intialprotiens;
    carbstextEditingController.text = widget.intialcarbs;
    fatstextEditingController.text = widget.intialfats;
    instructionstextEditingController.text = widget.intialinstructions;
    ingredientstextEditingController.text = widget.intialingredients;
    caloriestextEditingController.text = widget.intialcalories;
    timetextEditingController.text = widget.intialtime;
    pricetextEditingController.text = widget.intialprice;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
        useSingleChildScrollView: true,
        useCustomPadding: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: context.height * 0.09,
            ),
            Align(
              alignment: Alignment.center,
              child: badges.Badge(
                badgeContent: const Icon(
                  Icons.upload,
                  color: Colors.white,
                ),
                position: badges.BadgePosition.bottomEnd(
                  bottom: 5,
                ),
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  image = await picker.pickImage(source: ImageSource.gallery);
                  setState(() {});
                },
                child: image != null
                    ? CircleAvatar(
                        backgroundColor: Colors.pink.shade100,
                        backgroundImage: FileImage(File(image!.path)),
                        radius: 50,
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.pink.shade100,
                        backgroundImage: NetworkImage(widget.intialimage),
                        radius: 50,
                      ),
              ),
            ),
            SizedBox(
              height: context.height * 0.03,
            ),
            Text(
              'Plan',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16,
                  ),
            ),
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              primary: false,
              children: [
                buildCheckboxListTile('Daily'),
                buildCheckboxListTile('Weekly'),
              ],
            ),
            // SelectableDropDownWidget(
            //   selectedValue: (value) {
            //     plantextEditingController.text = value;
            //   },
            //   changedSelectedValue: plantextEditingController.text,
            //   items: plan
            //       .map((item) => DropdownMenuItem<String>(
            //             value: item,
            //             child: Text(
            //               item,
            //               style: const TextStyle(
            //                 fontSize: 14,
            //               ),
            //             ),
            //           ))
            //       .toList(),
            //   hintText: 'Choose Plan',
            // ),
            SizedBox(
              height: context.height * 0.03,
            ),
            Text(
              'Choose',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16,
                  ),
            ),
            SelectableDropDownWidget(
              selectedValue: (value) {
                halfDaytextEditingController.text = value;
              },
              changedSelectedValue: halfDaytextEditingController.text,
              items: unTypes
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              hintText: 'Choose',
            ),
            // SizedBox(
            //   height: context.height * 0.03,
            // ),
            // Text(
            //   'Weekdays',
            //   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            //         fontSize: 16,
            //       ),
            // ),

            // // SelectableDropDownWidget(
            // //   selectedValue: (value) {
            // //     // dropdownTextEditingController.text = value;
            // //   },
            // //   items: weekdays
            // //       .map((item) => DropdownMenuItem<String>(
            // //             value: item,
            // //             child: Text(
            // //               item,
            // //               style: const TextStyle(
            // //                 fontSize: 14,
            // //               ),
            // //             ),
            // //           ))
            // //       .toList(),
            // //   hintText: 'Choose Weekday',
            // // ),
            // ListView(
            //   shrinkWrap: true,
            //   padding: EdgeInsets.zero,
            //   primary: false,
            //   children: [
            //     buildCheckboxListTile('Monday'),
            //     buildCheckboxListTile('Tuesday'),
            //     buildCheckboxListTile('Wednesday'),
            //     buildCheckboxListTile('Thursday'),
            //     buildCheckboxListTile('Friday'),
            //     buildCheckboxListTile('Saturday'),
            //     buildCheckboxListTile('Sunday'),
            //   ],
            // ),

            SizedBox(
              height: context.height * 0.03,
            ),
            Text(
              'Receipe Name',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16,
                  ),
            ),
            TextFieldWidget(
              hintText: 'Cream Bowl',
              textEditingController: nametextEditingController,
            ),
            SizedBox(
              height: context.height * 0.03,
            ),
            Text(
              'Protiens',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16,
                  ),
            ),
            TextFieldWidget(
              hintText: '18',
              textEditingController: protienstextEditingController,
              textInputType: TextInputType.number,
            ),
            SizedBox(
              height: context.height * 0.03,
            ),
            Text(
              'Carbs',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16,
                  ),
            ),
            TextFieldWidget(
              hintText: '4',
              textEditingController: carbstextEditingController,
              textInputType: TextInputType.number,
            ),
            SizedBox(
              height: context.height * 0.03,
            ),
            Text(
              'Fats',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16,
                  ),
            ),
            TextFieldWidget(
              hintText: '18',
              textEditingController: fatstextEditingController,
              textInputType: TextInputType.number,
            ),
            SizedBox(
              height: context.height * 0.03,
            ),
            Text(
              'Instructions',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16,
                  ),
            ),
            TextFieldWidget(
              hintText: '',
              maxLines: 5,
              textEditingController: instructionstextEditingController,
              textInputAction: TextInputAction.newline,
              textInputType: TextInputType.multiline,
            ),
            SizedBox(
              height: context.height * 0.03,
            ),
            Text(
              'Ingredients list',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16,
                  ),
            ),
            TextFieldWidget(
              hintText: '',
//               hintText: '''
// 2 large eggs
// 1 dash of salt
// 1 dash of black pepper
// ''',
              maxLines: 5,
              textEditingController: ingredientstextEditingController,
              textInputAction: TextInputAction.newline,
              textInputType: TextInputType.multiline,
            ),
            SizedBox(
              height: context.height * 0.03,
            ),
            Text(
              'Calories',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16,
                  ),
            ),
            TextFieldWidget(
              hintText: '250',
              textEditingController: caloriestextEditingController,
              textInputType: TextInputType.number,
            ),
            SizedBox(
              height: context.height * 0.03,
            ),
            Text(
              'Time',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16,
                  ),
            ),
            TextFieldWidget(
              hintText: '13',
              textEditingController: timetextEditingController,
              textInputType: TextInputType.number,
            ),
            SizedBox(
              height: context.height * 0.03,
            ),
            Text(
              'Price',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16,
                  ),
            ),
            TextFieldWidget(
              hintText: '2.50',
              textEditingController: pricetextEditingController,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(
              height: context.height * 0.03,
            ),
            ElevatedButton(
              onPressed: () {
                AdminHelpers.updateReceipe(
                  context: context,
                  id: widget.receipeId,
                  image: image != null ? image!.path : widget.intialimage,
                  selectedPlan: selectedPlan,
                  // plantextEditingController: plantextEditingController,
                  halfDaytextEditingController: halfDaytextEditingController,
                  nametextEditingController: nametextEditingController,
                  protienstextEditingController: protienstextEditingController,
                  carbstextEditingController: carbstextEditingController,
                  fatstextEditingController: fatstextEditingController,
                  instructionstextEditingController:
                      instructionstextEditingController,
                  ingredientstextEditingController:
                      ingredientstextEditingController,
                  caloriestextEditingController: caloriestextEditingController,
                  timetextEditingController: timetextEditingController,
                  pricetextEditingController: pricetextEditingController,
                );
              },
              child: Text(
                'Update Receipe',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 20,
                      color: Colors.white,
                    ),
              ),
            ),
            SizedBox(
              height: context.height * 0.03,
            ),
          ],
        ));
  }

  Widget buildCheckboxListTile(String day) {
    return CheckboxListTile(
      title: Text(
        day,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      value: selectedPlan.contains(day),
      onChanged: (value) {
        setState(() {
          if (value == true) {
            selectedPlan.add(day);
          } else {
            selectedPlan.remove(day);
          }
        });
      },
      visualDensity: VisualDensity.compact,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }
}
