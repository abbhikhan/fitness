import 'package:fitness/extensions/shared_extensions.dart';
import 'package:fitness/views/authentication/login_view.dart';
import 'package:fitness/widgets/scaffold_widget.dart';
import 'package:fitness/widgets/text_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../helpers/authenticaton_helpers.dart';
import '../../services/navigation_service.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      resizeToAvoidBottomInset: false,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: context.height * 0.1,
          ),
          Text(
            'Sign up',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(
            height: context.height * 0.026,
          ),
          Text(
            "Enter your email and password and start eating right",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(
            height: context.height * 0.04,
          ),
          TextFieldWidget(
            hintText: 'Email',
            textEditingController: emailTextEditingController,
          ),
          SizedBox(
            height: context.height * 0.024,
          ),
          TextFieldWidget(
            hintText: 'Password',
            textEditingController: passwordTextEditingController,
            textInputAction: TextInputAction.done,
            obsecureText: true,
          ),
          SizedBox(
            height: context.height * 0.044,
          ),
          ElevatedButton(
            onPressed: () {
              AuthenticationHelpers.createUser(
                context: context,
                emailTextEditingController: emailTextEditingController,
                paswordTextEditingController: passwordTextEditingController,
              );
            },
            child: Text(
              'Sign up',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 20,
                    color: Colors.white,
                  ),
            ),
          ),
          SizedBox(
            height: context.height * 0.033,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: context.width * 0.1,
                height: 1,
                color: const Color.fromRGBO(169, 169, 169, 1),
              ),
              SizedBox(
                width: context.width * 0.014,
              ),
              Text(
                'or continue with',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: const Color.fromRGBO(169, 169, 169, 1),
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
              ),
              SizedBox(
                width: context.width * 0.014,
              ),
              Container(
                width: context.width * 0.1,
                height: 1,
                color: const Color.fromRGBO(169, 169, 169, 1),
              ),
            ],
          ),
          SizedBox(
            height: context.height * 0.033,
          ),
          ElevatedButton(
            onPressed: () {},
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
              Color.fromRGBO(66, 103, 178, 1),
            )),
            child: Text(
              'Continue with faceboook',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          SizedBox(
            height: context.height * 0.019,
          ),
          ElevatedButton(
            onPressed: () {
              AuthenticationHelpers.ggoogleSignIn(context: context);
            },
            style: const ButtonStyle(
              side: MaterialStatePropertyAll(BorderSide(
                color: Color.fromRGBO(169, 169, 169, 1),
              )),
              backgroundColor: MaterialStatePropertyAll(
                Color.fromRGBO(237, 237, 237, 1),
              ),
            ),
            child: Text(
              'Continue with google',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          SizedBox(
            height: context.height * 0.04,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Already have an account? ',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 18,
                      ),
                ),
                TextSpan(
                  text: 'Sign in',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: const Color.fromRGBO(153, 63, 162, 1),
                        fontSize: 18,
                      ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      NavigationService().push(LoginView());
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
