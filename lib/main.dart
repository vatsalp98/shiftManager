import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shift_manager/routes.dart';
import 'package:shift_manager/shared/bottom_nav.dart';
import 'package:shift_manager/shared/configure_amplify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // await Firebase.initializeApp();
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
      authenticatorBuilder: (BuildContext context, AuthenticatorState state) {
        const padding =
            EdgeInsets.only(left: 16, right: 16, top: 78, bottom: 28);
        switch (state.currentStep) {
          case AuthenticatorStep.signIn:
            return Scaffold(
              body: Padding(
                padding: padding,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Insert Logo here
                      Center(
                        child: Image.asset(
                          'assets/logo2.png',
                          height: 150,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 25),
                        child: Text(
                          'Shift Manager',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SignInForm(),
                    ],
                  ),
                ),
              ),
            );
          case AuthenticatorStep.resetPassword:
            return Scaffold(
              body: Padding(
                padding: padding,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Insert Logo here
                      Center(
                        child: Image.asset(
                          'assets/logo2.png',
                          height: 150,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 25),
                        child: Text(
                          'Shift Manager',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 15.0, left: 5),
                        child: Text(
                          'Enter email address linked to the account to start changing your password.',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ResetPasswordForm(),
                    ],
                  ),
                ),
              ),
            );
          default:
            return null;
        }
      },
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
              textStyle: MaterialStateProperty.all(
                const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: MaterialStateProperty.all(HexColor('#893F45')),
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(10)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
        onGenerateRoute: RouteGenerator.generateRoute,
        builder: Authenticator.builder(),
        debugShowCheckedModeBanner: false,
        home: const BottomNavigation(),
      ),
    );
  }
}
