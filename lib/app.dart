import 'package:bot_toast/bot_toast.dart';
import 'package:fitness/views/authentication/login_view.dart';
import 'package:fitness/views/user_information/user_information.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/app_texts.dart';
import 'database/firebase.dart';
import 'enums/authentication_enums.dart';
import 'helpers/shared_helpers.dart';
import 'main.dart';
import 'theme/native_theme.dart';
import 'views/admin/admin_receipes/admin_list_receipes.dart';
import 'views/user/home/home_view.dart';
import 'widgets/view_not_found_widget.dart';

class Fitness extends StatelessWidget {
  const Fitness({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: SharedHelpers().controllers,
      child: MaterialApp(
        useInheritedMediaQuery: true,
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,
        title: AppTexts.appTitle,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: NativeThemeData().nativeLightTheme(),
        home: FirebaseAccess.firebaseAuthInstance.currentUser != null
            ? FirebaseAccess.sharedPreferences.getString('userType') ==
                    AuthenticationEnums.user.name
                ? FirebaseAccess.sharedPreferences
                            .getString('userInformation') ==
                        'true'
                    ? const HomeView()
                    : const UserInformation()
                : FirebaseAccess.sharedPreferences.getString('userType') ==
                        AuthenticationEnums.admin.name
                    ? const AdminListReceipes()
                    : LoginView()
            : LoginView(),
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => ViewNotFoundWidget(viewName: settings.name!),
        ),
      ),
    );
  }
}
