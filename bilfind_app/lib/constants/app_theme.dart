import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);

  static const Color primary = Color(0xff242526);
  static const Color secondary = Color(0xff3E3F40);
  static const Color bilkentBlue = Color(0xff0055A7);

  static const Color iconColor = Color(0xff442f29);

  static const Color inputBorderColor = Color(0xff626262);
  static const Color silverGray = Color(0xfff5f5f5);
  static const Color authBg = Color(0xffe6eaed);

  static const Color black1 = Color(0xff18191A);
  static const Color black2 = Color(0xff242526);
  static const Color black3 = Color(0xff2F3032);
  static const Color black4 = Color(0xff3E3F40);
  static const Color black6 = Color(0xff99999a);
  static const Color mutedWhite = Color(0xffE4E6EB);
  static const Color subText = Color(0xff989B9F);

  static const Color backgroundColor = Color(0xff18191A);
}

class AppThemes {
  static final darkTheme = ThemeData(
    textTheme:
        getTextTheme(textColor: Colors.yellow, buttonColor: Colors.white),
    fontFamily: "Poppins",

    /*scaffoldBackgroundColor: ProgramColors.gloneraDarkBackground,
    fontFamily: "Poppins",
    primaryColor: ProgramColors.gloneraDarkMainGray,
    colorScheme: ColorScheme.dark(
        primary: ProgramColors.gloneraDarkMainGray,
        secondary: Colors.white70,
        onBackground: ProgramColors.gloneraDarkMainGray),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green))),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor:
        MaterialStateProperty.all<Color>(ProgramColors.gloneraDarkMainGray),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(vertical: 8, horizontal: 16)),
      ),
    ),
    textButtonTheme:
    TextButtonThemeData(style: TextButton.styleFrom(primary: Colors.white)),
    textTheme: getTextTheme(textColor: Colors.white, buttonColor: Colors.white),
    toggleButtonsTheme: ToggleButtonsThemeData(
        selectedColor: Color(0xFF747474),
        color: ProgramColors.gloneraDarkMainGray,
        disabledColor: Colors.white),
    snackBarTheme:
    SnackBarThemeData(backgroundColor: ProgramColors.gloneraDarkMainGray),*/
  );

  static final lightTheme = ThemeData(
    textTheme: getTextTheme(
      textColor: Colors.black87,
      buttonColor: Colors.white,
    ),
    fontFamily: "Poppins",
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      onBackground: AppColors.silverGray,
    ),
    iconTheme: const IconThemeData(color: AppColors.iconColor),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
          color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
    ),
  );

  static TextTheme getTextTheme(
      {required Color textColor, required Color buttonColor}) {
    return TextTheme(
      titleLarge: TextStyle(
          fontWeight: FontWeight.w700, fontSize: 28, color: textColor),
      titleMedium: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 18, color: textColor),
      headlineMedium: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 24, color: textColor),
      headlineSmall: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 12, color: textColor),
    );
  }
}
