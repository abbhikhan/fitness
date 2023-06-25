import 'package:fitness/extensions/shared_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final InputDecoration? inputDecoration;
  final List<TextInputFormatter>? textInputFormatter;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final bool? obsecureText;
  final String hintText;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final Widget? prefixIcon;
  final TextStyle? hintStyle;
  final bool showPrefixIcon;
  final bool showSuffixIcon;
  final EdgeInsets? contentPadding;
  final TextAlign? textAlign;
  final int maxLines;
  final void Function()? onTap;
  const TextFieldWidget({
    Key? key,
    this.textEditingController,
    this.focusNode,
    this.suffixIcon,
    this.inputDecoration,
    this.textInputFormatter,
    this.textInputAction,
    this.onChanged,
    this.textInputType,
    required this.hintText,
    this.obsecureText,
    this.prefixIcon,
    this.hintStyle,
    this.showPrefixIcon = false,
    this.showSuffixIcon = false,
    this.contentPadding,
    this.textAlign,
    this.maxLines = 1,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      focusNode: focusNode,
      onChanged: onChanged,
      style: GoogleFonts.montserrat(
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: const Color.fromRGBO(0, 0, 0, 1),
      ),
      onTap: onTap,
      maxLines: maxLines,
      decoration: InputDecoration(
        contentPadding: contentPadding ??
            EdgeInsets.only(
              left: context.width * 0.08,
              right: context.width * 0.08,
              bottom: context.height * 0.018,
              top: context.height * 0.018,
            ),
        hintText: focusNode != null
            ? focusNode!.hasFocus
                ? ''
                : hintText
            : hintText,
        hintStyle: hintStyle,
        prefixIconConstraints: const BoxConstraints(
          maxWidth: 30,
          minWidth: 30,
        ),
        prefixIcon: showPrefixIcon
            ? const Icon(
                Icons.search,
              )
            : null,
        suffixIconConstraints: const BoxConstraints(
          maxWidth: 30,
          minWidth: 30,
        ),
        suffixIcon: showSuffixIcon
            ? const Icon(
                Icons.edit,
              )
            : null,
      ),
      inputFormatters: textInputFormatter,
      keyboardType: textInputType ?? TextInputType.text,
      textAlign: textAlign ?? TextAlign.left,
      // textAlignVertical:
      //     showPrefixIcon ? TextAlignVertical.center : TextAlignVertical.center,
      obscureText: obsecureText ?? false,
      textInputAction: textInputAction ?? TextInputAction.next,
    );
  }
}

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final InputDecoration? inputDecoration;
  final List<TextInputFormatter>? textInputFormatter;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final bool? obsecureText;
  final String hintText;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final Widget? prefixIcon;
  final TextStyle? hintStyle;
  final bool showPrefixIcon;
  final bool showSuffixIcon;
  final EdgeInsets? contentPadding;
  final String? initialValue;
  final void Function(String?)? onSaved;
  final bool readOnly;
  final TextAlign? textAlign;
  const TextFormFieldWidget({
    Key? key,
    this.textEditingController,
    this.focusNode,
    this.suffixIcon,
    this.inputDecoration,
    this.textInputFormatter,
    this.textInputAction,
    this.onChanged,
    this.textInputType,
    required this.hintText,
    this.obsecureText,
    this.prefixIcon,
    this.hintStyle,
    this.showPrefixIcon = false,
    this.showSuffixIcon = false,
    this.contentPadding,
    this.initialValue,
    this.onSaved,
    this.readOnly = false,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      controller: textEditingController,
      focusNode: focusNode,
      onChanged: onChanged,
      onSaved: onSaved,
      readOnly: readOnly,
      style: GoogleFonts.montserrat(
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: const Color.fromRGBO(0, 0, 0, 1),
      ),
      decoration: InputDecoration(
        contentPadding: contentPadding ?? EdgeInsets.all(8),
        hintText: focusNode != null
            ? focusNode!.hasFocus
                ? ''
                : hintText
            : hintText,
        hintStyle: hintStyle,
        prefixIconConstraints: BoxConstraints(
          maxWidth: 30,
          minWidth: 30,
        ),
        prefixIcon: showPrefixIcon
            ? Icon(
                Icons.search,
              )
            : null,
        suffixIconConstraints: BoxConstraints(
          maxWidth: 30,
          minWidth: 30,
        ),
        suffixIcon: showSuffixIcon
            ? Icon(
                Icons.edit,
              )
            : null,
      ),
      inputFormatters: textInputFormatter,
      keyboardType: textInputType ?? TextInputType.text,
      textAlign: textAlign ?? TextAlign.left,
      textAlignVertical:
          showPrefixIcon ? TextAlignVertical.bottom : TextAlignVertical.center,
      obscureText: obsecureText ?? false,
      textInputAction: textInputAction ?? TextInputAction.next,
    );
  }
}
