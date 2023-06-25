import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fitness/extensions/shared_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectableDropDownWidget extends StatefulWidget {
  const SelectableDropDownWidget({
    Key? key,
    required this.items,
    required this.hintText,
    this.buttonHeight,
    this.buttonWidth,
    this.dropDownHeight,
    this.dropDownWidth,
    this.showLeadingIcon = true,
    this.selectedValue,
    this.changedSelectedValue,
  }) : super(key: key);

  final List<DropdownMenuItem<String>>? items;
  final String hintText;
  final double? buttonHeight;
  final double? buttonWidth;
  final double? dropDownHeight;
  final double? dropDownWidth;
  final bool showLeadingIcon;
  final String? changedSelectedValue;
  final void Function(String)? selectedValue;

  @override
  State<SelectableDropDownWidget> createState() =>
      _SelectableDropDownWidgetState();
}

class _SelectableDropDownWidgetState extends State<SelectableDropDownWidget> {
  String? selectedValue = '';
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Text(
          widget.hintText,
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: const Color.fromRGBO(153, 153, 153, 1),
          ),
          overflow: TextOverflow.ellipsis,
        ),
        items: widget.items,
        value:
            selectedValue != '' ? selectedValue : widget.changedSelectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value as String;
          });
          widget.selectedValue!(value!);
        },
        buttonStyleData: ButtonStyleData(
          height: context.height * 0.068,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color.fromRGBO(211, 211, 211, 1),
              width: 1,
            ),
            color: Colors.white,
          ),
          elevation: 0,
        ),
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Colors.black87,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down_sharp),
          iconSize: 28,
          iconEnabledColor: Color.fromRGBO(34, 34, 34, 1),
          iconDisabledColor: Color.fromRGBO(34, 34, 34, 1),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: context.width * 0.89,
          padding: null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
          ),
          elevation: 1,
          offset: const Offset(0, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}
