import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

double defaultMargin = 20.0;
double defaultRadius = 10.0;

Color kPrimaryColor = const Color(0xff0094FF);
Color kPrimary2Color = const Color.fromARGB(255, 76, 155, 220);
Color kPrimaryLightColor = const Color(0xff31B9F6);
Color kPrimaryLight2Color = const Color(0xff9FE0FD);
Color kWhiteColor = const Color(0xffFFFFFF);
Color kBlackColor = const Color(0xff000000);
Color kGreyColor = const Color(0xff7E7E7E);
Color kLightGreyColor = const Color(0xffEBEBEB);
Color kGreenColor = const Color(0xff29CB9E);
Color kRedColor = const Color(0xffFF5E5E);
Color kTextColor = const Color(0xff524A4E);

TextStyle blackTextStyle = GoogleFonts.inter(
  color: kBlackColor,
);

TextStyle whiteTextStyle = GoogleFonts.inter(
  color: kWhiteColor,
);

TextStyle greyTextStyle = GoogleFonts.inter(
  color: kGreyColor,
);

TextStyle greenTextStyle = GoogleFonts.inter(
  color: kGreenColor,
);

TextStyle redTextStyle = GoogleFonts.inter(
  color: kRedColor,
);

TextStyle blueTextStyle = GoogleFonts.inter(
  color: kPrimaryColor,
);

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w800;
FontWeight black = FontWeight.w900;

var preloader = Center(child: CircularProgressIndicator(color: kPrimaryColor));
