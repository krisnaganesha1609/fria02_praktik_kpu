import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_snackbars/enums/animate_from.dart';
import 'package:smart_snackbars/smart_snackbars.dart';

class SnackbarService {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showSuccessSnackbar(
      {required BuildContext context,
      required String title,
      required String message,
      Duration? duration}) {
    SmartSnackBars.showTemplatedSnackbar(
        elevation: 2,
        animationCurve: Curves.fastLinearToSlowEaseIn,
        leading: Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
        duration: duration ?? const Duration(milliseconds: 3500),
        persist: false,
        animateFrom: AnimateFrom.fromBottom,
        backgroundColor: Colors.green,
        titleWidget: Text(
          title,
          style: GoogleFonts.ubuntu(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
        ),
        subTitleWidget: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        context: context);
  }

  static void showFailedSnackbar(
      {required BuildContext context,
      required String title,
      required String message,
      Duration? duration}) {
    SmartSnackBars.showTemplatedSnackbar(
      persist: false,
      elevation: 2,
      animationCurve: Curves.fastLinearToSlowEaseIn,
      leading: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
        ),
        child: const Icon(
          Icons.block,
          color: Colors.white,
        ),
      ),
      animateFrom: AnimateFrom.fromBottom,
      duration: duration ?? const Duration(milliseconds: 3500),
      backgroundColor: Colors.red,
      titleWidget: Text(
        title,
        style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.w700, color: Colors.white),
      ),
      subTitleWidget: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            message,
            maxLines: 5,
            style: GoogleFonts.ubuntu(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ),
      context: context,
    );
  }

  static void showHelpSnackbar(
      {required BuildContext context,
      required String title,
      required String message,
      Duration? duration}) {
    SmartSnackBars.showTemplatedSnackbar(
      elevation: 2,
      animationCurve: Curves.fastLinearToSlowEaseIn,
      leading: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
        ),
        child: const Icon(
          Icons.info_outline_sharp,
          color: Colors.white,
        ),
      ),
      animateFrom: AnimateFrom.fromBottom,
      duration: const Duration(milliseconds: 3500),
      backgroundColor: Colors.blue,
      titleWidget: Text(
        title,
        style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.w700, color: Colors.white),
      ),
      subTitleWidget: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(message,
            style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 14)),
      ),
      context: context,
    );
  }

  static void showWarningSnackbar(
      {required BuildContext context,
      required String title,
      required String message,
      Duration? duration}) {
    SmartSnackBars.showTemplatedSnackbar(
      elevation: 2,
      animationCurve: Curves.fastLinearToSlowEaseIn,
      leading: Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
          ),
          child: const Icon(Icons.warning)),
      animateFrom: AnimateFrom.fromBottom,
      duration: const Duration(milliseconds: 3500),
      backgroundColor: Colors.yellow,
      titleWidget: Text(
        title,
        style: GoogleFonts.ubuntu(
            color: Colors.white, fontWeight: FontWeight.w700),
      ),
      subTitleWidget: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          message,
          style: GoogleFonts.ubuntu(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      context: context,
    );
  }
}
