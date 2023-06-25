import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NativeThemeData {
  ThemeData nativeLightTheme() {
    return ThemeData.light().copyWith(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          // TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          // TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          // TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          // TargetPlatform.iOS: OpenUpwardsPageTransitionsBuilder(),
        },
      ),
      // useMaterial3: true,
      scaffoldBackgroundColor: const Color.fromRGBO(222, 231, 232, 1),
      primaryColor: const Color.fromRGBO(177, 7, 37, 1),
      primaryColorDark: const Color.fromRGBO(11, 10, 7, 1),
      primaryColorLight: const Color.fromRGBO(0, 0, 0, 1),
      primaryTextTheme: const TextTheme(),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color.fromRGBO(177, 7, 37, 1),
        width: 300,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          textStyle: MaterialStatePropertyAll(
            GoogleFonts.montserrat(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: const Color.fromRGBO(0, 0, 0, 1),
            ),
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStatePropertyAll(
            GoogleFonts.aBeeZee(
              fontSize: 25,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          elevation: const MaterialStatePropertyAll(0),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          )),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: const MaterialStatePropertyAll(
            Size(314, 50),
          ),
          backgroundColor: const MaterialStatePropertyAll(
            Color.fromRGBO(153, 63, 162, 1),
          ),
        ),
      ),
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
      dialogTheme: const DialogTheme(
        backgroundColor: Colors.white,
      ),
      dialogBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actionsIconTheme: const IconThemeData(
          color: Color(0xff222222),
        ),
        titleTextStyle: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: const Color.fromRGBO(34, 34, 34, 1),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStatePropertyAll(
            GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color.fromRGBO(253, 165, 43, 1),
            ),
          ),
          iconColor: const MaterialStatePropertyAll(
            Color.fromRGBO(253, 165, 43, 1),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          fixedSize: const MaterialStatePropertyAll(
            Size(150, 38),
          ),
          side: const MaterialStatePropertyAll(
            BorderSide(
              color: Color.fromRGBO(253, 165, 43, 1),
              width: 2,
            ),
          ),
          backgroundColor: const MaterialStatePropertyAll(
            // Color.fromRGBO(253, 165, 43, 1),
            Colors.white,
          ),
        ),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          padding: MaterialStatePropertyAll(
            EdgeInsets.zero,
          ),

          // iconColor: MaterialStatePropertyAll(
          //   Colors.white,
          // ),
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
    );
  }

  ThemeData nativeDarkTheme() {
    return ThemeData.dark().copyWith();
  }
}
