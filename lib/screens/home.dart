import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:shift_manager/repositories/data_repo.dart';

import '../shared/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  _fetchShifts() async {
    final response = await DataRepo().listShiftUsers();
    if (!response['errorsExists'] && !response['empty']) {
      return response;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
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
                        future: Amplify.Auth.getCurrentUser(),
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
              child: Container(
                height: screenHeight,
                child: FutureBuilder(
                  future: _fetchShifts(),
                  builder: (context, snap) {
                    if (snap.hasData &&
                        snap.connectionState == ConnectionState.done) {
                      var data = snap.data as Map;
                      if (data['empty']) {
                        return SvgPicture.asset('assets/svg/no_data.svg');
                      } else {
                        for (var item in data['data']) {
                          if (DateTime.parse(item['date'])
                              .isAtSameMomentAs(DateTime.now())) {
                            return Container();
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 170,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                        offset: Offset(2, 2),
                                      )
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0),
                                            child: Text(
                                              'You have no shifts today!',
                                              style: TextStyle(
                                                fontSize: screenHeight / 45,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          SvgPicture.asset(
                                            'assets/svg/no_data.svg',
                                            height: 100,
                                            width: 100,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 9.0, top: 30),
                                  child: Text(
                                    'Upcoming Shifts',
                                    style: TextStyle(
                                      fontSize: screenHeight / 40,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 9.0, bottom: 5),
                                  child: Text(
                                    '(Red Background = Unconfirmed, Green = Confirmed), Tap on a shift to Confirm or Cancel it',
                                    style: TextStyle(
                                      fontSize: screenHeight / 68,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 300,
                                  child: ListView(
                                    physics: const BouncingScrollPhysics(),
                                    children: [
                                      for (var item in data['data'])
                                        Container(
                                          height: 120,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 10,
                                                offset: Offset(2, 2),
                                              )
                                            ],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.only(),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        item['shiftStatus'] ==
                                                                "initial"
                                                            ? HexColor(
                                                                '#D2042D')
                                                            : Colors.green,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "${item['shift']['shiftType']} Shift",
                                                          style: TextStyle(
                                                            fontSize:
                                                                screenHeight /
                                                                    50,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        Text(
                                                          DateFormat(
                                                                  'dd MMM yyyy')
                                                              .format(DateTime
                                                                  .parse(item[
                                                                      'date'])),
                                                          style: TextStyle(
                                                            fontSize:
                                                                screenHeight /
                                                                    50,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        // Text(
                                                        //   item['shiftStatus'],
                                                        //   style: TextStyle(
                                                        //     fontSize:
                                                        //         screenHeight /
                                                        //             50,
                                                        //     fontWeight:
                                                        //         FontWeight.w500,
                                                        //     color: Colors.white,
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Check In',
                                                      style: TextStyle(
                                                        fontSize:
                                                            screenHeight / 50,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      item['shift']['startTime']
                                                          .substring(0, 5),
                                                      style: TextStyle(
                                                        fontSize:
                                                            screenHeight / 45,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Check Out',
                                                      style: TextStyle(
                                                        fontSize:
                                                            screenHeight / 50,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      item['shift']['endTime']
                                                          .substring(0, 5),
                                                      style: TextStyle(
                                                        fontSize:
                                                            screenHeight / 45,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                        }
                        return Container();
                      }
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
