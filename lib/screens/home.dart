import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shift_manager/shared/noShiftCard.dart';
import 'package:shift_manager/shared/noUpcomingShift_card.dart';
import 'package:shift_manager/shared/shift_card.dart';

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
    // final screenWidth = MediaQuery.of(context).size.width;
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
                              return Column(
                                children: [
                                  Text(
                                    data!.username,
                                    style: TextStyle(
                                      fontSize: screenHeight / 55,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
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
                                : GestureDetector(
                                    onTap: () async {
                                      snap.data['data'][0]['shiftStatus'] ==
                                              "initial"
                                          ? await showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      "Confirm Shift"),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, false);
                                                        },
                                                        child: const Text(
                                                            'Cancel')),
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          var result = await DataRepo()
                                                              .updateShiftUser(
                                                                  snap.data[
                                                                          'data']
                                                                      [0]['id'],
                                                                  'confirmed');

                                                          if (!result[
                                                              'errorsExists']) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                              content: Text(
                                                                  "Shift was confirmed."),
                                                              backgroundColor:
                                                                  Colors.green,
                                                            ));
                                                            Navigator.pop(
                                                                context, true);
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                              content: Text(
                                                                  "Shift was Not confirmed."),
                                                              backgroundColor:
                                                                  Colors.red,
                                                            ));
                                                            Navigator.pop(
                                                                context, false);
                                                          }
                                                        },
                                                        child:
                                                            const Text('Save')),
                                                  ],
                                                );
                                              })
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Shift has been confirmed already."),
                                              backgroundColor: Colors.green,
                                            ));
                                    },
                                    child: ShiftCard(
                                        snap.data['data'][0]['shiftStatus'],
                                        snap.data['data'][0]['shift']
                                            ['shiftType'],
                                        snap.data['data'][0]['date'],
                                        screenHeight,
                                        150),
                                  );
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
                                : ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: snap.data['data'].length,
                                    itemBuilder: (context, index) {
                                      var item = snap.data['data'][index];
                                      return GestureDetector(
                                        onTap: () async => {
                                          item['shiftStatus'] == "initial"
                                              ? await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          "Confirm Shift"),
                                                      content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context,
                                                                  false);
                                                            },
                                                            child: const Text(
                                                                'Cancel')),
                                                        ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              var result = await DataRepo()
                                                                  .updateShiftUser(
                                                                      snap.data['data']
                                                                              [
                                                                              0]
                                                                          [
                                                                          'id'],
                                                                      'confirmed');

                                                              if (!result[
                                                                  'errorsExists']) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        const SnackBar(
                                                                  content: Text(
                                                                      "Shift was confirmed."),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                ));
                                                                Navigator.pop(
                                                                    context,
                                                                    true);
                                                              } else {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        const SnackBar(
                                                                  content: Text(
                                                                      "Shift was Not confirmed."),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ));
                                                                Navigator.pop(
                                                                    context,
                                                                    false);
                                                              }
                                                            },
                                                            child: const Text(
                                                                'Save')),
                                                      ],
                                                    );
                                                  })
                                              : ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Shift has been confirmed already."),
                                                  backgroundColor: Colors.green,
                                                ))
                                        },
                                        child: ShiftCard(
                                            item['shiftStatus'],
                                            item['shift']['shiftType'],
                                            item['date'],
                                            screenHeight,
                                            100),
                                      );
                                    },
                                  );
                            // : GestureDetector(
                            //   onTap: () async {
                            //
                            //     var response = await showDialog(context: context, builder: (context) {
                            //       return AlertDialog(
                            //         title: Text("Confirm Shift"),
                            //         content: Column(
                            //           mainAxisSize: MainAxisSize.min,
                            //           children: [],
                            //         ),
                            //         actions: [
                            //           TextButton(onPressed: () {
                            //             Navigator.pop(context, false);
                            //           }, child: const Text('Cancel')),
                            //           ElevatedButton(onPressed: () async {
                            //             var result = await DataRepo().updateShiftUser(snap.data['data'][0]['id'], 'confirmed');
                            //             print(result);
                            //             if(!result['errorsExists']){
                            //               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Shift was confirmed."), backgroundColor: Colors.green,));
                            //               Navigator.pop(context, true);
                            //             }
                            //             else {
                            //               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Shift was Not confirmed."), backgroundColor: Colors.red,));
                            //               Navigator.pop(context, false);
                            //             }
                            //           }, child: const Text('Save')),
                            //         ],
                            //       );
                            //     });
                            //   },
                            //   child: ShiftCard(
                            //       snap.data['data'][0]['shiftStatus'],
                            //       snap.data['data'][0]['shift']['shiftType'],
                            //       snap.data['data'][0]['date'],
                            //       screenHeight,
                            //       150),
                            // );
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
