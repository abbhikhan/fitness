import 'package:fitness/constants/app_images.dart';
import 'package:fitness/extensions/shared_extensions.dart';
import 'package:fitness/services/navigation_service.dart';
import 'package:fitness/views/authentication/login_view.dart';
import 'package:fitness/widgets/scaffold_widget.dart';
import 'package:flutter/material.dart';

import 'register_view.dart';

class AuthenticationView extends StatelessWidget {
  const AuthenticationView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppImages.onion,
            width: context.width * 0.641,
            height: context.height * 0.441,
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: context.height * 0.015,
          ),
          Text(
            "Let's eat",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(
            height: context.height * 0.006,
          ),
          SizedBox(
            width: context.width * 0.8,
            child: Text(
              'Welcome to ultimate nutrition tool',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          SizedBox(
            height: context.height * 0.094,
          ),
          ElevatedButton(
            onPressed: () {
              NavigationService().push( RegisterView());
            },
            child: Text(
              "I'am new here",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 20,
                    color: Colors.white,
                  ),
            ),
          ),
          SizedBox(
            height: context.height * 0.019,
          ),
          TextButton(
            onPressed: () {
              NavigationService().push( LoginView());
            },
            child: Text(
              'Sign in',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 20,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
