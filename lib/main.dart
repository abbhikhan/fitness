import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'app.dart';
import 'helpers/shared_helpers.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await SharedHelpers.initilizeApp();
  Stripe.publishableKey =
      "pk_test_51N2Q82FfIlC0dejeLFzlhDFo8w0OYpEd17D6ZKU9LGnruy0WCx3Y3UHJuawglkNpS2N9qiBBBlobJpq4TQpaZuHy00T5hbxf6O";  
  // ErrorWidget.builder = (FlutterErrorDetails details) {
  //   return ConsoleErrorWidget(
  //     flutterErrorDetails: details,
  //   );
  // };

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const Fitness(),
    ),
  );
}
