import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_photon_learning/app.dart';
import 'package:flutter_photon_learning/methods/share_intent.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final nav = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.init((await getApplicationDocumentsDirectory()).path);
  await Hive.openBox('appData');
  Box box = Hive.box('appData');
  box.get('avatarPath') ?? box.put('avatarPath', 'assets/avatars/1.png');
  box.get('username') ?? box.put('username', '${Platform.localHostname} user');
  box.get('queryPackages') ?? box.put('queryPackages', false);
  GetIt getIt = GetIt.instance;

  SharedPreferences prefInst = await SharedPreferences.getInstance();
  prefInst.get('isIntroRead') ?? prefInst.setBool('isIntroRead', false);
  prefInst.get('isDarkTheme') ?? prefInst.setBool('isDarkTheme', true);

  bool externalIntent = false;
  String type = "";
  if (Platform.isAndroid) {
    (externalIntent, type) = await handleSharingIntent();
    try {
      await FlutterDisplayMode.setHighRefreshRate();
    } catch (_) {}
  }

  runApp(AdaptiveTheme(
    light: FlexThemeData.light(),
    dark: FlexThemeData.dark(),
    initial: prefInst.getBool('isDarkTheme') == true
        ? AdaptiveThemeMode.dark
        : AdaptiveThemeMode.light,
    builder: (theme, dark) {
      return MaterialApp(
        navigatorKey: nav,
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: dark,
        routes: {
          '/': (context) => AnimatedSplashScreen(
                splash: 'assets/images/splash.png',
                nextScreen: prefInst.getBool('isIntroRead') == true
                    ? (externalIntent ? const MyApp() : const MyApp())
                    : const MyApp(),
              ),
          '/home': (context) => const MyApp()
        },
      );
    },
  ));
}
