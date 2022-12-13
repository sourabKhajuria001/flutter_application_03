import 'package:flutter/material.dart' show BuildContext, ModalRoute;

extension GetArgument on BuildContext {
  T? getArgument<T>() {
    final modalRoute = ModalRoute.of(this);
    if (modalRoute != null) {
      final args = modalRoute.settings.arguments;
      // only return args of type we passed/asked for
      if (args != null && args is T) {
        return args as T;
      }
    }
    return null;
  }
}
