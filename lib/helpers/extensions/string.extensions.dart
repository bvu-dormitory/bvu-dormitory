extension StringGetNullSafety on String {
  bool get isValidPhoneNumber => RegExp("^0{1}[1-9]{1}[0-9]{8}\$").hasMatch(this);
}
