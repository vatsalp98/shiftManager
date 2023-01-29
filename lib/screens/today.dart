import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shift_manager/shared/shift_card.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../repositories/data_repo.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({Key? key}) : super(key: key);

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  _fetchTodayShift() async {
    final now = DateTime.now();
    final user = await Amplify.Auth.getCurrentUser();
    final response = await DataRepo()
        .listShiftDayUsers(user.userId, DataRepo().awsDateFormat.format(now));
    return response;
  }

  final GlobalKey<SlideActionState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 55, left: 10, bottom: 5),
            child: Text(
              'Attendance',
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
              "Today's Shift",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FutureBuilder(
              future: _fetchTodayShift(),
              builder: (context, snap) {
                if (snap.hasData &&
                    snap.connectionState == ConnectionState.done) {
                  var data = snap.data as Map;
                  if (!data['empty']) {
                    return Column(
                      children: [
                        shiftCard(
                          data['data'][0]['shiftStatus'],
                          data['data'][0]['shift']['shiftType'],
                          data['data'][0]['date'],
                          screenHeight,
                          180,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                  text: "${DateTime.now().day} ",
                                  style: TextStyle(
                                    fontSize: screenHeight / 35,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: DateFormat('MMMM yyyy')
                                          .format(DateTime.now()),
                                      style: TextStyle(
                                        fontSize: screenHeight / 40,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                        StreamBuilder(
                          stream: Stream.periodic(const Duration(seconds: 1)),
                          builder: (context, snapshot) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    text: DataRepo()
                                        .humanTimeFormat
                                        .format(DateTime.now()),
                                    style: TextStyle(
                                      fontSize: screenHeight / 45,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Container(
                            height: 150,
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
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Check-In',
                                        style: TextStyle(
                                          fontSize: screenHeight / 50,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        data['data'][0]['checkIn'] ?? "--/--",
                                        style: TextStyle(
                                          fontSize: screenHeight / 45,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Check-Out',
                                        style: TextStyle(
                                          fontSize: screenHeight / 50,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        data['data'][0]['checkOut'] ?? "--/--",
                                        style: TextStyle(
                                          fontSize: screenHeight / 45,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        data['data'][0]['checkOut'] == null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 25.0),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: SlideAction(
                                    text: data['data'][0]['isCheckedIn']
                                        ? "Slide to Check-Out"
                                        : "Slide to Check-In",
                                    key: _key,
                                    outerColor: Colors.white,
                                    innerColor: Colors.red,
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenHeight / 40,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    elevation: 15,
                                    onSubmit: () async {
                                      if (!data['data'][0]['isCheckedIn']) {
                                        final result = await DataRepo()
                                            .updateShiftUserCheckIn(
                                                data['data'][0]['id'],
                                                DataRepo()
                                                    .awsTimeFormat
                                                    .format(DateTime.now()));

                                        if (!result['errorsExists']) {
                                          _key.currentState!.reset();
                                          setState(() {});
                                        }
                                      } else {
                                        final result = await DataRepo()
                                            .updateShiftUserCheckOut(
                                                data['data'][0]['id'],
                                                DataRepo()
                                                    .awsTimeFormat
                                                    .format(DateTime.now()));
                                        if (!result['errorsExists']) {
                                          _key.currentState!.reset();
                                          setState(() {});
                                        }
                                      }
                                    },
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 35.0),
                                child: Container(
                                  height: 70,
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
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.green,
                                        size: 35,
                                      ),
                                      Text(
                                        'Shift Completed!',
                                        style: TextStyle(
                                          fontSize: screenHeight / 45,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(top: screenHeight / 5),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: SvgPicture.asset(
                                'assets/svg/no_data.svg',
                                height: 250,
                                width: 250,
                              ),
                            ),
                            Text(
                              'No Shift Assigned for the Day',
                              style: TextStyle(
                                fontSize: screenHeight / 45,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Enjoy your free day!',
                              style: TextStyle(
                                fontSize: screenHeight / 45,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
