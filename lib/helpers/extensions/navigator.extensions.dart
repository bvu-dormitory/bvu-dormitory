import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension NavigatorExtensions on NavigatorState {
  Future<T?> pushTo<T extends Object?>(Widget screen) {
    return push(
      CupertinoPageRoute(builder: (context) => screen),
    );
  }
}
