part of 'shared.dart';

Color blue = "4653FE".toColor();
Color red = "CF626B".toColor();
Color white = Colors.white;
Color green = "#ABD1AF".toColor();
Color grey = "F4F4F4".toColor();
Color background = "EEEEEE".toColor();
Color backgroundItem = "F3F6F9".toColor();
Color success = "86C2B0".toColor();
Color text = "383874".toColor();

TextStyle titleText =
    GoogleFonts.poppins(fontSize: 24.sp, fontWeight: FontWeight.w600);
TextStyle bigText =
    GoogleFonts.poppins(fontSize: 36.sp, fontWeight: FontWeight.w600);
TextStyle normalText =
    GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w500);

TextStyle titleTextMobile =
    GoogleFonts.poppins(fontSize: 50.sp, fontWeight: FontWeight.w600);
TextStyle bigTextMobile =
    GoogleFonts.poppins(fontSize: 67.sp, fontWeight: FontWeight.w600);
TextStyle normalTextMobile =
    GoogleFonts.poppins(fontSize: 28.sp, fontWeight: FontWeight.w500);

List<Color> listColor = [
  "#ED383F".toColor(),
  "#F7A84C".toColor(),
  "#FCF25F".toColor(),
  "#A3D067".toColor(),
  "#35A05F".toColor(),
  "#42BCB3".toColor(),
  "#55BBE7".toColor(),
  "#3083C6".toColor(),
  "#4E4FA2".toColor(),
  "#A2419D".toColor(),
  "#D9336F".toColor(),
  "#E1E84E".toColor(),
];

void showToast(String data, bool isError) {
  Fluttertoast.showToast(
      msg: data,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 4,
      backgroundColor: isError ? red : green,
      textColor: Colors.white,
      fontSize: 16.sp);
}
