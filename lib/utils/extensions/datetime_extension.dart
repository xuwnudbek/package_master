extension DatetimeExtension on DateTime {
  String get format {
    return "$day.$month.$year";
  }

  String get toYMD {
    return "$year-${month.toString().padLeft(2, "0")}-${day.toString().padLeft(2, "0")}";
  }

  String get toYMDHS {
    return "$year-${month.toString().padLeft(2, "0")}-${day.toString().padLeft(2, "0")} ${hour.toString().padLeft(2, "0")}:${minute.toString().padLeft(2, "0")}";
  }
}
