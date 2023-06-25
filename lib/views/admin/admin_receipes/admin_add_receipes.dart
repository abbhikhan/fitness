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

class AdminAddReceipes extends StatefulWidget {
  const AdminAddReceipes({super.key});

  @override
  State<AdminAddReceipes> createState() => _AdminAddReceipesState();
}

class _AdminAddReceipesState extends State<AdminAddReceipes> {
  XFile? image;
  List<String> selectedDays = [];

  final TextEditingController plantextEditingController =
      TextEditingController();
  final TextEditingController halfDaytextEditingController =
      TextEditingController();
  final TextEditingController nametextEditingController =
      TextEditingController();
  final TextEditingController protienstextEditingController =
      TextEditingController();
  final TextEditingController carbstextEditingController =
      TextEditingController();
  final TextEditingController fatstextEditingController =
      TextEditingController();
  final TextEditingController instructionstextEditingController =
      TextEditingController();
  final TextEditingController ingredientstextEditingController =
      TextEditingController();
  final TextEditingController caloriestextEditingController =
      TextEditingController();
  final TextEditingController timetextEditingController =
      TextEditingController();
  final TextEditingController pricetextEditingController =
      TextEditingController();

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
                child: CircleAvatar(
                  backgroundColor: Colors.pink.shade100,
                  backgroundImage:
                      image != null ? FileImage(File(image!.path)) : null,
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

            // SelectableDropDownWidget(
            //   selectedValue: (value) {
            //     // dropdownTextEditingController.text = value;
            //   },
            //   items: weekdays
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
            //   hintText: 'Choose Weekday',
            // ),

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
                AdminHelpers.addReceipe(
                  context: context,
                  image: image,
                  selectedDays: selectedDays,
                  plantextEditingController: plantextEditingController,
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
                'Add Receipe',
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
      value: selectedDays.contains(day),
      onChanged: (value) {
        setState(() {
          if (value == true) {
            selectedDays.add(day);
          } else {
            selectedDays.remove(day);
          }
        });
      },
      visualDensity: VisualDensity.compact,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }
}
