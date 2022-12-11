import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:shift_manager/routes.dart';

import '../repositories/auth_repo.dart';
import '../shared/const.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 55, left: 10, bottom: 5),
              child: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5, left: 10, bottom: 5),
              child: Text(
                'User Information',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
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
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person, size: 30),
                          title: Text(
                            data['given_name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: const Text(
                            'Given Name',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.person, size: 30),
                          title: Text(
                            data['family_name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: const Text(
                            'Family Name',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.email_rounded, size: 30),
                          title: Text(
                            data['email'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: data['email_verified'] == "true"
                              ? const Text(
                                  'Email Verified',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                )
                              : const Text(
                                  'Unverified Email',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.grey,
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
                              fontSize: 18,
                            ),
                          ),
                          subtitle: const Text(
                            'Employee ID',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.map_rounded, size: 30),
                          title: Text(
                            data['custom:regionid'] ==
                                    Constants.DEFAULT_SURREY_REGION
                                ? "Surrey, BC"
                                : "Others",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: const Text(
                            'Region',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.grey,
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
                              fontSize: 18,
                            ),
                          ),
                          subtitle: const Text(
                            'Roles',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.grey,
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
            const Padding(
              padding: EdgeInsets.only(top: 5, left: 10, bottom: 0),
              child: Text(
                'Availability',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
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
