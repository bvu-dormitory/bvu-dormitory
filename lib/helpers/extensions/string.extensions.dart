extension StringGetNullSafety on String {
  bool get isValidPhoneNumber => RegExp("^0{1}[1-9]{8}[0-9]{1}\$").hasMatch(this);
}
