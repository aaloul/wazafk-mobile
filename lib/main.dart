import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:toastification/toastification.dart';
import 'package:wazafak_app/screens/auth/splash/splash_screen.dart';
import 'package:wazafak_app/utils/DismissKeyboard.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/pusher_manager.dart';

import 'constants/get_pages_constant.dart';
import 'constants/route_constant.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init('USER');
  await PusherManager().initPusher();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: DismissKeyboard(
        child: GetMaterialApp(
          title: 'Wazafak',
          debugShowCheckedModeBanner: false,
          locale: Locale(Prefs.getLanguage),
          getPages: getPages,
          initialRoute: RouteConstant.splashScreen,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
