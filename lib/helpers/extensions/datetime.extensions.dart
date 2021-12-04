extension DateTimeExtension on DateTime {
  String getReadableDateString() {
    return "${day.toString().padLeft(2, '0')}-${month.toString().padLeft(2, '0')}-$year";
  }
}
