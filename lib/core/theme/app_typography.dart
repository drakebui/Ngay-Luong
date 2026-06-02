import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTypography {
  static final TextStyle heroNumber = GoogleFonts.beVietnamPro(
    fontSize: 64,
    fontWeight: FontWeight.w800,
    height: 1.0,
    letterSpacing: 0,
  );

  static final TextStyle heroUnit = GoogleFonts.beVietnamPro(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static final TextStyle title = GoogleFonts.beVietnamPro(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static final TextStyle body = GoogleFonts.beVietnamPro(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static final TextStyle label = GoogleFonts.beVietnamPro(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static final TextStyle caption = GoogleFonts.beVietnamPro(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  static final TextStyle priceInput = GoogleFonts.beVietnamPro(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
}
