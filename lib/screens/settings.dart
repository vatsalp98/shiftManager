import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shift_manager/routes.dart';
import '../repositories/auth_repo.dart';
import '../shared/styles.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text(
            'User Information',
            style: CustomStyles.screenTitleTextStyle,
          ),
          SizedBox(
            height: 300,
            child: FutureBuilder(
              future: AuthRepo.fetchCustomUserAttributes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  var data = snapshot.data as Map;
                  return ListView(
                    children: [
                      ListTile(
                        title: Text(data['given_name']),
                        subtitle: const Text('Given Name'),
                      ),
                      ListTile(
                        title: Text(data['family_name']),
                        subtitle: const Text('Family Name'),
                      ),
                      ListTile(
                        title: Text(data['email']),
                        subtitle: data['email_verified'] == "true"
                            ? const Text('Email Verified')
                            : const Text('Unverified Email'),
                        trailing: data['email_verified'] == "true"
                            ? const Icon(
                                Icons.check_circle_rounded,
                                color: Colors.green,
                              )
                            : const Icon(Icons.dangerous_rounded),
                      ),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator(
                    color: Colors.red,
                  );
                }
              },
            ),
          ),
          ListTile(
            title: Text('Availability'),
            trailing: Icon(Icons.keyboard_arrow_right_rounded),
            onTap: () {
              Navigator.pushNamed(context, RoutesClass.availability);
            },
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          const Center(
            child: SignOutButton(),
          ),
        ],
      ),
    );
  }
}
