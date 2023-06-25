import 'package:flutter/material.dart';

import '../../main.dart';

class NavigationService {
  push(Widget widget, {dynamic arguments}) {
    return navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (context) {
        return widget;
      },
    ));
  }

  pushReplacement(Widget widget, {dynamic arguments}) {
    return navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
      builder: (context) {
        return widget;
      },
    ));
  }

  pushAndRemoveUntil(Widget widget, {dynamic arguments}) {
    return navigatorKey.currentState?.pushAndRemoveUntil(MaterialPageRoute(
      builder: (context) {
        return widget;
      },
    ),
    (route) => false,
    );
  }

  pop([value]) {
    return navigatorKey.currentState?.pop(value);
  }


  BuildContext getNavigationContext() {
    return navigatorKey.currentState!.context;
  }
}
