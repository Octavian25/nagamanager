class Helper {
  static final getToday = _getToday();

  static String formatDate(date) {
    return date.split("-").reversed.join("-");
  }

  static String dateToString(DateTime? value) {
    var date = value.toString();
    var hasil = date.substring(0, 10);
    return hasil;
  }

  static String convertDate(String date) {
    var month = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Maret",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];
    var split = date.split("-");
    return "${split[2]} ${month[int.parse(split[1]) - 1]} ${split[0]}";
  }
}

class _getToday {
  String increment({int value = 0}) {
    var date = (DateTime.now().add(Duration(days: value))).toString();
    var hasil = date.substring(0, 10);
    return hasil;
  }

  String decrement({int value = 0}) {
    var date = (DateTime.now().subtract(Duration(days: value))).toString();
    var hasil = date.substring(0, 10);
    return hasil;
  }

  String normal() {
    var date = (DateTime.now()).toString();
    var hasil = date.substring(0, 10);
    return hasil;
  }
}
