import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileCustomTheme extends StatelessWidget {
  const ProfileCustomTheme({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
        textTheme: TextTheme(
          bodyLarge: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: 32,
            color: const Color.fromRGBO(0, 0, 0, 1),
          ),
          bodyMedium: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: const Color.fromRGBO(0, 0, 0, 1),
          ),
          bodySmall: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: const Color.fromRGBO(0, 0, 0, 1),
          ),
          displayMedium: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: const Color.fromRGBO(0, 0, 0, 1),
          ),
          headlineMedium: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: const Color.fromRGBO(0, 0, 0, 1),
          ),
          headlineLarge: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 32,
            color: const Color.fromRGBO(0, 0, 0, 1),
          ),
          headlineSmall: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: const Color.fromRGBO(0, 0, 0, 1),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: const Color.fromRGBO(255, 255, 255, 1),
          filled: true,
          // isDense: true,
          // constraints: const BoxConstraints(
          //   maxHeight: 61,
          //   minHeight: 61,
          // ),
          prefixIconColor: const Color.fromRGBO(153, 153, 153, 1),
          suffixIconColor: const Color.fromRGBO(34, 34, 34, 1),
          hintStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: const Color.fromRGBO(0, 0, 0, 1),
          ),
          labelStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: const Color.fromRGBO(109, 106, 106, 1),
          ),
          helperStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.black87,
          ),
          errorStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: const Color.fromRGBO(109, 106, 106, 1),
          ),
          prefixStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: const Color.fromRGBO(109, 106, 106, 1),
          ),
          suffixStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: const Color.fromRGBO(109, 106, 106, 1),
          ),
          counterStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: const Color.fromRGBO(109, 106, 106, 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: Color.fromRGBO(211, 211, 211, 1),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: Color.fromRGBO(211, 211, 211, 1),
              width: 1,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: Color.fromRGBO(211, 211, 211, 1),
              width: 1,
            ),
          ),
        ),
      ),
      child: child,
    );
  }
}
