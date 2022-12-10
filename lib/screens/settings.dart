import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shift_manager/routes.dart';

import '../repositories/auth_repo.dart';
import '../shared/const.dart';
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
        centerTitle: true,
        title: const Text('Settings'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        backgroundColor: HexColor(
            '#D2042D'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, left: 10, bottom: 10),
              child: Text(
                'User Information',
                style: CustomStyles.screenTitleTextStyle,
              ),
            ),
            SizedBox(
              height: 450,
              child: FutureBuilder(
                future: AuthRepo.fetchCustomUserAttributes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    var data = snapshot.data as Map;
                    return ListView(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person, size: 30),
                          title: Text(
                            data['given_name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: const Text(
                            'Given Name',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.person, size: 30),
                          title: Text(
                            data['family_name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: const Text(
                            'Family Name',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.email_rounded, size: 30),
                          title: Text(
                            data['email'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: data['email_verified'] == "true"
                              ? const Text(
                                  'Email Verified',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : const Text(
                                  'Unverified Email',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                          trailing: data['email_verified'] == "true"
                              ? const Icon(
                                  Icons.verified_user_rounded,
                                  color: Colors.green,
                                  size: 30,
                                )
                              : const Icon(Icons.dangerous_rounded),
                        ),
                        ListTile(
                          leading: const Icon(Icons.numbers, size: 30),
                          title: Text(
                            data['custom:employeeid'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: const Text(
                            'Employee ID',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.numbers, size: 30),
                          title: Text(
                            data['custom:regionid'] ==
                                    Constants.DEFAULT_SURREY_REGION
                                ? "Surrey, BC"
                                : "Others",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: const Text(
                            'Region',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        ListTile(
                          leading:
                              const Icon(Icons.admin_panel_settings, size: 30),
                          title: Text(
                            data['custom:role'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: const Text(
                            'Roles',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                leading: const Icon(Icons.calendar_month_rounded, size: 25),
                title: const Text(
                  'Availability',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                tileColor: Colors.red.shade50,
                trailing:
                    const Icon(Icons.keyboard_arrow_right_rounded, size: 25),
                onTap: () {
                  Navigator.pushNamed(context, RoutesClass.availability);
                },
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            const Center(
              child: SignOutButton(),
            ),
          ],
        ),
      ),
    );
  }
}
