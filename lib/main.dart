import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shift_manager/screens/home.dart';
import 'package:shift_manager/shared/bottom_nav.dart';
import 'package:shift_manager/shared/configure_amplify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await configureAmplify();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('fr')],
      fallbackLocale: const Locale('en'),
      path: 'assets/languages',
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp(
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        locale: context.locale,
        title: 'Shift Manager',
        theme: ThemeData(
          primarySwatch: Colors.red,
          fontFamily: 'Poppins',
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.all(16),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: Colors.grey[200],
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
        darkTheme: ThemeData.dark(),
        builder: Authenticator.builder(),
        debugShowCheckedModeBanner: false,
        home: const BottomNavigation(),
      ),
    );
  }
}
