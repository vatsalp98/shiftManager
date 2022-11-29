import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      signUpForm: SignUpForm.custom(
        fields: [
          SignUpFormField.givenName(required: true),
          SignUpFormField.familyName(required: true),
          SignUpFormField.email(required: true),
          SignUpFormField.custom(
            title: "Employee ID",
            attributeKey: const CognitoUserAttributeKey.custom('employeeId'),
          ),
          SignUpFormField.password(),
          SignUpFormField.passwordConfirmation(),
        ],
      ),
      authenticatorBuilder: (BuildContext context, AuthenticatorState state) {
        const padding =
            EdgeInsets.only(left: 16, right: 16, top: 38, bottom: 28);
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
                          'assets/shift-logo.png',
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
              persistentFooterButtons: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?'),
                    TextButton(
                      onPressed: () => state.changeStep(
                        AuthenticatorStep.signUp,
                      ),
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            );
          case AuthenticatorStep.signUp:
            return Scaffold(
              body: Padding(
                padding: padding,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/shift-logo.png',
                          height: 75,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 25, top: 5),
                        child: Text(
                          'Shift Manager',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // Insert Logo here
                      SignUpForm.custom(
                        fields: [
                          SignUpFormField.givenName(required: true),
                          SignUpFormField.familyName(required: true),
                          SignUpFormField.email(required: true),
                          SignUpFormField.custom(
                            title: "Employee ID",
                            attributeKey: const CognitoUserAttributeKey.custom('employeeId'),
                          ),
                          SignUpFormField.password(),
                          SignUpFormField.passwordConfirmation(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              persistentFooterButtons: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () => state.changeStep(
                        AuthenticatorStep.signIn,
                      ),
                      child: const Text('Sign In'),
                    ),
                  ],
                )
              ],
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
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(10)),
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
