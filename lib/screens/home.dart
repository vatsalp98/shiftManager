import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shift_manager/shared/noShiftCard.dart';
import 'package:shift_manager/shared/noUpcomingShiftCard.dart';
import 'package:shift_manager/shared/shiftCard.dart';

import '../repositories/data_repo.dart';
import '../shared/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late Future<AuthUser> authFuture;
  late Future todayShiftFuture;
  late Future shiftListFuture;
  late Future shiftListPast;

  @override
  void initState() {
    super.initState();
    // _firebaseMessaging.getToken().then((token) => print(token));
    authFuture = Amplify.Auth.getCurrentUser();
    todayShiftFuture = DataRepo().listShiftDaily();
    shiftListFuture = DataRepo().listUpcomingShiftUsers();
    shiftListPast = DataRepo().listPreviousShiftUsers();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            shiftListFuture = DataRepo().listUpcomingShiftUsers();
            shiftListPast = DataRepo().listPreviousShiftUsers();
          });
          return shiftListFuture;
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60.0, left: 7, right: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Welcome,',
                          style: TextStyle(
                            fontSize: screenHeight / 45,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        FutureBuilder(
                          future: authFuture,
                          builder: (context, snap) {
                            if (snap.hasData &&
                                snap.connectionState == ConnectionState.done) {
                              var data = snap.data;
                              return Text(
                                data!.username,
                                style: TextStyle(
                                  fontSize: screenHeight / 55,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      'assets/svg/hello.svg',
                      height: 65,
                      width: 65,
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 9.0, top: 25),
                child: Text(
                  "Today's Status",
                  style: CustomStyles.screenTitleTextStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 9.0),
                child: Text(
                  DateFormat('dd MMMM yyyy').format(DateTime.now()),
                  style: TextStyle(
                    fontSize: screenHeight / 45,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 15),
                child: SizedBox(
                  height: 160,
                  child: FutureBuilder(
                    future: todayShiftFuture,
                    builder: (context, snap) {
                      switch (snap.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());
                        case ConnectionState.done:
                        default:
                          if (snap.hasError) {
                            return Text('Error ${snap.error}');
                          } else if (snap.hasData) {
                            return snap.data['empty']
                                ? NoShiftCard(screenHeight, 150)
                                : ShiftCard(
                                    snap.data['data'][0]['shiftStatus'],
                                    snap.data['data'][0]['shift']['shiftType'],
                                    snap.data['data'][0]['date'],
                                    snap.data['data'][0]['shift']['startTime'],
                                    snap.data['data'][0]['shift']['endTime'],
                                    screenHeight,
                                    150);
                          } else {
                            return const Text('No Data');
                          }
                      }
                    },
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 9.0, top: 25),
                child: Text(
                  "Upcoming Shifts",
                  style: CustomStyles.screenTitleTextStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 15),
                child: SizedBox(
                  height: 160,
                  child: FutureBuilder(
                    future: shiftListFuture,
                    builder: (context, snap) {
                      switch (snap.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());
                        case ConnectionState.done:
                        default:
                          if (snap.hasError) {
                            return Text('Error ${snap.error}');
                          } else if (snap.hasData) {
                            return snap.data['empty']
                                ? NoUpcomingShiftCard(screenHeight, 150)
                                : ShiftCard(
                                    snap.data['data'][0]['shiftStatus'],
                                    snap.data['data'][0]['shift']['shiftType'],
                                    snap.data['data'][0]['date'],
                                    snap.data['data'][0]['shift']['startTime'],
                                    snap.data['data'][0]['shift']['endTime'],
                                    screenHeight,
                                    150);
                          } else {
                            return const Text('No Data');
                          }
                      }
                    },
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 9.0, top: 25),
                child: Text(
                  "Previous Shifts",
                  style: CustomStyles.screenTitleTextStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 15),
                child: SizedBox(
                  height: 160,
                  child: FutureBuilder(
                    future: shiftListPast,
                    builder: (context, snap) {
                      switch (snap.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());
                        case ConnectionState.done:
                        default:
                          if (snap.hasError) {
                            return Text('Error ${snap.error}');
                          } else if (snap.hasData) {
                            return snap.data['empty']
                                ? NoUpcomingShiftCard(screenHeight, 150)
                                : ListView(
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 5),
                                    children: [
                                      for (var item in snap.data['data'])
                                        ListTile(
                                          title: Text('Date: ${item['date']}'),
                                          subtitle: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'Status: ${item['shiftStatus']}'),
                                              Text(
                                                  'Type: ${item['shift']['shiftType']}')
                                            ],
                                          ),
                                          leading: const Icon(
                                            Icons.check_rounded,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                          isThreeLine: true,
                                        ),
                                    ],
                                  );
                          } else {
                            return const Text('No Data');
                          }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
